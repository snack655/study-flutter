import 'dart:io';

import 'package:flutter/material.dart';

import '../../components/medi_constants.dart';
import '../../components/medi_page_route.dart';
import '../../main.dart';
import '../../models/medicine_alarm.dart';
import '../../models/medicine_history.dart';
import '../bottomsheet/time_setting_bottomsheet.dart';
import 'image_detail_page.dart';

class BeforeTakeTile extends StatelessWidget {
  const BeforeTakeTile({
    super.key,
    required this.medicineAlarm,
  });

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return Row(
      children: [
        _MedicineImageButton(medicineAlarm: medicineAlarm),
        const SizedBox(width: smallSpace),
        Expanded(
          child: _buildTimeBody(textStyle, context),
        ),
        _MoreButton(medicineAlarm: medicineAlarm),
      ],
    );
  }

  Column _buildTimeBody(TextStyle? textStyle, BuildContext context) {
    return Column(
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
    );
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    super.key,
    required this.medicineAlarm,
  });

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return Row(
      children: [
        Stack(
          children: [
            _MedicineImageButton(medicineAlarm: medicineAlarm),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.green.withOpacity(0.7),
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(width: smallSpace),
        Expanded(
          child: _buildTimeBody(textStyle, context),
        ),
        _MoreButton(medicineAlarm: medicineAlarm),
      ],
    );
  }

  Column _buildTimeBody(TextStyle? textStyle, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: '✅ ${medicineAlarm.alarmTime} -> ',
            style: textStyle,
            children: [
              TextSpan(
                text: '20:19',
                style: textStyle?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
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
              title: '20시 19분에',
            ),
            Text('|', style: textStyle),
            Text('먹었어요!', style: textStyle),
          ],
        )
      ],
    );
  }
}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    required this.medicineAlarm,
  });

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        medicineRepository.deleteMedicine(medicineAlarm.key);
      },
      child: const Icon(Icons.more_vert),
    );
  }
}

class _MedicineImageButton extends StatelessWidget {
  const _MedicineImageButton({
    required this.medicineAlarm,
  });

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
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
