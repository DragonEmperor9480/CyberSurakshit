import 'package:flutter/material.dart';
import '../services/network_security_service.dart';
import '../models/network_security_info.dart';

class NetworkSecurityScreen extends StatefulWidget {
  const NetworkSecurityScreen({Key? key}) : super(key: key);

  @override
  State<NetworkSecurityScreen> createState() => _NetworkSecurityScreenState();
}

class _NetworkSecurityScreenState extends State<NetworkSecurityScreen> {
  NetworkSecurityInfo? _securityInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkNetworkSecurity();
  }

  Future<void> _checkNetworkSecurity() async {
    setState(() => _isLoading = true);
    final info = await NetworkSecurityService.checkNetworkSecurity();
    setState(() {
      _securityInfo = info;
      _isLoading = false;
    });
  }

  Color _getSecurityLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildSecurityCard() {
    if (_securityInfo == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.security,
                  color: _getSecurityLevelColor(_securityInfo!.securityLevel),
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security Level: ${_securityInfo!.securityLevel}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _getSecurityLevelColor(_securityInfo!.securityLevel),
                      ),
                    ),
                    Text(
                      _securityInfo!.connectionType,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            _buildInfoRow(
              'Network Name',
              _securityInfo!.wifiName,
              Icons.wifi,
            ),
            _buildInfoRow(
              'VPN Status',
              _securityInfo!.isVpnActive ? 'Active' : 'Inactive',
              Icons.vpn_key,
              isWarning: !_securityInfo!.isVpnActive,
            ),
            _buildInfoRow(
              'Encryption',
              _securityInfo!.isWifiEncrypted ? 'Encrypted' : 'Unencrypted',
              Icons.lock,
              isWarning: !_securityInfo!.isWifiEncrypted,
            ),
            if (_securityInfo!.vulnerabilities.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Vulnerabilities Detected',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              ..._securityInfo!.vulnerabilities.map((v) => _buildVulnerabilityItem(v)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, {bool isWarning = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isWarning ? Colors.orange : Colors.blue,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isWarning ? Colors.orange : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVulnerabilityItem(String vulnerability) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.warning,
            color: Colors.orange,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              vulnerability,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.orange,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Security'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkNetworkSecurity,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildSecurityCard(),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Last checked: ${DateTime.now().toString().split('.')[0]}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
} 