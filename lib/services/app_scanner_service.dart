import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'package:flutter/material.dart';

class AppScannerService {
  static Future<List<AppScanResult>> scanInstalledApps() async {
    List<AppScanResult> results = [];
    
    try {
      List<AppInfo> apps = await InstalledApps.getInstalledApps();

      for (AppInfo app in apps) {
        bool isOnPlayStore = await _checkPlayStorePresence(app.packageName);
        
        // Safely handle the icon
        Uint8List? icon;
        try {
          icon = app.icon;
        } catch (e) {
          debugPrint('Failed to load icon for ${app.name}: $e');
          icon = null;
        }
        
        results.add(AppScanResult(
          appName: app.name ?? 'Unknown',
          packageName: app.packageName,
          isOnPlayStore: isOnPlayStore,
          installationSource: 'Unknown Source',
          icon: icon,
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
      debugPrint('Error checking Play Store presence: $e');
      return false;
    }
  }
}

class AppScanResult {
  final String appName;
  final String packageName;
  final bool isOnPlayStore;
  final String installationSource;
  final Uint8List? icon;

  AppScanResult({
    required this.appName,
    required this.packageName,
    required this.isOnPlayStore,
    required this.installationSource,
    this.icon,
  });

  bool get isPotentialThreat => !isOnPlayStore;
} 