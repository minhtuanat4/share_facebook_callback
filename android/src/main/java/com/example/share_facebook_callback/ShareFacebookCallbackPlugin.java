package com.example.share_facebook_callback;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.graphics.Bitmap;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.core.content.FileProvider;

import com.facebook.share.model.SharePhoto;
import com.facebook.share.model.SharePhotoContent;
import com.facebook.share.widget.ShareDialog;

import io.flutter.embedding.engine.plugins.activity.ActivityAware;

import java.io.File;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import com.facebook.CallbackManager;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.plugin.common.BinaryMessenger;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.widget.MessageDialog;
import android.database.Cursor;
import android.os.Bundle;
import android.provider.MediaStore;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import io.flutter.plugin.common.PluginRegistry;


/**
 * ShareFacebookCallbackPlugin
 */
public class ShareFacebookCallbackPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener{

    final private static String _methodFacebook = "facebook_share";
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Activity activity;
    private CallbackManager callbackManager;

    private String type;
    private String quote;
    private String url;
    private byte[] uint8Image;
    private String imageName;

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    binding.addActivityResultListener(this);
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    // No implementation
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    binding.removeActivityResultListener(this);
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivity() {
    // activity = null;
    // binding.removeActivityResultListener(this);
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getBinaryMessenger());
    }

   private void onAttachedToEngine(BinaryMessenger messenger) {
      channel = new MethodChannel(messenger, "share_facebook_callback");
      channel.setMethodCallHandler(this);
      callbackManager = CallbackManager.Factory.create();
  }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
        activity = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
      System.out.println("--------------------onMethodCall");
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equalsIgnoreCase("facebook_share")){
        type = call.argument("type");
        quote = call.argument("quote");
        url = call.argument("url");
        uint8Image = call.argument("uint8Image");
        imageName = call.argument("imageName");
        switch (type) {
          case "ShareType.shareLinksFacebook":
            shareLinksFacebook(url, quote, result);
            break;
          case "ShareType.sharePhotoFacebook":
            sharePhotoFacebook(uint8Image, quote, result);
            break;
          default:
            result.notImplemented();
            break;
        }
    } 
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return callbackManager.onActivityResult(requestCode, resultCode, data);
    }

    private void shareLinksFacebook(String url, String quote, Result result2) {
        ShareDialog shareDialog = new ShareDialog(activity);
        
        ShareLinkContent content = new ShareLinkContent.Builder()
                .setContentUrl(Uri.parse(url))
                .setQuote(quote)
                .build();
        if (ShareDialog.canShow(ShareLinkContent.class)) {
            
            shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
            @Override
            public void onSuccess(Sharer.Result result) {
                System.out.println("--------------------success");
                result2.success("success");
            }

            @Override
            public void onCancel() {
                System.out.println("-----------------cancel");
                result2.success("cancel");
            }

            @Override
            public void onError(FacebookException error) {
                System.out.println("---------------error");
                result2.success("error");
            }
        });
          shareDialog.show(content);
        }
        
    }

    private void sharePhotoFacebook(byte[] uint8Image,  String quote,Result result2) {
      System.out.println("--------------------sharePhotoFacebook");
        ShareDialog shareDialog = new ShareDialog(activity);
        shareDialog.registerCallback(callbackManager, new FacebookCallback<Sharer.Result>() {
            @Override
            public void onSuccess(Sharer.Result result) {
                System.out.println("--------------------success");
                result2.success(true);
            }

            @Override
            public void onCancel() {
                System.out.println("-----------------cancel");
                result2.success(false);
            }

            @Override
            public void onError(FacebookException error) {
                System.out.println("---------------error");
                result2.success(false);
            }
        });

        SharePhoto photo = new SharePhoto.Builder()
              .setBitmap(BitmapFactory.decodeByteArray(uint8Image, 0, uint8Image.length))
              .setCaption(quote)
              .build();
        SharePhotoContent content = new SharePhotoContent.Builder()
        .addPhoto(photo)
        .build();
        if (shareDialog.canShow(SharePhotoContent.class)) {
            shareDialog.show(content);
        }
    }
}
