import 'package:installed_apps/app_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:think/utils/installed.dart';

class AppsNotifier extends StateNotifier<List<AppInfo>> {
  AppsNotifier() : super([]);

  void selectApp(AppInfo? app) {
    final appIsChecked = state.contains(app);
    print(appIsChecked);

    if (app == null) {
      state = [];
    } else {
      if (!appIsChecked) {
        state = [...state, app];
      } else {
        state = state.where((a) => a.packageName == app.packageName).toList();
      }
    }
  }
}

final appsProvider =
    StateNotifierProvider<AppsNotifier, List<AppInfo>>((ref) => AppsNotifier());

class InstalledAppsNotifier extends StateNotifier<List<AppInfo>> {
  InstalledAppsNotifier() : super([]);

  void storeInstalledApps() async {
    if (state.isEmpty) {
      final List<AppInfo> apps = await DeviceApps.getInstalledApps();

      final List<AppInfo> loadedApps = [];

      for (final app in apps) {
        loadedApps.add(app);
      }

      state = loadedApps;
    }
  }
}

final installedAppsProvider =
    StateNotifierProvider<InstalledAppsNotifier, List<AppInfo>>(
        (ref) => InstalledAppsNotifier());
