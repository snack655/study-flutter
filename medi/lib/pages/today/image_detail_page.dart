import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/medicine_alarm.dart';

class ImageDetailPage extends StatelessWidget {
  const ImageDetailPage({
    super.key,
    required this.medicineAlarm,
  });

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: Center(
        child: Image.file(
          File(medicineAlarm.imagePath!),
        ),
      ),
    );
  }
}
