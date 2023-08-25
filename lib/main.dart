import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'app/modules/project_list/project_list_binding.dart';
import 'core/models/project_model.dart';
import 'package:window_manager/window_manager.dart';

import 'app/modules/common/controllers/app_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'core/services/storage/custom_storage_service.dart';
import 'core/services/storage/storage_key_enums.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ProjectModelAdapter());
  await Hive.openBox(StorageKeys.customStorage.name);
  await WindowManager.instance.setMinimumSize(const Size(800, 600));
  await WindowManager.instance.setAspectRatio(16 / 9);
  await initApp();
}

Future<void> initApp() async {
  Get.put(CustomStorageService());
  Get.put(AppController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Upload",
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      opaqueRoute: Get.isOpaqueRouteDefault,
      popGesture: Get.isPopGestureEnable,
      enableLog: kDebugMode ? true : false,
      initialRoute: AppRoutes.PROJECTLIST,
      initialBinding: ProjectListBinding(),
      theme: AppThemes.light,
      getPages: AppPages.PAGES,
    );
  }
}
