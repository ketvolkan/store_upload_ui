import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/buttons/custom_elevated_button.dart';
import '../../common/widgets/other/custom_checkbox.dart';
import '../../common/widgets/textfield/custom_text_form_field.dart';
import '../../common/widgets/texts/custom_text.dart';
import '../../../../core/models/project_model.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/variables/colors.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel projectModel;
  final Function() uploadOnTap;
  final Function() deleteOnTap;
  final Function(ProjectModel projectModel) platformOnTap;
  final bool projectState;
  const ProjectCard(
      {super.key,
      required this.projectModel,
      required this.uploadOnTap,
      required this.platformOnTap,
      required this.projectState,
      required this.deleteOnTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(Utils.normalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            flutterLogo(),
            projectInfoSide(),
            versionNumberField(),
            SizedBox(width: Utils.normalPadding),
            Row(children: [iosCheckBox(), SizedBox(width: Utils.highPadding), androidCheckBox()]),
            SizedBox(width: Get.width * 0.1, child: projectState ? loadingWidget() : uploadButton())
          ],
        ),
      ),
    );
  }

  SizedBox versionNumberField() {
    return SizedBox(
      width: Get.width * 0.09,
      child: CustomTextFormField(
        initialValue: projectModel.version,
        label: "Version",
        onChangeComplete: (val) {
          projectModel.version = val;
          platformOnTap(projectModel);
        },
      ),
    );
  }

  SizedBox loadingWidget() {
    return SizedBox.square(
      dimension: Utils.normalIconSize,
      child: FittedBox(child: CircularProgressIndicator(color: Get.theme.primaryColor, strokeWidth: Utils.lowIconSize)),
    );
  }

  CustomElevatedButton uploadButton() {
    return CustomElevatedButton(
      minimumHeight: Utils.highIconSize * 2,
      onPressed: () => uploadOnTap(),
      child: CustomText.high("Upload", textColor: ColorTable.getReversedTextColor),
    );
  }

  Column androidCheckBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText("ANDROID"),
        CustomCheckBox(
          value: projectModel.android ?? false,
          onChanged: (value) {
            projectModel.android = value;
            platformOnTap(projectModel);
          },
        ),
      ],
    );
  }

  Column iosCheckBox() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText("IOS"),
        CustomCheckBox(
          value: projectModel.ios ?? false,
          onChanged: (value) {
            projectModel.ios = value;
            platformOnTap(projectModel);
          },
        ),
      ],
    );
  }

  InkWell flutterLogo() {
    return InkWell(
      onTap: deleteOnTap,
      child: CircleAvatar(
        backgroundColor: ColorTable.errorColorLight,
        child: Icon(
          Icons.clear,
          color: ColorTable.errorColor,
        ),
      ),
    );
  }

  SizedBox projectInfoSide() {
    return SizedBox(
      width: Get.width * 0.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: Get.width * 0.2, child: CustomText.extraHigh(projectModel.projectName, bold: true)),
          SizedBox(
            width: Get.width * 0.25,
            child: CustomText(
              "/${(projectModel.path ?? "").split("/").last}",
              maxlines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: Utils.normalPadding),
          Expanded(
            child: CustomText(
              projectModel.branch,
              maxlines: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
