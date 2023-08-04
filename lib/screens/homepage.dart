import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:installed_apps/app_info.dart';
import 'package:think/providers/apps_provider.dart';
import 'package:think/screens/select.dart';
import 'package:think/widgets/app_list_item.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  void _getSelectedApps() {

    ref.read(appsProvider.notifier).loadApps();

  }

  void _getInstalledApps() async {
    ref.read(installedAppsProvider.notifier).storeInstalledApps();
  }

  @override
  void initState() {
    super.initState();
    _getInstalledApps();
    _getSelectedApps();
  }
  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No Apps Selected, Select some apps.'),
    );




    if (ref.watch(appsProvider).isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.separated(
          itemCount: ref.watch(appsProvider).length,
          separatorBuilder: (ctx, index) => const Divider(),
          itemBuilder: ((context, index) =>
              AppListItem(app: ref.watch(appsProvider)[index], isSelection: false)),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text('Think'),
        ),
        body: content,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SelectScreen()));
          },
          label: const Text('Select Apps'),
          icon: const Icon(Icons.apps),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}
