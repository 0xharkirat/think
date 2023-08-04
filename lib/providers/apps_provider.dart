import 'dart:typed_data';

import 'package:installed_apps/app_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:think/utils/installed.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(path.join(dbPath, 'think.db'),
      onCreate: _createTable, version: 1);

  return db;
}

Future<void> _createTable(Database database, int newerVersion) async {
  await database.execute("""CREATE TABLE IF NOT EXISTS installed_apps (
    name TEXT PRIMARY KEY, 
    package_name TEXT, 
    version_name TEXT, 
    version_code INTEGER, 
    icon BLOB
    )""");
  await database.execute("""CREATE TABLE IF NOT EXISTS selected_apps(
    name TEXT
    )""");
}

class AppsNotifier extends StateNotifier<List<AppInfo>> {
  AppsNotifier() : super([]);

  void addApps(List<AppInfo> selectedApps) async {
    final db = await _getDatabase();

    await db.delete('selected_apps');

    if(selectedApps.isEmpty){
      state = [];
    }

    for (final app in selectedApps) {
      print('app selected ${app.name}');
      db.insert('selected_apps', {
        'name': app.name,
      });
      selectApp(app);
    }




  }

  void selectApp(AppInfo app) {
    final appIsChecked = state.contains(app);
    print(appIsChecked);

      if (!appIsChecked) {
        state = [...state, app];
      } else {
        state = state.where((a) => a.packageName == app.packageName).toList();
      }

  }

  void loadApps() async {

    final db = await _getDatabase();

    final data = await db.query('selected_apps');

    final List<String> apps = data.map((row) => row['name'] as String).toList();

    final List<AppInfo> selectedApps = [];


    for (final app in apps) {
      print(app);
      var list = await db
          .rawQuery('SELECT * FROM installed_apps WHERE name = ? ', [app]);
      print('selection: $list');

      if (list.isNotEmpty) {
        final List<AppInfo> a = list
            .map((row) => AppInfo(
                row['name'] as String,
                row['icon'] as Uint8List?,
                row['package_name'] as String,
                row['version_name'] as String,
                row['version_code'] as int))
            .toList();
        selectedApps.add(a[0]);
      }

      state = selectedApps;
    }
  }
}

final appsProvider =
    StateNotifierProvider<AppsNotifier, List<AppInfo>>((ref) => AppsNotifier());

class InstalledAppsNotifier extends StateNotifier<List<AppInfo>> {
  InstalledAppsNotifier() : super([]);

  void loadInstalledApps() async {
    // print('now starting loading sequence...');
    // print('getting db...');

    if (state.isEmpty){
      final db = await _getDatabase();

      // print('getting data from instaled apps');
      final data = await db.query('installed_apps');
      // print('got data of length for installed apps: ${data.length}');
      // print(state);

      // print('emptying state...');


      // print('creating map of data...');
      final List<AppInfo> installedApps = data
          .map((row) => AppInfo(
          row['name'] as String,
          row['icon'] as Uint8List?,
          row['package_name'] as String,
          row['version_name'] as String,
          row['version_code'] as int))
          .toList();


      // print('adding apps from map to state...');
      for (final app in installedApps) {
        state = [...state, app];
        // print('app added to state $app');
      }
      // print(state);


    }

  }

  void storeInstalledApps() async {
    // print('getting all installed apps...');

    final List<AppInfo> apps = await DeviceApps.getInstalledApps();
    // print('finished getting app.');
    // print('getting db...');

    final db = await _getDatabase();
    // print('got $db');

    // print('getting already added apps in installed apps...');
    for (final app in apps) {
      var list = await db.rawQuery(
        'SELECT * FROM installed_apps WHERE name = ?',
        [app.name],
      );

      // print('got the length ${list.length} of ${list[0]['name']}');

      if (list.isEmpty) {
        // print(app.name);
        db.insert('installed_apps', {
          'name': app.name,
          'package_name': app.packageName,
          'version_name': app.versionName,
          'version_code': app.versionCode,
          'icon': app.icon,
        });
      }
    }

    loadInstalledApps();
  }
}

final installedAppsProvider =
    StateNotifierProvider<InstalledAppsNotifier, List<AppInfo>>(
        (ref) => InstalledAppsNotifier());
