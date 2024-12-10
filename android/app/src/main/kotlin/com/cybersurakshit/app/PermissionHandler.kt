package com.cybersurakshit.app

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class PermissionHandler(private val context: Context) : MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getAppPermissions" -> {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    try {
                        val packageInfo: PackageInfo = context.packageManager.getPackageInfo(
                            packageName,
                            PackageManager.GET_PERMISSIONS
                        )
                        val permissions = packageInfo.requestedPermissions?.toList() ?: listOf()
                        result.success(permissions)
                    } catch (e: Exception) {
                        result.error("PERMISSION_ERROR", e.message, null)
                    }
                } else {
                    result.error("INVALID_PACKAGE", "Package name is required", null)
                }
            }
            else -> result.notImplemented()
        }
    }
} 