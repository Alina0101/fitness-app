import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../auth/widgets/auth_button.dart';

class EditExerciseInWorkoutDialog extends StatefulWidget {
  final TextEditingController weightController;
  final TextEditingController repsController;
  final TextEditingController setsController;
  final String exerciseId;
  final Function(String) onUpdate;
  final String titleText;

  EditExerciseInWorkoutDialog({
    Key? key,
    required this.weightController,
    required this.repsController,
    required this.setsController,
    required this.exerciseId,
    required this.onUpdate,
    required this.titleText,
  }) : super(key: key);

  @override
  State<EditExerciseInWorkoutDialog> createState() => _EditExerciseInWorkoutDialogState();
}

class _EditExerciseInWorkoutDialogState extends State<EditExerciseInWorkoutDialog> {

  @override
  void initState() {
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
                      style: theme.textTheme.titleMedium),
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
              controller: widget.weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Введите вес",
                labelText: "Вес для упражнения",
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Кол-во повторений",
                      labelText: "Повторения",
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: widget.setsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Кол-во подходов",
                      labelText: "Подходы",
                    ),
                    ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            AuthButton(
              onTap: () {
                // При сохранении обновляем категорию упражнения
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
