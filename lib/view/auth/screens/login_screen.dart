import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/controller/auth_controller.dart';
import 'package:flutter/widgets.dart';
import '../../../utils/validators/validation.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/custom_scaffold.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Введите Email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Введите пароль';
    }
    return null;
  }

  loginUser() {
    if (formKey.currentState!.validate()) {
      AuthController.loginUser(
        emailController.text.trim(),
        passwordController.text.trim(),
        context,
      ).then((_) {
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushNamed(context, '/nav_menu');
          //Navigator.pushNamed(context, '/');
        }
      }).catchError((error) {});
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return CustomScaffold(
      child: Stack(
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 20),
              child: Text('Рады вас\nвидеть снова!',
                  style: theme.textTheme.headlineLarge),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.2),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.05, left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        AuthTextField(
                          controller: emailController,
                          hintText: "Введите Email",
                          obscureText: false,
                          validator: Validators.validateEmail,
                          label: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                          icon: false,
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        AuthTextField(
                          controller: passwordController,
                          hintText: "Введите пароль",
                          obscureText: true,
                          validator: Validators.validateOldPassword,
                          label: "Пароль",
                          prefixIcon: const Icon(Icons.lock),
                          icon: true,
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/reset_pw');
                                },
                                child: Text("Забыли пароль?",
                                    style: theme.textTheme.labelSmall
                                ))),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        AuthButton(
                          onTap: loginUser,
                          buttonText: "Войти в аккаунт",
                          textColor: Colors.white,
                          gradient: MyColors.lightGradient,
                        ),
                        SizedBox(
                          height: screenHeight * 0.15,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Нет аккаунта?',
                                style: theme.textTheme.labelSmall
                              ),
                              SizedBox(
                                height: screenHeight * 0.005,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/registration');
                                },
                                child:  Text(
                                  'Нажмите, чтобы создать его!',
                                  style: theme.textTheme.labelMedium
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
