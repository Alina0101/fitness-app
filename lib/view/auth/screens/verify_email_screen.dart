import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/view/bottom_navigation_bar/navigation_menu.dart';
import 'package:fitness_app/controller/firestore_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../controller/auth_controller.dart';
import '../../../utils/constants/colors.dart';
import '../widgets/auth_button.dart';
import '../widgets/custom_scaffold.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(const Duration(seconds: 3), (_) => checkVerification());
    }
  }

  Future<void> checkVerification() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      final user = FirestoreServices.currentUser;
      await user.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      timer = Timer(const Duration(seconds: 30), () {
        setState(() {
          canResendEmail = true;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const NavigationMenu()
      : CustomScaffold(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 20),
                  child: Text('Подтверждение\nэлектронной почты',
                      style: TextStyle(
                          fontSize: 40,
                          color: MyColors.textWhite,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.2),
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
                        top: MediaQuery.of(context).size.height * 0.1,
                        left: 20,
                        right: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Письмо для подтверждения электронной почты было отправлено",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                          ),
                          AuthButton(
                            onTap:
                                canResendEmail ? sendVerificationEmail : null,
                            buttonText: "Отправить еще раз",
                            textColor: Colors.white,
                            gradient:
                                canResendEmail ? MyColors.lightGradient : null,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03,
                          ),
                          AuthButton(
                            onTap: FirebaseAuth.instance.signOut,
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
            ],
          ),
        );
}
