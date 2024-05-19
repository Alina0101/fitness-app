import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../widgets/auth_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          gradient: MyColors.lightGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.005),
              child: Image.asset(
                'assets/logo/logo1.png',
                width: screenWidth * 0.8,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            Text(
              'Добро пожаловать!',
              style: theme.textTheme.headlineLarge
            ),
            SizedBox(height: screenHeight * 0.1),
            AuthButton(
              onTap: () {
                Navigator.pushNamed(context, '/login');
              },
              buttonText: "ВОЙТИ",
              backColor: Colors.transparent,
              textColor: Colors.white,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            SizedBox(height: screenHeight * 0.05),
            AuthButton(
              onTap: () {
                Navigator.pushNamed(context, '/registration');
              },
              buttonText: "СОЗДАТЬ АККАУНТ",
              backColor: Colors.white,
              textColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
