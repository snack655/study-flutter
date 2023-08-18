import 'package:flutter/material.dart';
import 'package:medi/components/medi_constants.dart';

class TodayPage extends StatelessWidget {
  TodayPage({super.key});

  final list = [
    '약',
    '약 이름',
    '약 이름 테스트',
    '약이름한둘약이름한둘약이름한둘약이름한둘',
    '약',
    '약 이름',
    '약 이름 테스트',
    '약이름한둘약이름한둘약이름한둘약이름한둘',
    '약',
    '약 이름',
    '약 이름 테스트',
    '약이름한둘약이름한둘약이름한둘약이름한둘',
  ];

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
        const Divider(
          height: 1,
          thickness: 2.0,
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: smallSpace),
            itemCount: list.length,
            itemBuilder: (context, index) {
              return MedicineListTile(
                name: list[index],
              );
            },
            separatorBuilder: (context, index) => const Divider(
              height: regularSpace,
            ),
          ),
        ),
      ],
    );
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall;

    return Row(
      children: [
        MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: () {},
          child: const CircleAvatar(
            radius: 40,
          ),
        ),
        const SizedBox(width: smallSpace),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '🕑 02:00',
                style: textStyle,
              ),
              const SizedBox(height: 6),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "$name,",
                    style: textStyle,
                  ),
                  TileActionButton(
                    onTap: () {},
                    title: '지금',
                  ),
                  Text('|', style: textStyle),
                  TileActionButton(
                    onTap: () {},
                    title: '아까',
                  ),
                  Text('먹었어요!', style: textStyle),
                ],
              )
            ],
          ),
        ),
        MaterialButton(
          onPressed: () {},
          child: const Icon(Icons.more_vert),
        ),
      ],
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
