import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/medi_colors.dart';
import '../../components/medi_constants.dart';
import '../../components/medi_widgets.dart';

class TimeSettingBottomSheet extends StatelessWidget {
  const TimeSettingBottomSheet({
    super.key,
    required this.initialTime,
    this.submitTitle = "선택",
    this.bottomWidget,
  });

  final String initialTime;
  final String submitTitle;
  final Widget? bottomWidget;

  @override
  Widget build(BuildContext context) {
    final initialDateTimeData = DateFormat("HH:mm").parse(initialTime);
    final now = DateTime.now();
    final initialDateTime = DateTime(now.year, now.month, now.day,
        initialDateTimeData.hour, initialDateTimeData.minute);
    DateTime setDateTime = initialDateTime;

    return BottomSheetBody(
      children: [
        SizedBox(
          height: 200,
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime) {
              setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time,
            initialDateTime: initialDateTime,
          ),
        ),
        const SizedBox(height: smallSpace),
        if (bottomWidget != null) bottomWidget!,
        const SizedBox(height: smallSpace),
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
                  onPressed: () => Navigator.pop(context, setDateTime),
                  child: Text(submitTitle),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
