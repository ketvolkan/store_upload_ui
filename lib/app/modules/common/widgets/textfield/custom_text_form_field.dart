import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../core/variables/colors.dart';

import '../texts/custom_text.dart';

class CustomTextFormField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final String? suffixText;
  final String? prefixText;
  final String? initialValue;
  final Widget? description;
  final bool isRequired;
  final bool isRequiredText;
  final int? maxlines;

  ///Fieldin altında 0/3 gibi maxLength yazısı gösterir
  final bool showmaxLength;
  final bool obscureText;
  final bool readOnly;
  final bool autoCorrect;
  // ReadOnly aktifse ve mesajın kopyalanmasını istemiyorsan false yapabilirsin
  final bool showCopyMessage;

  ///Fieldin alabileceği maximum karakter sayısı
  final int? maxLength;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function(String?)? onChangeComplete;
  final TextEditingController? controller;
  final ScrollPhysics? scrollPhysics;
  final IconData? leadingIcon;

  ///Klavyeden değer girme işlemi bittikten kaç milisaniye sonra on change complete fonksiyonunun tetikleneceğini belirler
  final Duration changeCompletionDelay;
  final EdgeInsets? labelPadding;
  final EdgeInsets? padding;
  final double? labelTextSize;
  final double? hintTextSize;
  final AutovalidateMode? autovalidateMode;
  final Function()? onTap;

  const CustomTextFormField(
      {Key? key,
      this.label,
      this.showCopyMessage = true,
      this.hintText,
      this.validator,
      this.onSaved,
      this.isRequired = false,
      this.initialValue,
      this.suffixText,
      this.keyboardType,
      this.inputFormatters,
      this.maxLength,
      this.scrollPhysics,
      this.onChangeComplete,
      this.showmaxLength = false,
      this.description,
      this.obscureText = false,
      this.controller,
      //changeCompletionDelay Normalde 600'dü editleme sayfasında değişiklik uyarısı için 100 milisaniyeye düşürdüm
      this.changeCompletionDelay = const Duration(milliseconds: 100),
      this.maxlines,
      this.readOnly = false,
      this.labelPadding,
      this.padding,
      this.labelTextSize,
      this.prefixText,
      this.autoCorrect = true,
      this.onTap,
      this.isRequiredText = true,
      this.autovalidateMode,
      this.leadingIcon,
      this.hintTextSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CancelableOperation? cancelableOpertaion;

    void _startCancelableOperation() {
      cancelableOpertaion = CancelableOperation.fromFuture(
        Future.delayed(changeCompletionDelay),
        onCancel: () {},
      );
    }

    void copyTextOnTap() {
      if (!readOnly) return;
      if (!showCopyMessage) return;

      Clipboard.setData(ClipboardData(text: (controller != null ? controller?.text : (initialValue ?? '')) ?? ""));
    }

    return InkWell(
      onTap: (readOnly) ? copyTextOnTap : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: labelPadding ?? EdgeInsets.only(left: Utils.normalPadding),
              child: CustomText.custom(
                "$label ${isRequired && isRequiredText ? '*' : ''}",
                textColor: ColorTable.getTextColor,
                textSize: labelTextSize ?? Utils.normalTextSize,
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Utils.lowRadius))),
              child: Padding(
                padding: padding ?? EdgeInsets.all(Utils.normalPadding),
                child: Column(
                  children: [
                    TextFormField(
                      readOnly: readOnly,
                      onTap: (readOnly || onTap != null)
                          ? () {
                              copyTextOnTap();
                              if (onTap != null) onTap!();
                            }
                          : null,
                      controller: controller,
                      onChanged: (value) async {
                        await cancelableOpertaion?.cancel();
                        _startCancelableOperation();
                        cancelableOpertaion?.value.whenComplete(() async {
                          if (onChangeComplete != null) onChangeComplete!(value);
                        });
                      },
                      maxLines: maxlines ?? 1,
                      maxLength: maxLength,
                      initialValue: initialValue,
                      scrollPhysics: scrollPhysics,
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      obscureText: obscureText,
                      autocorrect: autoCorrect,
                      autovalidateMode: autovalidateMode,
                      validator: isRequired
                          ? (value) {
                              if (value == null || value.isEmpty) {
                                return "Is Required";
                              }
                              return validator != null ? validator!(value) : null;
                            }
                          : validator,
                      onSaved: onSaved,
                      style: TextStyle(color: ColorTable.getTextColor, fontSize: Utils.normalTextSize),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.zero,
                          isDense: true,
                          border: InputBorder.none,
                          icon: leadingIcon != null ? Icon(leadingIcon, size: Utils.normalIconSize) : null,
                          hintText: (hintText ?? "") + (isRequired && isRequiredText ? '*' : ''),
                          hintStyle: TextStyle(color: ColorTable.getTextColor.withOpacity(0.6), fontSize: hintTextSize),
                          suffixText: suffixText,
                          prefixText: prefixText,
                          counterText: showmaxLength ? null : ''),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (description != null) Padding(padding: EdgeInsets.only(top: Utils.extraLowPadding), child: description),
        ],
      ),
    );
  }
}
