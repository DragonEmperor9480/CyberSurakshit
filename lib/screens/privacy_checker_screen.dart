import 'package:flutter/material.dart';
import '../models/app_permission_info.dart';
import '../services/permission_checker_service.dart';

class PrivacyCheckerScreen extends StatefulWidget {
  const PrivacyCheckerScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyCheckerScreen> createState() => _PrivacyCheckerScreenState();
}

class _PrivacyCheckerScreenState extends State<PrivacyCheckerScreen> {
  bool _isLoading = false;
  List<AppPermissionInfo> _appPermissions = [];
  
  @override
  void initState() {
    super.initState();
    _loadPermissions();
  }

  Future<void> _loadPermissions() async {
    setState(() {
      _isLoading = true;
    });

    final permissions = await PermissionCheckerService.checkAppPermissions();
    
    setState(() {
      _appPermissions = permissions;
      _isLoading = false;
    });
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
                final app = _appPermissions[index];
                final sensitivePermissions = PermissionCheckerService.getSensitivePermissions(app.permissions);
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    title: Text(
                      app.appName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${sensitivePermissions.length} sensitive permissions',
                      style: TextStyle(
                        color: sensitivePermissions.isEmpty 
                            ? Colors.green 
                            : Colors.red,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Package: ${app.packageName}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            if (sensitivePermissions.isNotEmpty) ...[
                              const Text(
                                'Sensitive Permissions:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              ...sensitivePermissions.map((permission) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
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
                                          _formatPermission(permission),
                                          style: const TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _formatPermission(String permission) {
    final formatted = permission
        .replaceAll('android.permission.', '')
        .split('_')
        .map((word) => word.toLowerCase())
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
    return formatted;
  }
}
