import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:think/models/app.dart';
import 'package:think/providers/selected_apps_provider.dart';
import 'package:think/screens/select_page.dart';
import 'package:think/widgets/app_list_item.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget content = const Center(
      child: Text('No Apps Selected, Select some apps.'),
    );
    final List<App> selectedApps = ref.watch(selectedAppsProvider);


    if (selectedApps.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.separated(
          itemCount: selectedApps.length,
          separatorBuilder: (ctx, index) => const Divider(),
          itemBuilder: ((context, index) =>
              AppListItem(app: selectedApps[index], isSelection: false)),
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
