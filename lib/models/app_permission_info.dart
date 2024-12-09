class AppPermissionInfo {
  final String appName;
  final String packageName;
  final List<String> permissions;
  final bool isSystemApp;

  AppPermissionInfo({
    required this.appName,
    required this.packageName,
    required this.permissions,
    this.isSystemApp = false,
  });
}
