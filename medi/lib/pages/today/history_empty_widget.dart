import 'package:flutter/material.dart';
import 'package:medi/components/medi_constants.dart';

class HistoryEmpty extends StatelessWidget {
  const HistoryEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Center(child: Text('복약한 기록이 없습니다')),
        const SizedBox(height: smallSpace),
        Text(
          '약 복용 후 복용했다고 알려주세요',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: largeSpace),
        const Align(
          alignment: Alignment(-0.6, 0),
          child: Icon(Icons.arrow_downward_outlined),
        ),
        const SizedBox(height: regularSpace),
      ],
    );
  }
}
