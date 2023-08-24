// ignore_for_file: depend_on_referenced_packages, constant_identifier_names

import 'dart:async';

import 'package:async/async.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../app/modules/common/widgets/buttons/custom_inkwell.dart';
import '../../app/modules/common/widgets/dialog/awesome_dialog/custom_awesome_dialog.dart';
import '../../app/modules/common/widgets/texts/custom_text.dart';

import '../variables/colors.dart';
import 'utils.dart';

extension CustomGetDialogExtension on GetInterface {
  ///Awesome dialog gösterir
  ///Counter ile okey butonunda geri sayım yaptırılabilir
  Future<void> showAwesomeDialog({
    String? title,
    String? subtitle,
    Widget? body,
    String? btnCancelText,
    String? btnOkText,
    Color? headerIconColor,
    bool disableBtnOk = false,
    bool disableBtnCancel = false,
    Function()? btnOkOnPressed,
    Function()? btnCancelOnPressed,
    int counter = 0,
    bool isDisableHeader = false,
    DialogType dialogType = DialogType.INFO,
    bool dismissOnBackKeyPress = false,
    Function(DismissType type)? onDissmisCallBack,
  }) async {
    final context = Get.context;
    if (context != null) {
      CancelableOperation? cancellableOperation;
      Widget buildButton({
        required String text,
        required Color textColor,
        required Color backgroundColor,
        required Function()? onPressed,
      }) =>
          CustomInkwell(
            onTap: onPressed,
            padding: EdgeInsets.zero,
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(Utils.normalRadius),
              ),
              alignment: Alignment.center,
              padding: EdgeInsets.all(Utils.lowPadding),
              child: CustomText(text, textColor: textColor),
            ),
          );

      CustomAwesomeDialog(
              width: Get.width * 0.4,
              dialogBackgroundColor: Get.theme.scaffoldBackgroundColor,
              context: Get.context!,
              onDissmissCallback: (type) {
                if (onDissmisCallBack != null) onDissmisCallBack(type);
              },
              animType: AnimType.BOTTOMSLIDE,
              dialogType: isDisableHeader ? DialogType.NO_HEADER : dialogType,
              title: title,
              desc: subtitle,
              body: body,
              btnCancel: disableBtnCancel
                  ? null
                  : buildButton(
                      text: btnCancelText ?? "Cancel",
                      textColor: ColorTable.errorColor,
                      backgroundColor: ColorTable.errorColorLight,
                      onPressed: btnCancelOnPressed ?? () => Get.back()),
              btnOk: disableBtnOk
                  ? null
                  : StatefulBuilder(
                      builder: (context, setState) {
                        if (counter > 0) {
                          cancellableOperation = CancelableOperation.fromFuture(
                            Future.delayed(const Duration(seconds: 1)),
                            onCancel: () => {},
                          );
                          cancellableOperation?.value.whenComplete(() => setState(() => counter--));
                          return buildButton(
                            text: 'Wait($counter)',
                            textColor: ColorTable.getTextColor,
                            backgroundColor: Colors.grey.withOpacity(0.5),
                            onPressed: null,
                          );
                        }
                        return buildButton(
                          text: btnOkText ?? "Ok",
                          textColor: Colors.green,
                          backgroundColor: Colors.greenAccent.withOpacity(0.5),
                          onPressed: () {
                            if (btnOkOnPressed != null) btnOkOnPressed();
                          },
                        );
                      },
                    ))
          .show()
          .whenComplete(() => cancellableOperation?.cancel());
    }
  }
}
