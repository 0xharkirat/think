

import 'dart:typed_data';

class App {
  final String name;
  final Uint8List icon;
  final String packageName;

  const App({ required this.name, required this.icon, required this.packageName});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is App &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              packageName == other.packageName;

  @override
  int get hashCode => name.hashCode ^ packageName.hashCode;
}