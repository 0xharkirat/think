import 'dart:typed_data';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:think/database/db.dart';
import 'package:think/models/app.dart';


class SelectedAppsNotifier extends StateNotifier<List<App>> {
  SelectedAppsNotifier() : super([]);

  SelectedAppsNotifier.fromDatabase(): super ([]){
    _loadSelectedAppsFromDatabase();
  }

  Future<void> _loadSelectedAppsFromDatabase() async {

    final db = await DatabaseHelper.instance.database;

    final updatedAppsFromDb = await db.query('selected_apps');

    // Convert the database data to App instances
    final List<App> updatedSelectedApps = updatedAppsFromDb
        .map((row) => App(
      name: row['name'] as String,
      icon: row['icon'] as Uint8List,
      packageName: row['package_name'] as String,
    ))
        .toList();

    state = updatedSelectedApps;


  }

  void selectApps(List<App> selectedApps) async {

    final db = await DatabaseHelper.instance.database;

    if (selectedApps.isEmpty) {
      state = [];
      await db.delete('selected_apps');
    }
    else {
      final existingApps = await db.query('selected_apps');

      // Convert the existing apps to a map for easier comparison.
      final existingSelectedApps = {
        for (var app in existingApps) app['package_name']: app
      };

      for (final app in selectedApps) {
          final appData = {
            'name': app.name,
            'package_name': app.packageName,
            'icon': app.icon,
          };

          if (existingSelectedApps.containsKey(app.packageName)) {
            // If the app is already in the database, update its data
            await db.update('selected_apps', appData,
                where: 'package_name = ?', whereArgs: [app.packageName]);
          } else {
            // If the app is not in the database, insert it
            await db.insert('selected_apps', appData);
          }
        }

      // Loop through the existing apps and delete any that are not in the new list
      for (final existingApp in existingApps) {
        final packageName = existingApp['package_name'];
        if (!selectedApps.any((app) => app.packageName == packageName)) {
          await db.delete('selected_apps',
              where: 'package_name = ?', whereArgs: [packageName]);
        }
      }

      // Read the updated data from the database
      final updatedAppsFromDb = await db.query('selected_apps');

      // Convert the database data to App instances
      final List<App> updatedSelectedApps = updatedAppsFromDb
          .map((row) => App(
          name: row['name'] as String,
          icon: row['icon'] as Uint8List,
          packageName: row['package_name'] as String,
          ))
          .toList();

      state = updatedSelectedApps;


    }


  }


}

final selectedAppsProvider =
    StateNotifierProvider<SelectedAppsNotifier, List<App>>((ref) => SelectedAppsNotifier.fromDatabase());


