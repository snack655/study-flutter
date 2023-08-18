import 'package:flutter/material.dart';
import 'package:medi/pages/home_page.dart';
import 'package:medi/repositories/medi_hive.dart';
import 'package:medi/repositories/medicine_history_repository.dart';
import 'package:medi/repositories/medicine_repository.dart';
import 'package:medi/services/medi_notification_service.dart';
import 'components/medi_themes.dart';

final notification = MediNotificationService();
final hive = MediHive();
final medicineRepository = MedicineRepository();
final historyRepository = MedicineHistoryRepository();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await notification.initializeTimeZone();
  await notification.initializeNotification();

  await hive.initializeHive();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MediThemes.lightTheme,
      home: const HomePage(),
    );
  }
}
