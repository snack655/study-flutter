import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medi/components/medi_constants.dart';
import 'package:medi/main.dart';
import 'package:medi/models/medicine_alarm.dart';
import 'package:medi/models/medicine_history.dart';
import 'package:medi/pages/today/today_empty_widget.dart';
import 'package:medi/pages/today/today_take_tile.dart';
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

    medicineAlarms.sort((a, b) => DateFormat('HH:mm')
        .parse(a.alarmTime)
        .compareTo(DateFormat('HH:mm').parse(b.alarmTime)));

    return Column(
      children: [
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: smallSpace),
            itemCount: medicineAlarms.length,
            itemBuilder: (context, index) {
              return _buildListTile(medicineAlarms[index]);
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

  Widget _buildListTile(MedicineAlarm medicineAlarm) {
    return ValueListenableBuilder(
      valueListenable: historyRepository.historyBox.listenable(),
      builder: (context, Box<MedicineHistory> historyBox, _) {
        if (historyBox.values.isEmpty) {
          return BeforeTakeTile(medicineAlarm: medicineAlarm);
        }

        final todayTakeHistory = historyBox.values.singleWhere(
          (history) =>
              history.medicineId == medicineAlarm.id &&
              history.medicineKey == medicineAlarm.key &&
              history.alarmTime == medicineAlarm.alarmTime &&
              isToday(
                history.takeTime,
                DateTime.now(),
              ),
          orElse: () => MedicineHistory(
            medicineId: -1,
            alarmTime: '',
            takeTime: DateTime.now(),
            medicineKey: -1,
            imagePath: null,
            name: '',
          ),
        );

        if (todayTakeHistory.medicineId == -1 &&
            todayTakeHistory.alarmTime == '') {
          return BeforeTakeTile(
            medicineAlarm: medicineAlarm,
          );
        }

        return AfterTakeTile(
          medicineAlarm: medicineAlarm,
          history: todayTakeHistory,
        );
      },
    );
  }
}

bool isToday(DateTime source, DateTime destination) {
  return source.year == destination.year &&
      source.month == destination.month &&
      source.day == destination.day;
}
