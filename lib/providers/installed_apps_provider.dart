import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:think/database/db.dart';
import 'package:think/models/app.dart';
import 'package:think/utils/installed.dart';

class InstalledAppsNotifier extends StateNotifier<List<App>> {
  InstalledAppsNotifier() : super([]);

  void getInstalledApps() async {


    if (state.isEmpty) {
      // final db = await DatabaseHelper.instance.database;
      //
      // // Fetch existing apps from table installed_apps.
      // final existingApps = await db.query('installed_apps');

      // Get Installed apps using plugin.
      final List<AppInfo> apps = await DeviceApps.getInstalledApps();

      // Convert the existing apps to a map for easier comparison.
      // final existingInstalledApps = {
      //   for (var app in existingApps) app['package_name']: app
      // };

      // Loop through the new apps and update or insert into the database
      // for (final app in apps) {
      //   final appData = {
      //     'name': app.name,
      //     'package_name': app.packageName,
      //     'icon': app.icon,
      //   };
      //
      //   if (existingInstalledApps.containsKey(app.packageName)) {
      //     // If the app is already in the database, update its data
      //     await db.update('installed_apps', appData,
      //         where: 'package_name = ?', whereArgs: [app.packageName]);
      //   } else {
      //     // If the app is not in the database, insert it
      //     await db.insert('installed_apps', appData);
      //   }
      // }

      // Loop through the existing apps and delete any that are not in the new list
      // for (final existingApp in existingApps) {
      //   final packageName = existingApp['package_name'];
      //   if (!apps.any((app) => app.packageName == packageName)) {
      //     await db.delete('installed_apps',
      //         where: 'package_name = ?', whereArgs: [packageName]);
      //   }
      // }
      //
      // // Read the updated data from the database
      // final updatedAppsFromDb = await db.query('installed_apps');
      //
      // // Convert the database data to App instances
      // final List<App> installedApps = updatedAppsFromDb
      //     .map((row) => App(
      //     name: row['name'] as String,
      //     icon: row['icon'] as Uint8List,
      //     packageName: row['package_name'] as String,
      //     ))
      //     .toList();

      // Update the state with the new list of installed apps

      final List<App> installedApps = [];
      for (final app in apps){
        final installedApp = App(
          name: app.name! ,
          packageName: app.packageName!,
          icon: app.icon!

        );
        installedApps.add(installedApp);
      }
      state = installedApps;

    }
  }
}

final installedAppsProvider =
    StateNotifierProvider<InstalledAppsNotifier, List<App>>(
        (ref) => InstalledAppsNotifier());
