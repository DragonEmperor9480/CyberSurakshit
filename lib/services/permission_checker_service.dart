import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';
import '../models/app_permission_info.dart';

class PermissionCheckerService {
  static const List<String> sensitivePermissions = [
    'android.permission.ACCESS_FINE_LOCATION',
    'android.permission.ACCESS_COARSE_LOCATION',
    'android.permission.CAMERA',
    'android.permission.READ_CONTACTS',
    'android.permission.READ_EXTERNAL_STORAGE',
    'android.permission.WRITE_EXTERNAL_STORAGE',
    'android.permission.READ_SMS',
    'android.permission.SEND_SMS',
    'android.permission.READ_CALL_LOG',
    'android.permission.RECORD_AUDIO',
    'android.permission.READ_PHONE_STATE',
  ];

  static Future<List<AppPermissionInfo>> checkAppPermissions() async {
    List<AppPermissionInfo> permissionInfoList = [];
    
    try {
      List<AppInfo> apps = await InstalledApps.getInstalledApps();

      for (AppInfo app in apps) {
        List<String> permissions = [];
        
        permissionInfoList.add(
          AppPermissionInfo(
            appName: app.name ?? 'Unknown',
            packageName: app.packageName,
            permissions: permissions,
            isSystemApp: false,
          ),
        );
      }
    } catch (e) {
      print('Error checking permissions: $e');
    }

    return permissionInfoList;
  }

  static List<String> getSensitivePermissions(List<String> permissions) {
    return permissions.where((permission) => 
      sensitivePermissions.contains(permission)
    ).toList();
  }
} 