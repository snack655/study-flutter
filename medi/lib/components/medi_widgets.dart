import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'medi_constants.dart';

class BottomSheetBody extends StatelessWidget {
  const BottomSheetBody({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

void showPermissionDenied(
  BuildContext context, 
  {required String permission,}
) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$permission 권한이 없습니다.'),
          const TextButton(
            onPressed: openAppSettings,
            child: Text("설정창으로 이동"),
          )
        ],
      ),
    ),
  );
}
