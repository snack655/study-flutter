import 'package:hive_flutter/adapters.dart';
import 'package:medi/models/medicine.dart';

class MediHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>(MedicineAdapter());

    await Hive.openBox<Medicine>(MediHiveBox.medicine);
  }
}

class MediHiveBox {
  static const medicine = "medicine";
}
