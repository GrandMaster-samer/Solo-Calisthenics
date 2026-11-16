package com.grandmastersamer.solo_calisthenics

import android.view.KeyEvent
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

/**
 * Lets the Dart side count reps with the hardware volume buttons.
 * While capture is enabled, volume key presses are swallowed (volume does not change)
 * and forwarded as "up"/"down" events. Android only; iOS has no supported API for this.
 */
// FlutterFragmentActivity is required by local_auth (biometric prompt).
class MainActivity : FlutterFragmentActivity() {
    private var capture = false
    private var sink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(messenger, "solo_calisthenics/volume_buttons").setMethodCallHandler { call, result ->
            if (call.method == "setCapture") {
                capture = call.arguments as? Boolean ?: false
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
        // Blocks screenshots and hides the content in the recent-apps view while locked content is shown.
        MethodChannel(messenger, "solo_calisthenics/window").setMethodCallHandler { call, result ->
            if (call.method == "setSecure") {
                if (call.arguments as? Boolean == true) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                } else {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
        EventChannel(messenger, "solo_calisthenics/volume_buttons/events").setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) { sink = events }
                override fun onCancel(arguments: Any?) { sink = null }
            },
        )
    }

    override fun dispatchKeyEvent(event: KeyEvent): Boolean {
        val isVolume = event.keyCode == KeyEvent.KEYCODE_VOLUME_UP || event.keyCode == KeyEvent.KEYCODE_VOLUME_DOWN
        if (capture && isVolume) {
            if (event.action == KeyEvent.ACTION_DOWN && event.repeatCount == 0) {
                sink?.success(if (event.keyCode == KeyEvent.KEYCODE_VOLUME_UP) "up" else "down")
            }
            return true
        }
        return super.dispatchKeyEvent(event)
    }
}
