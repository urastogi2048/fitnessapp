# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Flutter Local Notifications - CRITICAL for scheduled notifications in release
-keep class com.dexterous.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# Keep notification receivers
-keep class * extends android.content.BroadcastReceiver

# AndroidX Work Manager (used by some notification plugins)
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**

# Timezone data
-keep class org.threeten.bp.** { *; }
-dontwarn org.threeten.bp.**
