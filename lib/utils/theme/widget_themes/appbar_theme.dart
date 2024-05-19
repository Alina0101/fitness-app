import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants/sizes.dart';
import '../../constants/colors.dart';

class MyAppBarTheme {
  MyAppBarTheme._();

  static const myAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(10),
      bottomRight: Radius.circular(10),
    )),
    backgroundColor: MyColors.primary,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: MyColors.light, size: MySizes.iconMd),
    actionsIconTheme:
        IconThemeData(color: MyColors.light, size: MySizes.iconMd),
    titleTextStyle: TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: MyColors.light),
  );
}
