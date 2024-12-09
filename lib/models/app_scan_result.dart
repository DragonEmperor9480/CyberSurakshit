import 'dart:typed_data';

class AppScanResult {
  final String appName;
  final String packageName;
  final Uint8List? icon;
  final bool isOnPlayStore;

  AppScanResult({
    required this.appName,
    required this.packageName,
    this.icon,
    required this.isOnPlayStore,
  });
} 