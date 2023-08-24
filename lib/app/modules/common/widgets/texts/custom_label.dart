import 'package:flutter/material.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../core/variables/colors.dart';
import 'custom_text.dart';

class CustomLabel extends StatelessWidget {
  final String? label;
  final bool isRequired;
  final Widget child;

  const CustomLabel({
    Key? key,
    this.label,
    this.isRequired = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) labelText,
        child,
      ],
    );
  }

  Padding get labelText => Padding(
        padding: EdgeInsets.only(left: Utils.normalPadding),
        child: CustomText.high(
          label! + (isRequired ? '*' : ''),
          textColor: ColorTable.getTextColor,
        ),
      );
}
