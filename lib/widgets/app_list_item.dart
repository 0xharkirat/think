import 'package:flutter/material.dart';
import 'package:think/models/app.dart';

class AppListItem extends StatelessWidget {
  const AppListItem(
      {super.key,
      required this.app,
      this.isChecked = false,
      this.onChecked,

      required this.isSelection});

  final App app;
  final bool isChecked;
  final ValueChanged<bool?>? onChecked;
  final bool isSelection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Image.memory(app.icon),
        title: Text(app.name),
        trailing: isSelection? Checkbox(
          value: isChecked,
          onChanged:isSelection? onChecked : null,
        ): null,
      ),
    );
  }
}
