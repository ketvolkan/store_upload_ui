import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/utils/utils.dart';

///Her sayfa için ideal başlangıç scaffold'u.
///Bodyde standart bir padding ve singlechild scrollview döndürür.
class CustomScaffold extends StatelessWidget {
  final Widget? appBar;
  final Widget? body;
  final EdgeInsetsGeometry? bodyPadding;
  final bool useSingleChildScrollView;
  final bool extendBodyBehindAppBar;
  final bool extendBody;
  final bool resizeToAvoidBottomInset;
  final FloatingActionButton? floatingActionButton;
  const CustomScaffold(
      {Key? key,
      this.appBar,
      this.body,
      this.bodyPadding,
      this.useSingleChildScrollView = false,
      this.extendBodyBehindAppBar = false,
      this.extendBody = false,
      this.resizeToAvoidBottomInset = true,
      this.floatingActionButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeightMinusAppBarMinusStatusBar = Get.height - MediaQuery.of(context).padding.top;
    if (appBar != null) screenHeightMinusAppBarMinusStatusBar -= Utils.appBarHeight;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: extendBody,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar == null ? null : PreferredSize(preferredSize: Size.fromHeight(Utils.appBarHeight), child: appBar!),
        body: useSingleChildScrollView
            ? SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: screenHeightMinusAppBarMinusStatusBar),
                  child: bodyWithPadding,
                ),
              )
            : bodyWithPadding,
        floatingActionButton: floatingActionButton,
      ),
    );
  }

  Padding get bodyWithPadding => Padding(
        padding: bodyPadding ?? EdgeInsets.symmetric(horizontal: Utils.highPadding),
        child: body,
      );
}
