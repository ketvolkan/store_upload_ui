import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/models/project_model.dart';
import '../../../core/services/storage/custom_storage_service.dart';
import '../../../core/services/storage/storage_key_enums.dart';
import '../../../core/utils/getx_extensions.dart';
import '../../../core/utils/utils.dart';
import '../common/widgets/buttons/custom_inkwell.dart';
import '../common/widgets/texts/custom_text.dart';

enum ProjectListState { Initial, Busy, Error, Loaded }

class ProjectListController extends GetxController {
  final storageService = Get.find<CustomStorageService>();

  ScrollController scrollController = ScrollController();

  final RxList<String> _log = <String>[].obs;
  List<String> get log => _log.value;
  set log(List<String> val) => _log.value = val;
  get refreshLog {
    _log.refresh();
    if (scrollController.hasClients) scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  final RxList<ProjectModel> _projectList = <ProjectModel>[].obs;
  List<ProjectModel> get projectList => _projectList.value;
  set projectList(List<ProjectModel> val) => _projectList.value = val;

  final RxMap<ProjectModel, bool> _projectState = <ProjectModel, bool>{}.obs;
  Map<ProjectModel, bool> get projectState => _projectState.value;
  set projectState(Map<ProjectModel, bool> val) => _projectState.value = val;

  final Rx<ProjectListState> _state = ProjectListState.Initial.obs;
  ProjectListState get state => _state.value;
  set state(ProjectListState val) => _state.value = val;

  final Rx<String> _searchKey = "".obs;
  String get searchKey => _searchKey.value;
  set searchKey(String val) => _searchKey.value = val;

  Future<void> fabButtonOnTap() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    String branch = "main";
    ProjectModel projectModel = ProjectModel(path: selectedDirectory, branch: branch, id: Random().nextInt(999999));
    if (selectedDirectory is String) {
      List<String> branchList = await projectModel.branchList;
      if (branchList.length == 1) {
        writeSelectedProjectToStorage(branch, projectModel);
        return;
      }
      await branchSelectDialog(branchList, projectModel);
    }
  }

  Future<void> branchSelectDialog(List<String> branchList, ProjectModel projectModel) async {
    await Get.showAwesomeDialog(
      dialogType: DialogType.QUESTION,
      body: Column(
        children: [
          CustomText("Please Select Branch"),
          SizedBox(
            height: Get.height * 0.4,
            child: ListView.separated(
              itemCount: branchList.length,
              separatorBuilder: (context, index) => SizedBox(height: Utils.lowPadding),
              itemBuilder: (context, index) => CustomInkwell(
                onTap: () {
                  Get.back();
                  writeSelectedProjectToStorage(branchList[index], projectModel);
                },
                child: CustomText(branchList[index]),
              ),
            ),
          ),
        ],
      ),
      disableBtnOk: true,
      btnCancelOnPressed: () => Get.back(),
    );
  }

  @override
  void onReady() async {
    await getProjectList();
    super.onReady();
  }

  void writeSelectedProjectToStorage(String branch, ProjectModel projectModel) async {
    projectModel.branch = branch;
    projectModel.projectName = await projectModel.getProjectName;
    projectModel.version = await projectModel.getVersionName;
    projectList.add(projectModel);
    await storageService.write(StorageKeys.projectList.name, projectList);
    _projectList.refresh();
  }

  Future<void> uploadOnTap(ProjectModel projectModel) async {
    await errorHandler(
      tryMethod: () async {
        projectState[projectModel] = true;
        _projectState.refresh();
        await projectModel.build;
        await Future.delayed(const Duration(seconds: 2));
        projectState[projectModel] = false;
        _projectState.refresh();
      },
      onErr: () async => projectState[projectModel] = false,
    );
  }

  Future<void> platformOnTap(ProjectModel projectModel, ProjectModel newProjectModel) async {
    projectModel = newProjectModel;
    _projectList.refresh();
  }

  Future<void> deleteOnTap(ProjectModel projectModel) async {
    projectList.removeWhere((element) => element.id == projectModel.id);
    await storageService.remove(StorageKeys.projectList.name);
    await storageService.write(StorageKeys.projectList.name, projectList);
    _projectList.refresh();
  }

  Future<void> getProjectList() async {
    await errorHandler(
      tryMethod: () async {
        state = ProjectListState.Busy;
        List<dynamic> tmpList = (storageService.read(StorageKeys.projectList.name) ?? []);
        projectList.clear();
        for (dynamic storageData in tmpList) {
          if (storageData is! ProjectModel) return;
          storageData.projectName = await storageData.getProjectName;
          storageData.version = await storageData.getVersionName;
          projectList.add(storageData);
        }
        _projectList.refresh();
        state = ProjectListState.Loaded;
      },
      onErr: () async => state = ProjectListState.Error,
    );
  }
}
