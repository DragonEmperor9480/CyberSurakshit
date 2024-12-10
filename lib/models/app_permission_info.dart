import 'dart:typed_data';

class AppPermissionInfo {
  final String appName;
  final String packageName;
  final Uint8List? icon;
  final List<String> permissions;

  AppPermissionInfo({
    required this.appName,
    required this.packageName,
    this.icon,
    required this.permissions,
  });
}
