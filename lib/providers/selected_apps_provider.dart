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
    print('entered here in the initial');
    final db = await DatabaseHelper.instance.database;

    final updatedAppsFromDb = await db.query('selected_apps');

    final List<App> updatedSelectedApps = [];

    // Convert the database data to App instances
    for (final row in updatedAppsFromDb){

      // fetch
      final installedAppData = await db.query('installed_apps',
          where: 'package_name = ?', whereArgs: [row['package_name']]);
      final installedApp = installedAppData.first;
      final app = App(
        name: installedApp['name'] as String,
        packageName: installedApp['package_name'] as String,
        icon: installedApp['icon'] as Uint8List,
      );
      updatedSelectedApps.add(app);

    }

    // Update the state with the new list of installed apps
    state = updatedSelectedApps;


  }



  void selectApp(List<App> selectedApps) async {

    final db = await DatabaseHelper.instance.database;

    if (selectedApps.isEmpty) {
      state = [];
      await db.delete('selected_apps');
    }
    else {
      final existingApps = await db.query('selected_apps');

      // Convert the existing apps to a map for easier comparison.
      final existingInstalledApps = {
        for (var app in existingApps) app['package_name']: app
      };

      for (final app in selectedApps) {
        final appData = {
          'package_name': app.packageName,


        };

        if (existingInstalledApps.containsKey(app.packageName)) {
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

      final List<App> updatedSelectedApps = [];

      // Convert the database data to App instances
      for (final row in updatedAppsFromDb){

        // fetch
        final installedAppData = await db.query('installed_apps',
            where: 'package_name = ?', whereArgs: [row['package_name']]);
        final installedApp = installedAppData.first;
        final app = App(
          name: installedApp['name'] as String,
          packageName: installedApp['package_name'] as String,
          icon: installedApp['icon'] as Uint8List,
        );
        updatedSelectedApps.add(app);

      }

      // Update the state with the new list of installed apps
      state = updatedSelectedApps;

    }


  }


}

final selectedAppsProvider =
    StateNotifierProvider<SelectedAppsNotifier, List<App>>((ref) => SelectedAppsNotifier.fromDatabase());


