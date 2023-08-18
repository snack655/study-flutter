import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medi/components/medi_constants.dart';
import 'package:medi/components/medi_page_route.dart';
import 'package:medi/main.dart';
import 'package:medi/models/medicine_alarm.dart';
import 'package:medi/models/medicine_history.dart';
import 'package:medi/pages/bottomsheet/time_setting_bottomsheet.dart';
import 'package:medi/pages/today/today_empty_widget.dart';
import '../../models/medicine.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '오늘 복용할 약은?',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: regularSpace),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: medicineRepository.medicineBox.listenable(),
            builder: _builderMedicineListView,
          ),
        ),
      ],
    );
  }

  Widget _builderMedicineListView(context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    final medicineAlarms = <MedicineAlarm>[];

    if (medicines.isEmpty) {
      return const TodayEmpty();
    }

    for (var medicine in medicines) {
      for (var alarm in medicine.alarms) {
        medicineAlarms.add(
          MedicineAlarm(
            medicine.id,
            medicine.name,
            medicine.imagePath,
            alarm,
            medicine.key,
          ),
        );
      }
    }

    return Column(
      children: [
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: smallSpace),
            itemCount: medicineAlarms.length,
            itemBuilder: (context, index) {
              return MedicineListTile(
                medicineAlarm: medicineAlarms[index],
              );
            },
            separatorBuilder: (context, index) => const Divider(
              height: regularSpace,
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1.0),
      ],
    );
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    super.key,
    required this.medicineAlarm,
  });

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return Row(
      children: [
        MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: medicineAlarm.imagePath == null
              ? null
              : () {
                  Navigator.push(
                    context,
                    FadePageRoute(
                      page: ImageDetailPage(medicineAlarm: medicineAlarm),
                    ),
                  );
                },
          child: CircleAvatar(
            radius: 40,
            foregroundImage: medicineAlarm.imagePath == null
                ? null
                : FileImage(File(medicineAlarm.imagePath!)),
          ),
        ),
        const SizedBox(width: smallSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🕑 ${medicineAlarm.alarmTime}',
                style: textStyle,
              ),
              const SizedBox(height: 6),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "${medicineAlarm.name},",
                    style: textStyle,
                  ),
                  TileActionButton(
                    onTap: () {},
                    title: '지금',
                  ),
                  Text('|', style: textStyle),
                  TileActionButton(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => TimeSettingBottomSheet(
                          initialTime: medicineAlarm.alarmTime,
                        ),
                      ).then((takeDateTime) {
                        if (takeDateTime == null || takeDateTime is! DateTime) {
                          return;
                        }

                        historyRepository.addHistory(
                          MedicineHistory(
                            medicineId: medicineAlarm.id,
                            alarmTime: medicineAlarm.alarmTime,
                            takeTime: takeDateTime,
                          ),
                        );
                      });
                    },
                    title: '아까',
                  ),
                  Text('먹었어요!', style: textStyle),
                ],
              )
            ],
          ),
        ),
        MaterialButton(
          onPressed: () {
            medicineRepository.deleteMedicine(medicineAlarm.key);
          },
          child: const Icon(Icons.more_vert),
        ),
      ],
    );
  }
}

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

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    super.key,
    required this.onTap,
    required this.title,
  });

  final VoidCallback onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(fontWeight: FontWeight.w700);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title,
          style: buttonTextStyle,
        ),
      ),
    );
  }
}
