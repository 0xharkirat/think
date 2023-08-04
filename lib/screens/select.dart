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

  List<AppInfo> _checkedApps = [];



  void _getCheckedApps() {
    final List<AppInfo> selectedApps = ref.read(appsProvider);



    for (final app in selectedApps) {
      setState(() {
        _checkedApps.add(app);
      });
    }
  }

  void _updateCheckedApps(AppInfo app, bool? isChecked) {
    print('${app.name} is checked: $isChecked');
    setState(() {
      if (isChecked != null && isChecked) {
        _checkedApps.add(app);
      } else {
        _checkedApps.remove(app);
      }
    });
  }

  

  @override
  void initState() {
    super.initState();

    _getCheckedApps();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );


    if (ref.watch(installedAppsProvider).isNotEmpty){
      content = Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.separated(
              itemCount: ref.watch(installedAppsProvider).length,
              separatorBuilder: (ctx, index) {
                return const Divider();
              },
              itemBuilder: (ctx, index) {
                return AppListItem(
                  app: ref.watch(installedAppsProvider)[index],
                  isChecked: _checkedApps
                      .contains(ref.watch(installedAppsProvider)[index]),
                  onChecked: (value) => _updateCheckedApps(
                      ref.watch(installedAppsProvider)[index], value),
                  isSelection: true,
                );
              }),
        );


    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text('Select apps'),
        ),
        body: content,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            ref.read(appsProvider.notifier).addApps(_checkedApps);
            // ref.read(appsProvider.notifier).loadApps();
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
