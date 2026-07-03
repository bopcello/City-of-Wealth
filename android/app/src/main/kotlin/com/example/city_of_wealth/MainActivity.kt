package com.city_of_wealth

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.city_of_wealth/share"

    override fun onCreate(savedInstanceState: Bundle?) {
        setTheme(resolveLaunchTheme())
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "shareText") {
                val text = call.argument<String>("text")
                if (text != null) {
                    shareText(text)
                    result.success(true)
                } else {
                    result.error("INVALID_ARGUMENT", "Text cannot be null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun shareText(text: String) {
        val sendIntent: Intent = Intent().apply {
            action = Intent.ACTION_SEND
            putExtra(Intent.EXTRA_TEXT, text)
            type = "text/plain"
        }

        val shareIntent = Intent.createChooser(sendIntent, null)
        startActivity(shareIntent)
    }

    private fun resolveLaunchTheme(): Int {
        val prefs = getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        val launchDarkMode = prefs.getBoolean("flutter.isDarkMode", findLatestScopedDarkMode(prefs))
        return if (launchDarkMode) R.style.LaunchTheme_Dark else R.style.LaunchTheme_Light
    }

    private fun findLatestScopedDarkMode(prefs: android.content.SharedPreferences): Boolean {
        val allEntries = prefs.all
        var latestPrefix: String? = null
        var latestUpdated = Long.MIN_VALUE

        for ((key, value) in allEntries) {
            if (!key.startsWith("flutter.") || !key.endsWith("_lastUpdated")) continue
            val updatedAt = when (value) {
                is Long -> value
                is Int -> value.toLong()
                else -> continue
            }

            if (updatedAt > latestUpdated) {
                latestUpdated = updatedAt
                latestPrefix = key.removePrefix("flutter.").removeSuffix("_lastUpdated")
            }
        }

        if (latestPrefix == null) return false
        return prefs.getBoolean("flutter.${latestPrefix}_isDarkMode", false)
    }
}

class QuizNotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == Intent.ACTION_USER_PRESENT) {
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val newQuizReady = prefs.getBoolean("flutter.new_quiz_ready", false)
            
            if (newQuizReady) {
                showNotification(context)
                // Reset the flag so we don't notify multiple times on each unlock
                prefs.edit().putBoolean("flutter.new_quiz_ready", false).apply()
            }
        }
    }

    private fun showNotification(context: Context) {
        val channelId = "daily_quiz"
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            val name = "Daily Quiz"
            val descriptionText = "Notifications for new daily quizzes"
            val importance = NotificationManager.IMPORTANCE_DEFAULT
            val channel = NotificationChannel(channelId, name, importance).apply {
                description = descriptionText
            }
            notificationManager.createNotificationChannel(channel)
        }

        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
        }
        val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_IMMUTABLE)

        val builder = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("New Daily Quiz Available!")
            .setContentText("Master your money today. A new challenge awaits!")
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)

        notificationManager.notify(999, builder.build())
    }
}
