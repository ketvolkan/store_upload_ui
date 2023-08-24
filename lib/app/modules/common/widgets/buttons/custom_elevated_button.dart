import 'package:flutter/material.dart';

import '../../../../../core/utils/utils.dart';
import '../../../../../core/variables/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget child;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? minimumWith;
  final double? minimumHeight;
  final double? fontSize;
  final EdgeInsets? padding;
  final Color? borderColor;
  final bool isActive;
  final bool showShadow;
  final void Function()? onPressed;
  final MaterialTapTargetSize? tapTargetSize;
  const CustomElevatedButton(
      {Key? key,
      required this.child,
      this.onPressed,
      this.overlayColor,
      this.borderColor,
      this.borderRadius,
      this.minimumWith,
      this.minimumHeight,
      this.padding,
      this.fontSize,
      this.backgroundColor,
      this.tapTargetSize,
      this.isActive = true,
      this.showShadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isActive ? onPressed : null,
      style: ButtonStyle(
        elevation: showShadow ? null : MaterialStateProperty.all<double?>(0),
        overlayColor: overlayColor != null
            ? MaterialStateProperty.all<Color>(HSLColor.fromColor(overlayColor!).withLightness(0.25).toColor())
            : MaterialStateProperty.all<Color>(HSLColor.fromColor(ColorTable.successColorLight).withLightness(0.25).toColor()),
        backgroundColor: backgroundColor != null
            ? MaterialStateProperty.all<Color>(backgroundColor!)
            : MaterialStateProperty.all<Color>(isActive ? ColorTable.successColor : Colors.transparent),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(minimumWith ?? 1, minimumHeight ?? 1),
        ),
        side: !isActive
            ? MaterialStateProperty.all<BorderSide>(
                BorderSide(color: ColorTable.getTextColor),
              )
            : null,
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? Utils.extraLowRadius)),
        )),
        tapTargetSize: tapTargetSize,
        padding: MaterialStateProperty.all<EdgeInsets>(padding ?? EdgeInsets.all(Utils.normalPadding)),
      ),
      child: child,
    );
  }
}
