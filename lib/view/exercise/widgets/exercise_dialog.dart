import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../utils/validators/validation.dart';
import '../../auth/widgets/auth_button.dart';

class EditExerciseDialog extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController weightController;
  final TextEditingController repsController;
  final TextEditingController setsController;
  final String selectedCategory; // Текущая категория упражнения
  final List<String> muscleGroups;
  final String exerciseId;
  final Function(String) onUpdate;
  final String titleText;

  EditExerciseDialog({
    Key? key,
    required this.nameController,
    required this.descriptionController,
    required this.weightController,
    required this.repsController,
    required this.setsController,
    required this.selectedCategory,
    required this.muscleGroups,
    required this.exerciseId,
    required this.onUpdate,
    required this.titleText,
  }) : super(key: key);

  @override
  State<EditExerciseDialog> createState() => _EditExerciseDialogState();
}

class _EditExerciseDialogState extends State<EditExerciseDialog> {
  String? selectedMuscleGroup; // Выбранная категория в диалоговом окне

  @override
  void initState() {
    selectedMuscleGroup = widget.selectedCategory; // Установка начального значения
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(widget.titleText,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.cancel_outlined,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: widget.nameController,
              validator: Validators.validateName,
              decoration: const InputDecoration(
                hintText: "Введите название",
                labelText: "Название упражнения",
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: widget.descriptionController,
              decoration: const InputDecoration(
                hintText: "Введите описание",
                labelText: "Описание упражнения",
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            AuthButton(
              onTap: () {
                widget.onUpdate(widget.exerciseId);
                Navigator.pop(context);
              },
              buttonText: "Сохранить",
              textColor: Colors.white,
              gradient: MyColors.lightGradient,
            ),
          ],
        ),
      ),
    );
  }


}
