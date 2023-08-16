import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medi/components/medi_colors.dart';
import 'package:medi/components/medi_constants.dart';
import 'package:medi/components/medi_widgets.dart';
import 'package:medi/services/add_medicine_service.dart';
import '../../main.dart';
import 'components/add_page_widget.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage({
    super.key,
    required this.medicineImage,
    required this.medicineName,
  });

  final File? medicineImage;
  final String medicineName;

  final service = AddMedicineService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(
        children: [
          Text(
            '매일 복약 잊지 말아요!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: largeSpace),
          Expanded(
            child: AnimatedBuilder(
              builder: (context, _) {
                return ListView(
                  children: alarmWidgets,
                );
              },
              animation: service,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomSubmitButton(
        onPressed: () async {
          bool result = false;
          // 1. add alarm
          for (var alarm in service.alarms) {
            result = await notification.addNotification(
              alarmTimeStr: alarm,
              title: '$alarm 약 먹을 시간이예요!', 
              body: '$medicineName 복약헀다고 알려주세요!',
            );
          }
          if (!result) {
            if(context.mounted) return;
            showPermissionDenied(context, permission: '알람');
          }
          // 2. save image (local dir)
          // 3. add medicine model (local DB, hive)
        },
        text: "완료",
      ),
    );
  }

  List<Widget> get alarmWidgets {
    final children = <Widget>[];
    children.addAll(
      service.alarms.map(
        (alarmTime) => AlarmBox(
          time: alarmTime,
          service: service,
        ),
      ),
    );
    children.add(
      AddAlarmButton(
        service: service,
      ),
    );
    return children;
  }
}

class AlarmBox extends StatelessWidget {
  const AlarmBox({
    super.key,
    required this.time,
    required this.service,
  });

  final String time;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: IconButton(
              onPressed: () {
                service.removeAlarm(time);
              },
              icon: const Icon(Icons.remove_circle_outline)),
        ),
        Expanded(
          flex: 5,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.titleMedium,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return TimePickerBottomSheet(
                    initialTime: time,
                    service: service,
                  );
                },
              );
            },
            child: Text(time),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class TimePickerBottomSheet extends StatelessWidget {
  TimePickerBottomSheet({
    super.key,
    required this.initialTime,
    required this.service,
  });

  final String initialTime;
  final AddMedicineService service;
  DateTime? _setDateTime;

  @override
  Widget build(BuildContext context) {
    final initialDateTime = DateFormat("HH:mm").parse(initialTime);

    return BottomSheetBody(
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime) {
              _setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time,
            initialDateTime: initialDateTime,
          ),
        ),
        const SizedBox(height: regularSpace),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: MediColors.primaryColor,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("취소"),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MediColors.primaryColor,
                    textStyle: Theme.of(context).textTheme.titleMedium,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    service.setAlarm(
                        prevTime: initialTime,
                        setTime: _setDateTime ?? initialDateTime);
                    Navigator.pop(context);
                  },
                  child: const Text("선택"),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class AddAlarmButton extends StatelessWidget {
  const AddAlarmButton({
    super.key,
    required this.service,
  });

  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        textStyle: Theme.of(context).textTheme.titleLarge,
      ),
      onPressed: service.addNowAlarm,
      child: const Row(
        children: [
          Expanded(flex: 1, child: Icon(Icons.add_circle)),
          Expanded(
            flex: 5,
            child: Center(child: Text('복용시간 추가')),
          ),
        ],
      ),
    );
  }
}
