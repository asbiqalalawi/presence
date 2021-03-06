import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fIrestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 1:
        Map<String, dynamic> dataResponse = await determinePosition();

        if (dataResponse['status']) {
          Position position = dataResponse['position'];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String address = '${placemarks[0].street}, ${placemarks[0].locality}';
          await updatePosition(position, address);

          double distance = Geolocator.distanceBetween(
              -6.7190683, 108.3590556, position.latitude, position.longitude);

          await presence(position, address, distance);
        } else {
          Get.snackbar('Terjadi Kesalahan', dataResponse['message']);
        }
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> presence(
      Position position, String address, double distance) async {
    String uid = auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> colPresence =
        fIrestore.collection('employee').doc(uid).collection('presence');

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime date = DateTime.now();
    String todayDocId = DateFormat.yMd().format(date).replaceAll('/', '-');

    String status = 'Di Luar Area.';

    if (distance <= 200) {
      status = 'Di Dalam Area.';
    }

    if (snapPresence.docs.isEmpty) {
      // Belum Pernah Absen dan Set Absensi Masuk Pertama kali

      await Get.defaultDialog(
        title: 'Validasi Presensi',
        middleText:
            'Apakah Anda yakin ingin mengisi daftar hadir (Masuk) sekarang?',
        actions: [
          OutlinedButton(
            onPressed: () => Get.back(),
            child: const Text(
              "Cancel",
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await colPresence.doc(todayDocId).set({
                'date': date.toIso8601String(),
                'masuk': {
                  'date': date.toIso8601String(),
                  'lat': position.latitude,
                  'long': position.longitude,
                  'address': address,
                  'status': status,
                  'distance': distance,
                }
              });
              Get.snackbar('Berhasil', 'Berhasil melakukan absen masuk.');
            },
            child: const Text('Yes'),
          )
        ],
      );
    } else {
      // Sudah pernah absen dan cek apakalah sudah absen dihari tersebut
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocId).get();

      if (todayDoc.exists) {
        Map<String, dynamic>? dataPeresenceToday = todayDoc.data();
        if (dataPeresenceToday?['keluar'] != null) {
          // SUdah Absen masuk dan keluar
          Get.snackbar('Sukses', 'Anda sudah absen masuk dan keluar.');
        } else {
          // Absen Keluar
          await Get.defaultDialog(
            title: 'Validasi Presensi',
            middleText:
                'Apakah Anda yakin ingin mengisi daftar hadir (Keluar) sekarang?',
            actions: [
              OutlinedButton(
                onPressed: () => Get.back(),
                child: const Text(
                  "Cancel",
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  Get.back();
                  await colPresence.doc(todayDocId).update({
                    'date': date.toIso8601String(),
                    'keluar': {
                      'date': date.toIso8601String(),
                      'lat': position.latitude,
                      'long': position.longitude,
                      'address': address,
                      'status': status,
                      'distance': distance,
                    }
                  });

                  Get.snackbar('Berhasil', 'Berhasil melakukan absen keluar.');
                },
                child: const Text('Yes'),
              )
            ],
          );
        }
      } else {
        // Absen masuk
        await Get.defaultDialog(
          title: 'Validasi Presensi',
          middleText:
              'Apakah Anda yakin ingin mengisi daftar hadir (Masuk) sekarang?',
          actions: [
            OutlinedButton(
              onPressed: () => Get.back(),
              child: const Text(
                "Cancel",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back();
                await colPresence.doc(todayDocId).set({
                  'date': date.toIso8601String(),
                  'masuk': {
                    'date': date.toIso8601String(),
                    'lat': position.latitude,
                    'long': position.longitude,
                    'address': address,
                    'status': status,
                    'distance': distance,
                  }
                });

                Get.snackbar('Berhasil', 'Berhasil melakukan absen masuk.');
              },
              child: const Text('Yes'),
            )
          ],
        );
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser!.uid;

    await fIrestore.collection('employee').doc(uid).update({
      'position': {
        'lat': position.latitude,
        'long': position.longitude,
      },
      'address': address,
    });
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        'status': false,
        'message': 'Layanan lokasi dinonaktifkan.',
      };
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          'status': false,
          'message': 'Izin lokasi ditolak.',
        };
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        'status': false,
        'message': 'Izin lokasi ditolak secara permanen.',
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return {
      'status': true,
      'position': position,
      'message': 'Berhasil mendapatkan posisi device.',
    };
  }
}
