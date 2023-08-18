import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medi/components/medi_constants.dart';
import 'package:medi/components/medi_widgets.dart';
import 'package:medi/models/medicine.dart';
import 'package:medi/pages/bottomsheet/time_setting_bottomsheet.dart';
import 'package:medi/services/add_medicine_service.dart';
import 'package:medi/services/medi_file_service.dart';
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
              medicineId: medicineRepository.newId,
              alarmTimeStr: alarm,
              title: '$alarm 약 먹을 시간이예요!',
              body: '$medicineName 복약헀다고 알려주세요!',
            );
          }
          if (!result) {
            // ignore: use_build_context_synchronously
            return showPermissionDenied(context, permission: '알람');
          }

          // 2. save image (local dir)
          String? imageFilePath;
          if (medicineImage != null) {
            imageFilePath = await saveImageToLocalDirectory(medicineImage!);
          }

          // 3. add medicine model (local DB, hive)
          final medicine = Medicine(
            id: medicineRepository.newId,
            name: medicineName,
            imagePath: imageFilePath,
            alarms: service.alarms,
          );
          medicineRepository.addMedicine(medicine);

          // ignore: use_build_context_synchronously
          Navigator.popUntil(context, (route) => route.isFirst);
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
                  return TimeSettingBottomSheet(
                    initialTime: time,
                  );
                },
              ).then((value) {
                if (value == null || value is! DateTime) return;

                service.setAlarm(
                  prevTime: time,
                  setTime: value,
                );
              });
            },
            child: Text(time),
          ),
        ),
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
