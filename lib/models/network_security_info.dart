class NetworkSecurityInfo {
  final String connectionType;    // WiFi, Mobile Data, VPN, etc.
  final bool isVpnActive;
  final bool isWifiEncrypted;
  final bool isHttpsEnabled;
  final String wifiName;
  final List<String> vulnerabilities;
  final String securityLevel;     // High, Medium, Low

  NetworkSecurityInfo({
    required this.connectionType,
    required this.isVpnActive,
    required this.isWifiEncrypted,
    required this.isHttpsEnabled,
    required this.wifiName,
    required this.vulnerabilities,
    required this.securityLevel,
  });
} 