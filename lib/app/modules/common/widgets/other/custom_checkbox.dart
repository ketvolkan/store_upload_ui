import 'package:flutter/material.dart';

import '../../../../../core/variables/colors.dart';

class CustomCheckBox extends StatelessWidget {
  final Function(bool? value) onChanged;
  final bool value;
  const CustomCheckBox({Key? key, required this.onChanged, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      onChanged: onChanged,
      value: value,
      activeColor: ColorTable.successColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      side: BorderSide(color: ColorTable.getTextColor, width: 1.2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
    );
  }
}
