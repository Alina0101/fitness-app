import 'package:fitness_app/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseDetailsScreen extends StatelessWidget {
  final DocumentSnapshot exerciseSnapshot;

  const ExerciseDetailsScreen({super.key, required this.exerciseSnapshot});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text("Детали упражнения",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.cancel_outlined,
                    color: theme.primaryColor,
                  ),
                ),
              ],
            ),
            buildDetailItem('Название:', exerciseSnapshot['name'], context),
            buildDetailItem(
                'Категория мышц:', exerciseSnapshot['category'], context),
            buildDetailItem(
                'Описание:', exerciseSnapshot['description'], context),
          ],
        ),
      ),
    );
  }

  Widget buildDetailItem(String label, String value, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: ListTile(
        title: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          value,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}
