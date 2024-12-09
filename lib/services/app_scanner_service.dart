import 'package:installed_apps/installed_apps.dart';
import '../models/app_scan_result.dart';
import 'package:http/http.dart' as http;

class AppScannerService {
  static Future<List<AppScanResult>> scanInstalledApps({
    Function(double)? onProgress,
  }) async {
    List<AppScanResult> results = [];
    
    try {
      final apps = await InstalledApps.getInstalledApps();
      int totalApps = apps.length;
      int processedApps = 0;

      for (var app in apps) {
        bool isOnPlayStore = await _checkPlayStore(app.packageName);
        
        results.add(AppScanResult(
          appName: app.name ?? 'Unknown',
          packageName: app.packageName,
          icon: app.icon,
          isOnPlayStore: isOnPlayStore,
        ));

        processedApps++;
        onProgress?.call(processedApps / totalApps);
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