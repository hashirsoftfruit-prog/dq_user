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
