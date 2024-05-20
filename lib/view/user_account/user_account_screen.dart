import 'package:fitness_app/controller/fitness_user_controller.dart';
import 'package:fitness_app/model/models/fitness_user.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_app/controller/firestore_services.dart';
import 'package:fitness_app/controller/auth_controller.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../utils/constants/colors.dart';
import '../../utils/validators/validation.dart';
import '../auth/widgets/auth_button.dart';
import '../auth/widgets/auth_textfield.dart';

class UserAccountScreen extends StatefulWidget {
  UserAccountScreen({Key? key}) : super(key: key);

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  late Map<String, dynamic> fitnessUser = {};
  late String userId = '';
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController parametersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userQuery = await FirestoreServices.usersCollection
          .where('email', isEqualTo: currentUser.email)
          .get();

      if (userQuery.docs.isNotEmpty) {
        final userDocs = userQuery.docs.first;
        final userData = userQuery.docs.first.data();
        setState(() {
          fitnessUser = userData;
          userId = userDocs.id;
          nameController.text = userData["name"];
          emailController.text = userData["email"];
          heightController.text = userData["height"] ?? '';
          weightController.text = userData["weight"] ?? '';
          parametersController.text = userData["parameters"] ?? '';
        });
      }
    }
  }

  updateUserInfo() async {
    FitnessUser updatedUserInfo = FitnessUser(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      height: heightController.text.trim(),
      weight: weightController.text.trim(),
      parameters: parametersController.text.trim(),
    );

    await FitnessUserController.updateUserData(userId, updatedUserInfo);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ваши данные изменены")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Ваши данные',
          style: theme.textTheme.headlineMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.02, bottom: screenHeight * 0.02),
                child: Text(
                  fitnessUser["name"] != null
                      ? "Привет, ${fitnessUser['name']}!"
                      : "Привет!",
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                width: screenWidth,
                height: screenHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            validator: Validators.validateName,
                            decoration: const InputDecoration(
                              hintText: "Введите имя",
                              labelText: "Имя",
                              prefixIcon: Icon(Icons.account_circle_outlined),
                            )),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        TextFormField(
                          controller: emailController,
                          enabled: false,
                          decoration: const InputDecoration(
                              labelText: "Email",
                              prefixIcon: Icon(Icons.email_outlined)),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        const Divider(),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: heightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Введите ваш рост",
                                    labelText: "Рост (см)",
                                    prefixIcon: Icon(Icons.height)),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.02,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    hintText: "Введите ваш вес",
                                    labelText: "Вес (кг)",
                                    prefixIcon: Icon(LineAwesomeIcons.weight)),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        TextFormField(
                          controller: parametersController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            hintText: "Введите свои параметры, заметки и т.д.",
                            labelText: "Параметры и заметки",
                            prefixIcon: Icon(LineAwesomeIcons.pen),
                            //alignLabelWithHint: true,
                          ),
                          maxLines: 5,
                        ),
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        AuthButton(
                          onTap: () {
                            updateUserInfo();
                          },
                          buttonText: "Сохранить",
                          textColor: Colors.white,
                          gradient: MyColors.lightGradient,
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        AuthButton(
                          onTap: () {
                            AuthController.signOut();
                            Navigator.of(context).pushNamed('/');
                          },
                          buttonText: "Выйти из аккаунта",
                          textColor: MyColors.primary,
                          backColor: Colors.white,
                          //gradient: MyColors.lightGradient,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
