import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:medi/main.dart';

import '../../components/medi_constants.dart';
import '../../models/medicine.dart';
import '../../models/medicine_history.dart';
import '../today/today_take_tile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '잘 복용 했어요 👏',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: regularSpace),
        const Divider(height: 1, thickness: 1.0),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: historyRepository.historyBox.listenable(),
            builder: _buildListView,
          ),
        ),
      ],
    );
  }

  Widget _buildListView(context, Box<MedicineHistory> historyBox, _) {
    final histories = historyBox.values.toList().reversed.toList();
    return ListView.builder(
      itemCount: histories.length,
      itemBuilder: (context, index) {
        final history = histories[index];
        return _TimeTile(history: history);
      },
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    required this.history,
  });

  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            // '2021\n08.02.수'
            DateFormat('yyyy\nMM.dd E', 'ko_KR').format(history.takeTime),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  height: 1.6,
                  leadingDistribution: TextLeadingDistribution.even,
                ),
          ),
        ),
        const Stack(
          alignment: Alignment(0.0, -0.3),
          children: [
            SizedBox(
              height: 130,
              child: VerticalDivider(
                width: 1,
                thickness: 1,
              ),
            ),
            CircleAvatar(
              radius: 4,
              child: CircleAvatar(
                radius: 3,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: medicine.imagePath != null,
                child: MedicineImageButton(imagePath: medicine.imagePath),
              ),
              const SizedBox(width: smallSpace),
              Text(
                '${DateFormat("a hh:mm", "ko").format(history.takeTime)}\n${medicine.name}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      height: 1.6,
                      leadingDistribution: TextLeadingDistribution.even,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Medicine get medicine {
    return medicineRepository.medicineBox.values.singleWhere(
      (element) =>
          element.id == history.medicineId &&
          element.key == history.medicineKey,
      orElse: () =>
          Medicine(alarms: [], id: -1, imagePath: null, name: '삭제된 약입니다.'),
    );
  }
}
