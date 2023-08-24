// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:async/async.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../core/variables/colors.dart';
import '../buttons/custom_inkwell.dart';

class CustomSearchBar extends StatelessWidget {
  ///Cancelable operation ile klavyeden değer girme işlemi kontrol edilir
  ///Verilen delay içerisinde klavyeden yeni bir giriş olmaz ise bu fonksiyon tetiklenir.
  final Function(String value)? onChangeComplete;

  ///Klavyeden değer girme işlemi bittikten kaç milisaniye sonra on change complete fonksiyonunun tetikleneceğini belirler
  final Duration changeCompletionDelay;

  final String? hintText;
  final Widget? leadingIcon;
  final bool isOutlined;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  const CustomSearchBar({
    Key? key,
    this.onChangeComplete,
    this.changeCompletionDelay = const Duration(milliseconds: 800),
    this.hintText,
    this.leadingIcon,
    this.isOutlined = false,
    this.focusNode,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FocusNode _focusNode = focusNode ?? FocusNode();
    CancelableOperation? cancelableOpertaion;

    void _startCancelableOperation() {
      cancelableOpertaion = CancelableOperation.fromFuture(
        Future.delayed(changeCompletionDelay),
        onCancel: () {},
      );
    }

    Padding _buildTextField() {
      return Padding(
        padding: EdgeInsets.all(Utils.normalPadding),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: 1,
          onChanged: (value) async {
            await cancelableOpertaion?.cancel();
            _startCancelableOperation();
            cancelableOpertaion?.value.whenComplete(() async {
              if (onChangeComplete != null) onChangeComplete!(value);
            });
          },
          style: TextStyle(color: ColorTable.getTextColor),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            isDense: true,
            border: InputBorder.none,
            hintText: hintText,
            icon: leadingIcon,
          ),
        ),
      );
    }

    return CustomInkwell(
      padding: EdgeInsets.zero,
      disableTabEfect: true,
      onTap: _focusNode.requestFocus,
      child: isOutlined
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Utils.extraLowRadius),
                border: Border.all(color: ColorTable.getTextColor.withOpacity(0.5)),
              ),
              child: _buildTextField(),
            )
          : Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(Utils.lowRadius))),
              child: _buildTextField(),
            ),
    );
  }
}
