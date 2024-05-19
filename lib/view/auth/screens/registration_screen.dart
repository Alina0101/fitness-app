import 'package:fitness_app/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../utils/validators/validation.dart';
import '../../../utils/constants/colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/custom_scaffold.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  registerUser() async {
    if (formKey.currentState!.validate()) {
      try {
        await AuthController.registerUser(
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
          context,
        );
        if (FirebaseAuth.instance.currentUser != null) {
          Navigator.pushNamed(context, '/');
        }
      } catch (error) {
        print(error);
      }
    }
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
              padding: const EdgeInsets.only(top: 10.0, left: 22),
              child: Text('Присоединяйтесь!',
                  style: theme.textTheme.headlineLarge),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.15),
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
                          controller: nameController,
                          hintText: "Введите имя",
                          obscureText: false,
                          validator: Validators.validateName,
                          icon: false,
                          label: "Имя",
                          prefixIcon: const Icon(Icons.account_circle_outlined),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        AuthTextField(
                          controller: emailController,
                          hintText: "Введите email",
                          obscureText: false,
                          validator: Validators.validateEmail,
                          icon: false,
                          label: "Email",
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        AuthTextField(
                          controller: passwordController,
                          hintText: "Введите пароль",
                          obscureText: true,
                          validator: Validators.validateNewPassword,
                          icon: true,
                          label: "Пароль",
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        SizedBox(
                          height: screenHeight * 0.05,
                        ),
                        AuthButton(
                          onTap: registerUser,
                          buttonText: "Создать аккаунт ",
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
                                'Уже есть аккаунт?',
                                style: theme.textTheme.labelSmall
                              ),
                              SizedBox(
                                height: screenHeight * 0.005,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child:  Text(
                                  'Нажмите, чтобы войти!',
                                  style: theme.textTheme.labelMedium
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.05,
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
