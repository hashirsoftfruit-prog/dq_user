-keep class  us.zoom.**{*;}
-keep class  com.zipow.**{*;}
-keep class  us.zipow.**{*;}
-keep class  org.webrtc.**{*;}
-keep class  us.google.protobuf.**{*;}
-keep class  com.google.crypto.tink.**{*;}
-keep class  androidx.security.crypto.**{*;}

# --- Juspay HyperSDK Fix ---
# Keep Juspay classes and ignore missing optional bridges
-dontwarn in.juspay.hyperalipay.**
-dontwarn in.juspay.hyperwechatpay.**
-keep class in.juspay.** { *; }


# =======================
# Zoom SDK Protection Rules
# =======================
-keep class us.zoom.** { *; }
-dontwarn us.zoom.**
-keep class com.zipow.** { *; }
-dontwarn com.zipow.**
-keep class org.webrtc.** { *; }
-dontwarn org.webrtc.**
-keepattributes *Annotation*

# Keep Flutter generated classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# Keep JNI methods (native)
-keepclassmembers class * {
    native <methods>;
}

# Keep JSON models and annotations
-keepattributes Signature, InnerClasses, EnclosingMethod
