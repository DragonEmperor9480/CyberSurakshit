import 'package:flutter/material.dart';
import '../services/device_test_service.dart';

class PhoneDoctorScreen extends StatefulWidget {
  const PhoneDoctorScreen({Key? key}) : super(key: key);

  @override
  State<PhoneDoctorScreen> createState() => _PhoneDoctorScreenState();
}

class _PhoneDoctorScreenState extends State<PhoneDoctorScreen> {
  final DeviceTestService _testService = DeviceTestService();
  Map<String, bool?> testResults = {};
  bool isTestingInProgress = false;

  @override
  void initState() {
    super.initState();
    _initializeTests();
  }

  void _initializeTests() {
    testResults = {
      'WiFi': null,
      'Bluetooth': null,
      'Vibration': null,
      'Flashlight': null,
      'Storage': null,
      'Location': null,
      'Camera': null,
      'Microphone': null,
    };
  }

  Future<void> _runTests() async {
    setState(() {
      isTestingInProgress = true;
      _initializeTests();
    });

    // Test WiFi
    testResults['WiFi'] = await _testService.checkWiFi();
    setState(() {});

    // Test Bluetooth
    testResults['Bluetooth'] = await _testService.checkBluetooth();
    setState(() {});

    // Test Vibration
    testResults['Vibration'] = await _testService.checkVibration();
    setState(() {});

    // Test Flashlight
    testResults['Flashlight'] = await _testService.checkFlashlight();
    setState(() {});

    // Test Storage
    testResults['Storage'] = await _testService.checkStorage();
    setState(() {});

    // Test Location
    testResults['Location'] = await _testService.checkLocation();
    setState(() {});

    // Test Camera
    testResults['Camera'] = await _testService.checkCamera();
    setState(() {});

    // Test Microphone
    testResults['Microphone'] = await _testService.checkMicrophone();
    setState(() {});

    setState(() {
      isTestingInProgress = false;
    });
  }

  Widget _buildTestCard(String testName, bool? result) {
    IconData icon;
    Color color;
    String status;

    if (result == null) {
      icon = Icons.hourglass_empty;
      color = Colors.grey;
      status = 'Pending';
    } else if (result) {
      icon = Icons.check_circle;
      color = Colors.green;
      status = 'Working';
    } else {
      icon = Icons.error;
      color = Colors.red;
      status = 'Not Working';
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 28),
        title: Text(
          testName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          status,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: result == false
            ? TextButton(
                onPressed: () {
                  _testService.openSettings(testName.toLowerCase());
                },
                child: const Text('Fix'),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Doctor'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Component Health Check',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: testResults.length,
              itemBuilder: (context, index) {
                String testName = testResults.keys.elementAt(index);
                bool? result = testResults[testName];
                return _buildTestCard(testName, result);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isTestingInProgress ? null : _runTests,
        label: Text(isTestingInProgress ? 'Testing...' : 'Start Test'),
        icon: Icon(isTestingInProgress ? Icons.hourglass_empty : Icons.play_arrow),
      ),
    );
  }
} 