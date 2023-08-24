import 'package:get/get.dart';
import 'project_list_controller.dart';

class ProjectListBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProjectListController());
  }
}
