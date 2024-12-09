import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:typed_data';

class AppScannerService {
  static Future<List<AppScanResult>> scanInstalledApps() async {
    List<AppScanResult> results = [];
    
    try {
      List<AppInfo> apps = await InstalledApps.getInstalledApps();

      for (AppInfo app in apps) {
        bool isOnPlayStore = await _checkPlayStorePresence(app.packageName);
        
        results.add(AppScanResult(
          appName: app.name ?? 'Unknown',
          packageName: app.packageName,
          isOnPlayStore: isOnPlayStore,
          icon: app.icon,
        ));
      }
    } catch (e) {
      debugPrint('Error scanning apps: $e');
    }
    
    return results;
  }

  static Future<bool> _checkPlayStorePresence(String packageName) async {
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

class AppScanResult {
  final String appName;
  final String packageName;
  final bool isOnPlayStore;
  final Uint8List? icon;

  AppScanResult({
    required this.appName,
    required this.packageName,
    required this.isOnPlayStore,
    this.icon,
  });

  bool get isPotentialThreat => !isOnPlayStore;
}