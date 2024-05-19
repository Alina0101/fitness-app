import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fitness_app/utils/constants/colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:fitness_app/view/exercise/screens/category_list_screen.dart';
import 'package:fitness_app/view/user_account/user_account_screen.dart';
import 'package:fitness_app/view/workout/screens/workout_list_screen.dart';
import 'package:flutter/material.dart';

import '../progress/screens/progress.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int index = 0;
  final screens = [
    const MuscleGroupCategoryScreen(
      addingExercisesMode: false,
    ),
    WorkoutListScreen(),
    Progress(),
    UserAccountScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(LineAwesomeIcons.dumbbell, size: 40),
      const Icon(LineAwesomeIcons.clipboard_list, size: 35),
      const Icon(LineAwesomeIcons.calendar_check, size: 35),
      const Icon(LineAwesomeIcons.user, size: 35),
    ];
    return Container(
      color: MyColors.primary,
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.white,
          body: screens[index],
          bottomNavigationBar: Theme(
            data: Theme.of(context)
                .copyWith(iconTheme: const IconThemeData(color: MyColors.white)),
            child: CurvedNavigationBar(
                backgroundColor: Colors.transparent,
                color: MyColors.primary,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 300),
                height: 55,
                items: items,
                index: index,
                onTap: (index) => setState(() {
                      this.index = index;
                    })),
          ),
        ),
      ),
    );
  }
}
