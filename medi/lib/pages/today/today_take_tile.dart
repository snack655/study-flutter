import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medi/pages/add/add_medicine_page.dart';
import 'package:medi/pages/bottomsheet/more_action_bottomsheet.dart';

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
        MedicineImageButton(imagePath: medicineAlarm.imagePath),
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
              onTap: () {
                historyRepository.addHistory(
                  MedicineHistory(
                    medicineId: medicineAlarm.id,
                    medicineKey: medicineAlarm.key,
                    alarmTime: medicineAlarm.alarmTime,
                    takeTime: DateTime.now(),
                    imagePath: medicineAlarm.imagePath,
                    name: medicineAlarm.name,
                  ),
                );
              },
              title: '지금',
            ),
            Text('|', style: textStyle),
            TileActionButton(
              onTap: () => _onPreviousTake(context),
              title: '아까',
            ),
            Text('먹었어요!', style: textStyle),
          ],
        )
      ],
    );
  }

  void _onPreviousTake(BuildContext context) {
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
          medicineKey: medicineAlarm.key,
          imagePath: medicineAlarm.imagePath,
          name: medicineAlarm.name,
        ),
      );
    });
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    super.key,
    required this.medicineAlarm,
    required this.history,
  });

  final MedicineAlarm medicineAlarm;
  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return Row(
      children: [
        Stack(
          children: [
            MedicineImageButton(imagePath: medicineAlarm.imagePath),
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
                text: takeTimeStr,
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
              onTap: () => _onTap(context),
              title: DateFormat("HH시 mm분에").format(history.takeTime),
            ),
            Text('먹었어요!', style: textStyle),
          ],
        )
      ],
    );
  }

  String get takeTimeStr => DateFormat('HH:mm').format(history.takeTime);

  void _onTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => TimeSettingBottomSheet(
        initialTime: takeTimeStr,
        submitTitle: "수정",
        bottomWidget: TextButton(
          onPressed: () {
            historyRepository.deleteHistory(history.key);
            Navigator.pop(context);
          },
          child: Text(
            '복약 시간을 지우고 싶어요.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    ).then((takeDateTime) {
      if (takeDateTime == null || takeDateTime is! DateTime) {
        return;
      }

      historyRepository.updateHistory(
        key: history.key,
        medicineHistory: MedicineHistory(
          medicineId: medicineAlarm.id,
          alarmTime: medicineAlarm.alarmTime,
          takeTime: takeDateTime,
          medicineKey: medicineAlarm.key,
          imagePath: medicineAlarm.imagePath,
          name: medicineAlarm.name,
        ),
      );
    });
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
        //medicineRepository.deleteMedicine(medicineAlarm.key);
        showModalBottomSheet(
          context: context,
          builder: (context) => MoreActionBottomSheet(
            onPressedModify: () {
              Navigator.push(
                context,
                FadePageRoute(
                    page: AddMedicinePage(updateMedicineId: medicineAlarm.id)),
              ).then((_) => Navigator.maybePop(context));
            },
            onPressedDeleteOnlyMedicine: () {
              // 1. 알람 색제
              notification.deleteMultipleAlarm(alarmIds);
              // 2. hive 데이터 삭제
              medicineRepository.deleteMedicine(medicineAlarm.key);
              // 3. Pop
              Navigator.pop(context);
            },
            onPressedDeleteAll: () {
              // 1. 알람 삭제
              notification.deleteMultipleAlarm(alarmIds);
              // 2. hive history 데이터 삭제
              historyRepository.deleteAllHistory(keys);
              // 3. hive medicine 데이터 삭제
              medicineRepository.deleteMedicine(medicineAlarm.key);
              // 4. Pop
              Navigator.pop(context);
            },
          ),
        );
      },
      child: const Icon(Icons.more_vert),
    );
  }

  List<String> get alarmIds {
    final medicine = medicineRepository.medicineBox.values
        .singleWhere((element) => element.id == medicineAlarm.id);
    final alarmIds = medicine.alarms
        .map((alarmStr) => notification.alarmId(medicineAlarm.id, alarmStr))
        .toList();
    return alarmIds;
  }

  Iterable<int> get keys {
    final histories = historyRepository.historyBox.values.where((history) =>
        history.medicineId == medicineAlarm.id &&
        history.medicineKey == medicineAlarm.key);
    final keys = histories.map((e) => e.key as int);
    return keys;
  }
}

class MedicineImageButton extends StatelessWidget {
  const MedicineImageButton({
    super.key,
    required this.imagePath,
  });

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: imagePath == null
          ? null
          : () {
              Navigator.push(
                context,
                FadePageRoute(
                  page: ImageDetailPage(imagePath: imagePath!),
                ),
              );
            },
      child: CircleAvatar(
        radius: 40,
        foregroundImage: imagePath == null ? null : FileImage(File(imagePath!)),
        child: imagePath == null ? const Icon(Icons.alarm) : null,
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
