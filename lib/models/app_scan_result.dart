import 'dart:typed_data';

enum RiskLevel {
  safe,    // For system apps
  low,     // For verified Play Store apps
  medium,  // For unknown sources but no major issues
  high     // For potentially harmful apps
}

class AppScanResult {
  final String name;
  final String packageName;
  final Uint8List? icon;
  final bool isOnPlayStore;
  final RiskLevel riskLevel;
  final List<String> warnings;

  AppScanResult({
    required this.name,
    required this.packageName,
    required this.icon,
    required this.isOnPlayStore,
    required this.riskLevel,
    required this.warnings,
  });
} 