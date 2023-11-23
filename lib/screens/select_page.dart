import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:think/providers/apps_provider.dart';
import 'package:think/providers/installed_apps_provider.dart';
import 'package:think/widgets/app_list_item.dart';

class SelectScreen extends ConsumerStatefulWidget {
  const SelectScreen({super.key});

  @override
  ConsumerState<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends ConsumerState<SelectScreen> {
  // Variables
  List<AppInfo> _selectedApps = [];

  // Methods
  void _getInstalledApps() async {
    ref.read(installedAppsProvider.notifier).getInstalledApps();
  }

  void _getSelectedApps() {
    final List<AppInfo> selectedApps = ref.read(selectedAppsProvider);

    print(selectedApps);

    setState(() {
      _selectedApps = selectedApps;
    });
  }

  void _updateSelectedApps(AppInfo app, bool? isChecked) {
    setState(() {
      if (isChecked != null && isChecked) {
        _selectedApps.add(app);
      } else {
        _selectedApps.remove(app);
      }
    });
  }

  // Override Methods
  @override
  void initState() {
    super.initState();
    _getInstalledApps();
    _getSelectedApps();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: CircularProgressIndicator(),
    );

    if (ref.watch(installedAppsProvider).isNotEmpty) {
      content = ListView.separated(
        itemCount: ref.watch(installedAppsProvider).length,
        separatorBuilder: (ctx, index) {
          return const Divider();
        },
        itemBuilder: (ctx, index) {
          return AppListItem(
            app: ref.watch(installedAppsProvider)[index],
            isChecked: _selectedApps
                .contains(ref.watch(installedAppsProvider)[index]),
            onChecked: (value) => _updateSelectedApps(
                ref.watch(installedAppsProvider)[index], value),
            isSelection: true,
          );
        }
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text('Select apps'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: content,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            for (final app in _selectedApps) {
              print(app.name);
              ref.read(selectedAppsProvider.notifier).selectApp(app);
            }
            if (_selectedApps.isEmpty) {
              ref.read(selectedAppsProvider.notifier).selectApp(null);
            }

            print(ref.watch(selectedAppsProvider).length);
            Navigator.of(context).pop();
          },
          label: const Text('DONE'),
          icon: const Icon(Icons.done),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}
