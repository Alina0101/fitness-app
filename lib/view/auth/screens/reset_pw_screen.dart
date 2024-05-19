import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../utils/validators/validation.dart';
import '../../../controller/auth_controller.dart';
import '../../../utils/constants/colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_textfield.dart';
import '../widgets/custom_scaffold.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  resetPassword() {
    if (formKey.currentState!.validate()) {
      AuthController.resetPassword(_emailController.text.trim(), context);
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
              padding: const EdgeInsets.only(top: 20.0, left: 20),
              child: Text('Сброс пароля', style: theme.textTheme.headlineLarge),
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
                    top: screenHeight * 0.1, left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Введите адрес электронной почты для получения инструкций по сбросу пароля:',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        AuthTextField(
                          controller: _emailController,
                          validator: Validators.validateEmail,
                          hintText: "Введите Email",
                          obscureText: false,
                          icon: false,
                          label: "Email",
                        ),
                        const SizedBox(height: 40),
                        AuthButton(
                          onTap: resetPassword,
                          buttonText: "Сбросить пароль",
                          textColor: Colors.white,
                          gradient: MyColors.lightGradient,
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        AuthButton(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          buttonText: "Отменить",
                          textColor: MyColors.primary,
                          backColor: Colors.white,
                          //gradient: MyColors.lightGradient,
                        ),
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
