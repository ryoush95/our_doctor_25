package com.kyad.wooadoctor;

import android.os.Bundle;
import android.util.Base64;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.google.android.gms.common.util.Hex;
import com.zoyi.channel.plugin.android.ChannelIO;
import com.zoyi.channel.plugin.android.open.callback.BootCallback;
import com.zoyi.channel.plugin.android.open.config.BootConfig;
import com.zoyi.channel.plugin.android.open.enumerate.BootStatus;
import com.zoyi.channel.plugin.android.open.model.Profile;
import com.zoyi.channel.plugin.android.open.model.User;

import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "doctor.flutter.dev";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            // Note: this method is invoked on the main thread.
                            // TODO
                            if (call.method.equals("talk")) {
                                String uid = call.argument("uid");
                                String name = call.argument("name");
                                //showCannelTalk();
                                runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        Profile profile = Profile.create()
                                                .setName(name);

                                        BootConfig bootConfig = BootConfig.create("3eb2de57-ecb7-4a0d-9f99-ca0137bf5a65");
//                                        String hash = encode(uid, "8c7b917dab36469c71c16e8af5f411567d409b2b24d9fe5de0758036311a94c2", "HMACSHA256");
//                                        bootConfig.setMemberId(hash);
                                        bootConfig.setMemberId(uid);
                                        bootConfig.setProfile(profile);

                                        ChannelIO.boot(bootConfig, new BootCallback() {
                                            @Override
                                            public void onComplete(BootStatus bootStatus, @Nullable User user) {
                                                Log.d("Test", "tet");
                                                ChannelIO.showMessenger(MainActivity.this);
                                            }
                                        });

                                        result.success(50);
                                    }
                                });

                            } else if (call.method.equals("startchanneltalk")) {
                                ChannelIO.initialize(getApplication());
                                result.success("111");
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private static byte[] hexify(String string) {
        return Base64.decode(string, Base64.DEFAULT);
    }

    public static String encode(String key, String salt, String algorithm) {
        try {
            byte[] data = key.getBytes();
            SecretKey macKey = new SecretKeySpec(hexify(salt), algorithm);
            Mac mac = Mac.getInstance(algorithm);
            mac.init(macKey);
            byte[] digest = mac.doFinal(data);
            byte[] hexBytes = Base64.encode(digest, 0);
            return new String(hexBytes, StandardCharsets.UTF_8);
        } catch (InvalidKeyException | NoSuchAlgorithmException e) {
//            log.error(e.getMessage(), e);
            throw new RuntimeException(e);
        }
    }
}
