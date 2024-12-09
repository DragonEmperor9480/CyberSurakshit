import 'package:flutter/material.dart';
import '../services/app_scanner_service.dart';
import 'dart:typed_data';

class AppScannerScreen extends StatefulWidget {
  const AppScannerScreen({Key? key}) : super(key: key);

  @override
  State<AppScannerScreen> createState() => _AppScannerScreenState();
}

class _AppScannerScreenState extends State<AppScannerScreen> {
  bool _isScanning = false;
  List<AppScanResult> _scanResults = [];

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _scanResults = [];
    });

    final results = await AppScannerService.scanInstalledApps();
    
    setState(() {
      _scanResults = results;
      _isScanning = false;
    });
  }

  Widget _buildAppCard(AppScanResult app) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildAppIcon(app.icon),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.appName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    app.packageName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPlayStoreStatus(app.isOnPlayStore),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppIcon(Uint8List? iconData) {
    if (iconData == null || iconData.isEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.android, color: Colors.grey),
      );
    }

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.memory(
          iconData,
          width: 48,
          height: 48,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.android, color: Colors.grey),
            );
          },
        ),
      );
    } catch (e) {
      debugPrint('Failed to decode image: $e');
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.android, color: Colors.grey),
      );
    }
  }

  Widget _buildPlayStoreStatus(bool isOnPlayStore) {
    return Row(
      children: [
        Icon(
          isOnPlayStore ? Icons.check_circle : Icons.warning,
          color: isOnPlayStore ? Colors.green : Colors.red,
          size: 16,
        ),
        const SizedBox(width: 4),
        Text(
          isOnPlayStore ? 'On Play Store' : 'Not on Play Store',
          style: TextStyle(
            fontSize: 12,
            color: isOnPlayStore ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Scanner'),
      ),
      body: _isScanning
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _scanResults.length,
              itemBuilder: (context, index) {
                return _buildAppCard(_scanResults[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startScan,
        child: const Icon(Icons.search),
      ),
    );
  }
}