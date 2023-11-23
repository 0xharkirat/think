import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:think/utils/installed.dart';

class InstalledAppsNotifier extends StateNotifier<List<AppInfo>> {
  InstalledAppsNotifier() : super([]);

  void getInstalledApps() async {
    if (state.isEmpty) {
      final List<AppInfo> apps = await DeviceApps.getInstalledApps();

      // final List<AppInfo> loadedApps = [];
      //
      // for (final app in apps) {
      //   loadedApps.add(app);
      // }

      state = apps;
    }
  }
}

final installedAppsProvider =
StateNotifierProvider<InstalledAppsNotifier, List<AppInfo>>(
        (ref) => InstalledAppsNotifier());