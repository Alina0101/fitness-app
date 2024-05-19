import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/validators/validation.dart';
import '../../auth/widgets/auth_button.dart';

class WorkoutDialog extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final Function() onUpdate;
  final String titleText;

  const WorkoutDialog({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.onUpdate,
    required this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    titleText,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.cancel_outlined,
                    color: MyColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: nameController,
              validator: Validators.validateName,
              decoration: const InputDecoration(
                hintText: "Введите название",
                label: Text("Название тренировки"),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: "Введите описание",
                label: Text("Описание тренировки"),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            AuthButton(
              onTap: () {
                onUpdate();
                Navigator.pop(context);
              },
              buttonText: "ОК",
              textColor: Colors.white,
              gradient: MyColors.lightGradient,
            ),
          ],
        ),
      ),
    );
  }
}
