import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';

import 'package:think/providers/apps_provider.dart';
import 'package:think/widgets/app_list_item.dart';

class SelectScreen extends ConsumerStatefulWidget {
  const SelectScreen({super.key});

  @override
  ConsumerState<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends ConsumerState<SelectScreen> {
  List<AppInfo> checkedApps = [];


  void _getInstalledApps() async {
    ref.read(installedAppsProvider.notifier).storeInstalledApps();
  }

  void _updateCheckedApps(AppInfo app, bool? isChecked) {
    setState(() {
      if (isChecked != null && isChecked) {
        checkedApps.add(app);
      } else {
        checkedApps.remove(app);
      }
    });
  }

  void _getCheckedApps() {
    final List<AppInfo> selectedApps = ref.read(appsProvider);

    print(selectedApps);
    for (final app in selectedApps) {
      setState(() {
        checkedApps.add(app);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _getInstalledApps();
    _getCheckedApps();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text('Select apps'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.separated(
              itemCount: ref.watch(installedAppsProvider).length,
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
              itemBuilder: (ctx, index) {
                return AppListItem(
                  app: ref.watch(installedAppsProvider)[index],
                  isChecked: checkedApps
                      .contains(ref.watch(installedAppsProvider)[index]),
                  onChecked: (value) => _updateCheckedApps(
                      ref.watch(installedAppsProvider)[index], value),
                  isSelection: true,
                );
              }),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {

            
            for (final app in checkedApps) {
              print(app.name);
              ref.read(appsProvider.notifier).selectApp(app);
            }
            if (checkedApps.isEmpty){
              ref.read(appsProvider.notifier).selectApp(null);

            }

            print(ref.watch(appsProvider).length);
            Navigator.of(context).pop();
          },
          label: const Text('DONE'),
          icon: const Icon(Icons.done),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}
