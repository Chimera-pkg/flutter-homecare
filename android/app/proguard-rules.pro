# ---------------------------------------------------------
# 1. FLUTTER WRAPPER (Required)
# ---------------------------------------------------------
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-dontwarn io.flutter.embedding.**

# ---------------------------------------------------------
# 2. FLUWX (WeChat)
# WeChat SDK uses reflection heavily and callback activities, 
# so we must be careful here.
# ---------------------------------------------------------
-keep class com.tencent.mm.opensdk.** { *; }
-keep class com.tencent.wxop.** { *; }
-keep class com.tencent.mm.sdk.** { *; }
-keep class com.jarvan.fluwx.** { *; }
# Keep the callback activity specifically (required for login to work)
-keep class **.wxapi.WXEntryActivity { *; }
-keep class **.wxapi.WXPayEntryActivity { *; }
-dontwarn com.tencent.mm.**

# ---------------------------------------------------------
# 3. GSON (Only if you actually use Gson directly)
# If you use 'dart:convert' for JSON, delete this section.
# ---------------------------------------------------------
# Only keep the specific classes you use for API models. 
# Replace 'com.example.yourapp.models' with your actual package path if needed.
# -keep class com.m2health.app.data.models.** { *; } 

# ---------------------------------------------------------
# 4. GOOGLE SIGN IN & AUTH
# ---------------------------------------------------------
# The Google Services plugin handles the "keep" rules automatically.
# We only add "dontwarn" to silence harmless build logs.
-dontwarn com.google.android.gms.**
-dontwarn com.google.api.client.**

# ---------------------------------------------------------
# 5. RETROFIT / OKHTTP
# ---------------------------------------------------------
# R8 handles these automatically via the library's internal rules.
# We just silence warnings for optional dependencies (like Okio).
-dontwarn okhttp3.**
-dontwarn retrofit2.**
-dontwarn okio.**