import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/presence_details_controller.dart';

class PresenceDetailsView extends GetView<PresenceDetailsController> {
  const PresenceDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('DETAIL PRESENSI'),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200]),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMEEEEd().format(DateTime.now()),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Masuk',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Jam: ${DateFormat.jms().format(DateTime.now())}'),
                    Text('Posisi: -8934292837423, 3294823'),
                    Text('Status: Di dalam area'),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Keluar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('Jam: ${DateFormat.jms().format(DateTime.now())}'),
                    Text('Posisi: -8934292837423, 3294823'),
                    Text('Status: Di dalam area'),
                  ]),
            ),
          ],
        ));
  }
}
