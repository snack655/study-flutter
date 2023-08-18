import 'package:hive_flutter/adapters.dart';
import 'package:medi/models/medicine.dart';

import '../models/medicine_history.dart';

class MediHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>(MedicineAdapter());
    Hive.registerAdapter<MedicineHistory>(MedicineHistoryAdapter());

    await Hive.openBox<Medicine>(MediHiveBox.medicine);
    await Hive.openBox<MedicineHistory>(MediHiveBox.medicine);
  }
}

class MediHiveBox {
  static const medicine = "medicine";
  static const medicineHistory = "medicine_history";
}
