import 'package:get/get.dart';
import 'package:store_upload_ui/app/modules/project_list/project_list_binding.dart';
import 'package:store_upload_ui/app/modules/project_list/project_list_view.dart';

import 'app_routes.dart';

class AppPages {
  static var PAGES = [
    GetPage(
      name: AppRoutes.PROJECTLIST,
      page: () => const ProjectListView(),
      binding: ProjectListBinding(),
    ),
  ];
}
