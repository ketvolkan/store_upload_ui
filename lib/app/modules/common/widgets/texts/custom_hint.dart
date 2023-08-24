import 'package:flutter/material.dart';

import '../../../../../core/variables/colors.dart';
import 'custom_text.dart';

class CustomHint extends StatelessWidget {
  final String? text;
  const CustomHint(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
      text,
      textColor: ColorTable.getTextColor.withOpacity(0.5),
      textOverflow: TextOverflow.ellipsis,
      maxlines: 1,
    );
  }
}
