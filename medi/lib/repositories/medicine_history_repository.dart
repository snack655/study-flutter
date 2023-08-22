import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:medi/repositories/medi_hive.dart';

import '../models/medicine_history.dart';

class MedicineHistoryRepository {
  Box<MedicineHistory>? _historyBox;

  Box<MedicineHistory> get historyBox {
    _historyBox ??= Hive.box<MedicineHistory>(MediHiveBox.medicineHistory);
    return _historyBox!;
  }

  void addHistory(MedicineHistory medicineHistory) async {
    int key = await historyBox.add(medicineHistory);

    log('[addHistory] add (key:$key) $medicineHistory');
    log('result ${historyBox.values.toList()}');
  }

  void deleteHistory(int key) async {
    await historyBox.delete(key);

    log('[deleteHistory] delete (key:$key)');
    log('result ${historyBox.values.toList()}');
  }

  void updateHistory({
    required int key,
    required MedicineHistory medicineHistory,
  }) async {
    await historyBox.put(key, medicineHistory);

    log('[updateHistory] update (key:$key) $medicineHistory');
    log('result ${historyBox.values.toList()}');
  }

  void deleteAllHistory(Iterable<int> keys) async {
    await historyBox.deleteAll(keys);
  }
}
