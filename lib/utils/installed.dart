import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class DeviceApps {
  static Future<List<AppInfo>> getInstalledApps() async {
    final List<AppInfo> installedApps =
        await InstalledApps.getInstalledApps(true, true);

    return installedApps;
  }
}
