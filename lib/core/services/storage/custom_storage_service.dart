import 'package:get/get.dart';
import 'package:hive/hive.dart';

import 'storage_key_enums.dart';

class CustomStorageService extends GetxService {
  static Box<dynamic>? _storage;

  @override
  void onInit() {
    _storage = Hive.box(StorageKeys.customStorage.name);
    super.onInit();
  }

  bool isExist(String key) {
    return (_storage?.get(key) != null);
  }

  Future<void> write(String key, dynamic value) async {
    await _storage?.put(key, value);
  }

  T? read<T>(String key) {
    return _storage?.get(key);
  }

  Future<void> remove(String key) async {
    return await _storage?.delete(key);
  }

  Future<void> cleanStorage() async {
    await _storage?.clear();
  }
}
