import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../common/widgets/appbar/default_app_bar.dart';
import '../common/widgets/other/custom_scaffold.dart';
import '../common/widgets/textfield/custom_search_bar.dart';
import '../common/widgets/texts/custom_text.dart';
import 'widgets/project_card.dart';
import '../../../core/models/project_model.dart';
import '../../../core/variables/colors.dart';
import 'project_list_controller.dart';
import '../../../../../../core/utils/utils.dart';

class ProjectListView extends GetView<ProjectListController> {
  const ProjectListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      useSingleChildScrollView: false,
      appBar: _buildAppBar,
      floatingActionButton: fabButton(),
      body: Padding(
        padding: EdgeInsets.only(top: Utils.normalPadding),
        child: Column(
          children: [
            CustomSearchBar(
                onChangeComplete: (val) => controller.searchKey = val, hintText: "Search Project With Name", leadingIcon: const Icon(Icons.search)),
            SizedBox(height: Utils.normalPadding),
            Expanded(child: projectListView()),
            logList(),
          ],
        ),
      ),
    );
  }

  Obx logList() {
    return Obx(
      () => controller.log.isEmpty
          ? const SizedBox.shrink()
          : SizedBox(
              height: Get.height * 0.2,
              child: DecoratedBox(
                decoration: BoxDecoration(color: ColorTable.getReversedTextColor, border: Border.all(color: Get.theme.primaryColor)),
                child: Padding(
                  padding: EdgeInsets.all(Utils.lowPadding),
                  child: Column(
                    children: [
                      CustomText("Log List"),
                      Expanded(
                        child: ListView.separated(
                          controller: controller.scrollController,
                          itemBuilder: (context, index) => logCard(index),
                          separatorBuilder: (context, index) => SizedBox(height: Utils.extraLowPadding),
                          itemCount: controller.log.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Row logCard(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText("SYSTEM:", textColor: Get.theme.primaryColor, bold: true),
        CustomText(controller.log[index]),
      ],
    );
  }

  Obx projectListView() {
    return Obx(() {
      if (controller.state == ProjectListState.Busy) {
        return Center(
          child: CircularProgressIndicator(strokeWidth: Utils.normalPadding, color: Get.theme.primaryColor),
        );
      }
      if (controller.projectList.isEmpty && controller.state != ProjectListState.Busy) {
        return Center(child: CustomText("We Cannot Find Any Saved Project"));
      }
      List<ProjectModel> searchedList =
          controller.projectList.where((e) => (e.projectName ?? "").toLowerCase().contains(controller.searchKey.toLowerCase())).toList();
      return ListView.separated(
        itemCount: searchedList.length,
        separatorBuilder: (context, index) => SizedBox(height: Utils.normalPadding),
        itemBuilder: (context, index) {
          ProjectModel projectModel = searchedList[index];
          return Obx(
            () => ProjectCard(
              deleteOnTap: () => controller.deleteOnTap(projectModel),
              projectModel: projectModel,
              uploadOnTap: () => controller.uploadOnTap(projectModel),
              platformOnTap: (newProjectModel) => controller.platformOnTap(projectModel, newProjectModel),
              projectState: controller.projectState[projectModel] ?? false,
            ),
          );
        },
      );
    });
  }

  FloatingActionButton fabButton() {
    return FloatingActionButton(
      backgroundColor: Get.theme.primaryColor,
      child: Icon(Icons.add, size: Utils.extraHighIconSize * 1.4),
      onPressed: () async => await controller.fabButtonOnTap(),
    );
  }

  DefaultAppBar get _buildAppBar => DefaultAppBar(
        title: CustomText.extraHigh('Flutter Version Upload Tool', textColor: Get.theme.primaryColor),
        centerTitle: true,
        showLeadingBackIcon: false,
        onLeadingPressed: () => Get.back(),
      );
}
