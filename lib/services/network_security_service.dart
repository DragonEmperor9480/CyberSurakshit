import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/network_security_info.dart';

class NetworkSecurityService {
  static final NetworkInfo _networkInfo = NetworkInfo();
  
  static Future<NetworkSecurityInfo> checkNetworkSecurity() async {
    await _requestPermissions();
    await Future.delayed(const Duration(seconds: 1));
    
    final connectivityResult = await Connectivity().checkConnectivity();
    final isVpnActive = await _checkVpnConnection();
    String wifiName = 'Unknown';
    
    try {
      if (isVpnActive) {
        wifiName = 'VPN Connection';
      } else if (connectivityResult == ConnectivityResult.wifi) {
        if (await Permission.location.isGranted) {
          wifiName = await _getWifiName();
          print('WiFi Name: $wifiName');
        } else {
          wifiName = 'Location Permission Required';
          print('Location Permission not granted');
        }
      } else if (connectivityResult == ConnectivityResult.mobile) {
        wifiName = 'Mobile Data';
      }
    } catch (e) {
      print('Error getting network name: $e');
      wifiName = 'Error Getting Network Name';
    }

    final vulnerabilities = await _checkVulnerabilities();
    bool isWifiEncrypted = false;
    String connectionType = 'Unknown';
    
    if (isVpnActive) {
      connectionType = 'VPN';
      isWifiEncrypted = true;
    } else {
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
          connectionType = 'WiFi';
          isWifiEncrypted = await _checkWifiEncryption();
          break;
        case ConnectivityResult.mobile:
          connectionType = 'Mobile Data';
          isWifiEncrypted = true;
          break;
        default:
          connectionType = 'Unknown';
      }
    }

    String securityLevel = _calculateSecurityLevel(
      isVpnActive,
      isWifiEncrypted,
      vulnerabilities.length,
    );

    return NetworkSecurityInfo(
      connectionType: connectionType,
      isVpnActive: isVpnActive,
      isWifiEncrypted: isWifiEncrypted,
      isHttpsEnabled: true,
      wifiName: wifiName,
      vulnerabilities: vulnerabilities,
      securityLevel: securityLevel,
    );
  }

  static Future<void> _requestPermissions() async {
    await Permission.locationWhenInUse.request();
    await Permission.locationAlways.request();
  }

  static Future<String> _getWifiName() async {
    try {
      String? name = await _networkInfo.getWifiName();
      
      if (name != null && name.isNotEmpty) {
        name = name.replaceAll('"', '');
        if (name.startsWith('SSID: ')) {
          name = name.substring(6);
        }
        return name;
      }
      
      return 'Unknown Network';
    } catch (e) {
      print('Error in _getWifiName: $e');
      return 'Unknown Network';
    }
  }

  static Future<bool> _checkVpnConnection() async {
    try {
      // Check multiple indicators for VPN
      final connectivityResult = await Connectivity().checkConnectivity();
      
      // Debug prints
      print('Connectivity Result: $connectivityResult');
      
      // Method 1: Direct VPN check
      if (connectivityResult == ConnectivityResult.vpn) {
        print('VPN detected via ConnectivityResult.vpn');
        return true;
      }

      // Method 2: Network interface check
      final networkInfo = NetworkInfo();
      final interfaces = await networkInfo.getWifiIP();
      print('Network Interface IP: $interfaces');
      
      // Common VPN IP ranges
      final vpnRanges = [
        '10.', // Common VPN range
        '172.16.', // Common VPN range
        '192.168.', // Local network (might be VPN)
        'fd', // IPv6 VPN prefix
        'fe80:', // IPv6 link-local
      ];

      if (interfaces != null) {
        for (final range in vpnRanges) {
          if (interfaces.startsWith(range)) {
            print('VPN detected via IP range: $range');
            return true;
          }
        }
      }

      return false;
    } catch (e) {
      print('Error checking VPN connection: $e');
      return false;
    }
  }

  static Future<bool> _checkWifiEncryption() async {
    try {
      if (await Permission.location.isGranted) {
        final wifiName = await _getWifiName();
        return !wifiName.toLowerCase().contains('unsecured') &&
               !wifiName.toLowerCase().contains('guest');
      }
      return true;
    } catch (e) {
      return true;
    }
  }

  static Future<List<String>> _checkVulnerabilities() async {
    List<String> vulnerabilities = [];
    
    if (!await Permission.locationWhenInUse.isGranted) {
      vulnerabilities.add('Location Permission Required for Network Analysis');
    }
    
    if (!await _checkWifiEncryption()) {
      vulnerabilities.add('Unencrypted WiFi Network');
    }
    
    if (!await _checkVpnConnection()) {
      vulnerabilities.add('No VPN Protection');
    }

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.wifi) {
      final wifiName = await _getWifiName();
      if (wifiName.toLowerCase().contains('public') || 
          wifiName.toLowerCase().contains('guest')) {
        vulnerabilities.add('Using Public WiFi');
      }
    }

    return vulnerabilities;
  }

  static String _calculateSecurityLevel(
    bool isVpnActive,
    bool isWifiEncrypted,
    int vulnerabilitiesCount,
  ) {
    if (isVpnActive && isWifiEncrypted && vulnerabilitiesCount == 0) {
      return 'High';
    } else if (isWifiEncrypted && vulnerabilitiesCount <= 1) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }
} 