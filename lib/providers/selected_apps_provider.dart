import 'package:installed_apps/app_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:think/models/app.dart';


class SelectedAppsNotifier extends StateNotifier<List<App>> {
  SelectedAppsNotifier() : super([]);

  void selectApp(App? app) {
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
    StateNotifierProvider<SelectedAppsNotifier, List<App>>((ref) => SelectedAppsNotifier());


