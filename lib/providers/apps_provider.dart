import 'package:installed_apps/app_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SelectedAppsNotifier extends StateNotifier<List<AppInfo>> {
  SelectedAppsNotifier() : super([]);

  void selectApp(AppInfo? app) {
    final appIsChecked = state.contains(app);
    print(appIsChecked);

    if (app == null) {
      state = [];
    }
    else {
      if (!appIsChecked) {
        state = [...state, app];
      } else {
        state = state.where((a) => a.packageName == app.packageName).toList();
      }
    }
  }
}

final selectedAppsProvider =
    StateNotifierProvider<SelectedAppsNotifier, List<AppInfo>>((ref) => SelectedAppsNotifier());


