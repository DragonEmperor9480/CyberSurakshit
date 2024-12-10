import 'package:flutter/material.dart';
import '../services/permission_checker_service.dart';
import '../models/app_permission_info.dart';
import 'dart:typed_data';

class PrivacyCheckerScreen extends StatefulWidget {
  const PrivacyCheckerScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyCheckerScreen> createState() => _PrivacyCheckerScreenState();
}

class _PrivacyCheckerScreenState extends State<PrivacyCheckerScreen> {
  List<AppPermissionInfo> _appPermissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    setState(() => _isLoading = true);
    final permissions = await PermissionCheckerService.checkAppPermissions();
    setState(() {
      _appPermissions = permissions;
      _isLoading = false;
    });
  }

  Widget _buildAppPermissionCard(AppPermissionInfo app) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            app.appName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${app.permissions.length} permissions',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: app.permissions.map((permission) {
                  final bool isSensitive = _isSensitivePermission(permission);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSensitive 
                          ? Colors.red.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSensitive
                            ? Colors.red.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              isSensitive ? Icons.warning : Icons.check_circle,
                              size: 18,
                              color: isSensitive ? Colors.red : Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              permission,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: isSensitive ? Colors.red[700] : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          PermissionCheckerService.getPermissionDescription(permission),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSensitivePermission(String permission) {
    final sensitivePermissions = [
      'Camera',
      'Location',
      'Microphone',
      'Contacts',
      'Phone',
      'Sms',
      'Calendar',
    ];
    return sensitivePermissions.any(
      (sensitive) => permission.toLowerCase().contains(sensitive.toLowerCase())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Checker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPermissions,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _appPermissions.length,
              itemBuilder: (context, index) {
                return _buildAppPermissionCard(_appPermissions[index]);
              },
            ),
    );
  }
}
