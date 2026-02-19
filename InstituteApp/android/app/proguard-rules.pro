# =============================================================
# ProGuard / R8 Rules — Vertex Institute App
# =============================================================

# ──────────────────────────────────────────────────────────────
# Flutter Engine
# ──────────────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# ──────────────────────────────────────────────────────────────
# Flutter Generated Plugin Registrant
# ──────────────────────────────────────────────────────────────
-keep class io.flutter.plugins.GeneratedPluginRegistrant { *; }

# ──────────────────────────────────────────────────────────────
# flutter_secure_storage
# ──────────────────────────────────────────────────────────────
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keepclassmembers class com.it_nomads.fluttersecurestorage.** { *; }

# ──────────────────────────────────────────────────────────────
# Realm (MongoDB Realm / RealmDB)
# ──────────────────────────────────────────────────────────────
-keep class io.realm.** { *; }
-keep class com.mongodb.realm.** { *; }
-keepclassmembers class io.realm.** { *; }
-dontwarn io.realm.**
-dontwarn com.mongodb.realm.**

# Keep Realm model classes (annotated with @RealmClass)
-keep @io.realm.annotations.RealmModule class *
-keep class * extends io.realm.RealmObject { *; }
-keepclassmembers class * extends io.realm.RealmObject {
    <init>();
}

# ──────────────────────────────────────────────────────────────
# BouncyCastle / encrypt package (used for AES encryption)
# ──────────────────────────────────────────────────────────────
-keep class org.bouncycastle.** { *; }
-keepclassmembers class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**

# ──────────────────────────────────────────────────────────────
# file_picker
# ──────────────────────────────────────────────────────────────
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-dontwarn com.mr.flutter.plugin.filepicker.**

# ──────────────────────────────────────────────────────────────
# Cloudinary (cloudinary_flutter / cloudinary_url_gen)
# ──────────────────────────────────────────────────────────────
-keep class com.cloudinary.** { *; }
-keepclassmembers class com.cloudinary.** { *; }
-dontwarn com.cloudinary.**

# ──────────────────────────────────────────────────────────────
# url_launcher
# ──────────────────────────────────────────────────────────────
-keep class io.flutter.plugins.urllauncher.** { *; }
-dontwarn io.flutter.plugins.urllauncher.**

# ──────────────────────────────────────────────────────────────
# path_provider / shared_preferences / sqflite
# ──────────────────────────────────────────────────────────────
-keep class io.flutter.plugins.pathprovider.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.tekartik.sqflite.** { *; }
-dontwarn io.flutter.plugins.pathprovider.**
-dontwarn io.flutter.plugins.sharedpreferences.**

# ──────────────────────────────────────────────────────────────
# Kotlin standard library
# ──────────────────────────────────────────────────────────────
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# ──────────────────────────────────────────────────────────────
# Keep native JNI methods
# ──────────────────────────────────────────────────────────────
-keepclasseswithmembernames class * {
    native <methods>;
}

# ──────────────────────────────────────────────────────────────
# Keep Serializable / Parcelable
# ──────────────────────────────────────────────────────────────
-keepclassmembers class * implements java.io.Serializable {
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# ──────────────────────────────────────────────────────────────
# Keep enums (important for reflection-based code)
# ──────────────────────────────────────────────────────────────
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ──────────────────────────────────────────────────────────────
# BuildConfig — keep so the app can read env flags at runtime
# ──────────────────────────────────────────────────────────────
-keep class com.vertex.instituteapp.BuildConfig { *; }

# ──────────────────────────────────────────────────────────────
# OkHttp / HTTP (used internally by http package)
# ──────────────────────────────────────────────────────────────
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# ──────────────────────────────────────────────────────────────
# Remove logging in release (security hardening)
# ──────────────────────────────────────────────────────────────
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
}

# ──────────────────────────────────────────────────────────────
# General optimisation / safety flags
# ──────────────────────────────────────────────────────────────
-optimizationpasses 5
-allowaccessmodification
-repackageclasses ''
