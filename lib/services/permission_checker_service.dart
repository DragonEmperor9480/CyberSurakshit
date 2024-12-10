import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import '../models/app_permission_info.dart';

class PermissionCheckerService {
  static const platform = MethodChannel('com.cybersurakshit.app/permissions');

  static Future<List<AppPermissionInfo>> checkAppPermissions() async {
    List<AppPermissionInfo> appPermissions = [];
    
    try {
      final apps = await InstalledApps.getInstalledApps();
      
      for (var app in apps) {
        try {
          final List<dynamic> permissions = await platform.invokeMethod(
            'getAppPermissions',
            {'packageName': app.packageName},
          );

          appPermissions.add(
            AppPermissionInfo(
              appName: app.name ?? 'Unknown',
              packageName: app.packageName,
              icon: app.icon,
              permissions: _formatPermissions(
                permissions.map((p) => p.toString()).toList(),
              ),
            ),
          );
        } catch (e) {
          print('Error getting permissions for ${app.packageName}: $e');
        }
      }
    } catch (e) {
      print('Error checking permissions: $e');
    }
    
    return appPermissions;
  }

  static List<String> _formatPermissions(List<String> permissions) {
    return permissions.map((permission) {
      final parts = permission.split('.');
      if (parts.isNotEmpty) {
        String readable = parts.last
            .replaceAll('_', ' ')
            .toLowerCase()
            .split(' ')
            .map((word) => word.length > 0 
                ? '${word[0].toUpperCase()}${word.substring(1)}' 
                : '')
            .join(' ');
        return readable;
      }
      return permission;
    }).toList();
  }

  static String getPermissionDescription(String permission) {
    final descriptions = {
      'Camera': 'Access device camera to take photos and videos',
      'Location': 'Access device location',
      'Microphone': 'Record audio using device microphone',
      'Storage': 'Access files on device storage',
      'Contacts': 'Access your contacts',
      'Phone': 'Make and manage phone calls',
      'Sms': 'Send and view SMS messages',
      'Calendar': 'Access calendar events',
    };

    return descriptions[permission] ?? 'Access to $permission';
  }
} 