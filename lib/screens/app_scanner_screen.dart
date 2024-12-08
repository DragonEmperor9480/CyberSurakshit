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

  Widget _buildAppIcon(Uint8List? iconData) {
    if (iconData == null) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.android, color: Colors.grey),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        iconData,
        width: 40,
        height: 40,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.android, color: Colors.grey),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Scanner'),
        backgroundColor: const Color(0xFF6C63FF),
      ),
      body: Column(
        children: [
          if (_isScanning)
            const LinearProgressIndicator(
              backgroundColor: Color(0xFF6C63FF),
            ),
          Expanded(
            child: _isScanning
                ? const Center(child: Text('Scanning apps...'))
                : _scanResults.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _startScan,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C63FF),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Start Scan'),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _scanResults.length,
                        itemBuilder: (context, index) {
                          final result = _scanResults[index];
                          return ListTile(
                            leading: _buildAppIcon(result.icon),
                            title: Text(result.appName),
                            subtitle: Text(result.packageName),
                            trailing: result.isPotentialThreat
                                ? const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Colors.orange,
                                  )
                                : const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
} 