import 'package:installed_apps/installed_apps.dart';
import '../models/app_scan_result.dart';
import 'package:http/http.dart' as http;

class AppScannerService {
  static final List<String> trustedPrefixes = [
    'com.android.',
    'com.google.android.',
    'com.samsung.',
    'com.sec.',
    'com.xiaomi.',
    'com.miui.',
    'miui.',
    'com.mi.',
    'com.huawei.',
    'com.oppo.',
    'com.vivo.',
    'com.oneplus.',
    'android.',
    'com.qualcomm.',
    'com.mediatek.',
  ];

  static bool isSystemApp(String packageName) {
    return trustedPrefixes.any((prefix) => packageName.startsWith(prefix));
  }

  static Future<List<AppScanResult>> scanInstalledApps({
    Function(double)? onProgress,
  }) async {
    List<AppScanResult> results = [];
    
    try {
      final apps = await InstalledApps.getInstalledApps();
      int totalApps = apps.length;

      for (int i = 0; i < apps.length; i++) {
        final app = apps[i];
        
        // Calculate and report progress
        if (onProgress != null) {
          onProgress((i + 1) / totalApps);
        }

        // Mark system apps as safe
        if (isSystemApp(app.packageName ?? '')) {
          results.add(AppScanResult(
            name: app.name ?? 'Unknown',
            packageName: app.packageName ?? '',
            icon: app.icon,
            isOnPlayStore: true,  // Consider system apps as safe
            riskLevel: RiskLevel.safe,
            warnings: [],  // No warnings for system apps
          ));
          continue;
        }

        // Check Play Store for non-system apps
        bool isOnPlayStore = await _checkPlayStore(app.packageName ?? '');
        
        results.add(AppScanResult(
          name: app.name ?? 'Unknown',
          packageName: app.packageName ?? '',
          icon: app.icon,
          isOnPlayStore: isOnPlayStore,
          riskLevel: isOnPlayStore ? RiskLevel.low : RiskLevel.medium,
          warnings: isOnPlayStore ? [] : ['App not found on Play Store'],
        ));
      }
    } catch (e) {
      print('Error scanning apps: $e');
    }

    return results;
  }

  static Future<bool> _checkPlayStore(String packageName) async {
    try {
      final response = await http.get(
        Uri.parse('https://play.google.com/store/apps/details?id=$packageName'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}