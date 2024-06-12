package com.example.xplor

import io.flutter.embedding.android.FlutterActivity

import android.os.Bundle
import android.webkit.WebSettings
import android.webkit.WebView
import android.webkit.CookieManager;
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.xplor/webview"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "clearCache") {
                clearCache();
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun clearCache() {
        val webView = WebView(getApplicationContext())
        webView.clearCache(true)
        webView.clearHistory();
        /*webView.settings.domStorageEnabled = true
        webView.settings.javaScriptEnabled = true*/

        val cookieManager = CookieManager.getInstance();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            cookieManager.removeAllCookies(null);
            cookieManager.flush();
        } else {
            cookieManager.removeAllCookie();
        }
    }
}
