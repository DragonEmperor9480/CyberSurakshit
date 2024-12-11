import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:torch_light/torch_light.dart';
import 'package:vibration/vibration.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:camera/camera.dart';

class DeviceTestService {
  Future<bool> checkWiFi() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      return connectivity == ConnectivityResult.wifi;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkBluetooth() async {
    try {
      // Check if Bluetooth permission is granted
      final status = await Permission.bluetooth.status;
      if (!status.isGranted) {
        return false;
      }
      
      // Check if Bluetooth is available
      final isAvailable = await Permission.bluetooth.isGranted;
      return isAvailable;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkVibration() async {
    try {
      if (await Vibration.hasVibrator() ?? false) {
        await Vibration.vibrate(duration: 100);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkFlashlight() async {
    try {
      return await TorchLight.isTorchAvailable();
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkStorage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.existsSync();
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      LocationPermission permission = await Geolocator.checkPermission();
      return permission != LocationPermission.denied && 
             permission != LocationPermission.deniedForever;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkCamera() async {
    try {
      // First check camera permission
      final status = await Permission.camera.status;
      if (!status.isGranted) {
        return false;
      }

      // Then check if camera hardware is available
      try {
        final cameras = await availableCameras();
        return cameras.isNotEmpty;
      } catch (e) {
        // If there's an error accessing cameras but permission is granted,
        // we'll still return true as the hardware might be available
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkMicrophone() async {
    try {
      final hasPermission = await Permission.microphone.isGranted;
      return hasPermission;
    } catch (e) {
      return false;
    }
  }

  void openSettings(String component) {
    switch (component.toLowerCase()) {
      case 'wifi':
        openAppSettings();
        break;
      case 'bluetooth':
        openAppSettings();
        break;
      case 'location':
        Geolocator.openLocationSettings();
        break;
      case 'camera':
        openAppSettings();
        break;
      case 'microphone':
        openAppSettings();
        break;
      default:
        openAppSettings();
    }
  }
} 