import 'package:flutter/material.dart';
import 'package:medi/components/medi_constants.dart';

class TodayEmpty extends StatelessWidget {
  const TodayEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Center(child: Text('추가된 약이 없습니다.')),
        const SizedBox(height: smallSpace),
        Text(
          '약을 추가해주세요',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: smallSpace),
        const Icon(Icons.arrow_downward_outlined),
        const SizedBox(height: largeSpace),
      ],
    );
  }
}
