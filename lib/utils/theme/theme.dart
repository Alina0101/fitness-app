import 'package:fitness_app/utils/theme/widget_themes/card_theme.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/utils/theme/widget_themes/text_theme.dart';
import '../constants/colors.dart';
import '../theme/widget_themes/appbar_theme.dart';
import '../theme/widget_themes/bottom_sheet_theme.dart';
import '../theme/widget_themes/checkbox_theme.dart';
import '../theme/widget_themes/chip_theme.dart';
import '../theme/widget_themes/elevated_button_theme.dart';
import '../theme/widget_themes/outlined_button_theme.dart';
import '../theme/widget_themes/text_field_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppTheme {
  CustomAppTheme._();

  static ThemeData myTheme = ThemeData(
    useMaterial3: true,
    disabledColor: MyColors.grey,
    brightness: Brightness.light,
    primaryColor: MyColors.primary,
    textTheme: MyTextTheme.lightTextTheme,
    cardTheme: MyCardTheme.myCardTheme,
    chipTheme: TChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.grey.shade100,
    appBarTheme: MyAppBarTheme.myAppBarTheme,
    checkboxTheme: MyCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: MyTextFormFieldTheme.lightInputDecorationTheme,
    dividerColor: MyColors.primary,
  );

}
