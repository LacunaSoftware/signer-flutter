package com.example.flutter_signer

import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.lang.reflect.Method


class MainActivity: FlutterActivity() {
    private val CHANNEL = "yourpackageName/channelName";
    private lateinit var channel: MethodChannel

     override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { call, result ->
            if (call.method == "handleIntent") {
                var uri: String?  = call.argument("uri");
                Intent intent = Intent.parseUri(uri, Intent.URI_INTENT_SCHEME);
                startActivity(intent);
                Log.d("TAG", "message");
                Toast.makeText(this, uri, Toast.LENGTH_LONG).show()
            }
        }
    }
}
