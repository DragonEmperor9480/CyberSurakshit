import 'package:flutter/material.dart';
import '../services/app_scanner_service.dart';
import '../models/app_scan_result.dart';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:installed_apps/installed_apps.dart';

class AppScannerScreen extends StatefulWidget {
  const AppScannerScreen({Key? key}) : super(key: key);

  @override
  State<AppScannerScreen> createState() => _AppScannerScreenState();
}

class _AppScannerScreenState extends State<AppScannerScreen> with SingleTickerProviderStateMixin {
  bool _isScanning = true;
  List<AppScanResult> _scanResults = [];
  double _scanProgress = 0.0;
  late AnimationController _loadingController;

  // Add this list of system package prefixes to identify system apps
  final List<String> systemPackagePrefixes = [
    'com.android.',
    'com.google.android.',
    'com.samsung.',
    'com.sec.',
    'com.xiaomi.',
    'com.miui.',
    'miui.',
    'com.mi.',
    'com.huawei.',
    'com.oppo.',
    'com.vivo.',
    'com.oneplus.',
    'android.',
    'com.qualcomm.',
    'com.mediatek.',
  ];

  bool isSystemApp(String packageName) {
    return systemPackagePrefixes.any((prefix) => packageName.startsWith(prefix));
  }

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _startScan();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    setState(() {
      _isScanning = true;
      _scanResults = [];
      _scanProgress = 0.0;
    });

    try {
      final results = await AppScannerService.scanInstalledApps(
        onProgress: (progress) {
          setState(() {
            _scanProgress = progress;
          });
        },
      );

      setState(() {
        _scanResults = results;
        _isScanning = false;
      });
    } catch (e) {
      setState(() {
        _isScanning = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scanning apps: $e')),
      );
    }
  }

  Widget _buildAppCard(AppScanResult app) {
    Color getStatusColor() {
      switch (app.riskLevel) {
        case RiskLevel.safe:
          return Colors.blue;
        case RiskLevel.low:
          return Colors.green;
        case RiskLevel.medium:
          return Colors.orange;
        case RiskLevel.high:
          return Colors.red;
      }
    }

    String getStatusText() {
      switch (app.riskLevel) {
        case RiskLevel.safe:
          return 'System App - Safe';
        case RiskLevel.low:
          return 'Safe';
        case RiskLevel.medium:
          return 'Medium Risk';
        case RiskLevel.high:
          return 'High Risk';
      }
    }

    Widget buildAppIcon() {
      if (app.icon != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            app.icon!,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.android,
                  color: getStatusColor(),
                  size: 24,
                ),
              );
            },
          ),
        );
      }
      
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: getStatusColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.android,
          color: getStatusColor(),
          size: 24,
        ),
      );
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              getStatusColor().withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: ListTile(
          leading: buildAppIcon(),
          title: Text(
            app.name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            getStatusText(),
            style: TextStyle(
              color: getStatusColor(),
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(
            Icons.verified_user,
            color: getStatusColor(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shield Icon with Rotation
            AnimatedBuilder(
              animation: _loadingController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _loadingController.value * 2 * math.pi,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: const Icon(
                      Icons.shield,
                      size: 40,
                      color: Colors.blue,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            
            // Progress Container
            Container(
              width: 300,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Scanning Progress',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        '${(_scanProgress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Animated Progress Bar
                  Stack(
                    children: [
                      // Background
                      Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      // Progress
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 12,
                        width: 260 * _scanProgress,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.lightBlue],
                          ),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Analyzing installed applications',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (_scanResults.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      '${_scanResults.length} apps scanned',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Scanner'),
      ),
      body: _isScanning
          ? _buildLoadingIndicator()
          : ListView.builder(
              itemCount: _scanResults.length,
              itemBuilder: (context, index) {
                return _buildAppCard(_scanResults[index]);
              },
            ),
    );
  }
}