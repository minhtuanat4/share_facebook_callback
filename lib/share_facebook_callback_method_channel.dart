import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'share_facebook_callback_platform_interface.dart';

/// An implementation of [ShareFacebookCallbackPlatform] that uses method channels.
class MethodChannelShareFacebookCallback extends ShareFacebookCallbackPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('share_facebook_callback');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> shareFacebook(
      {required String type,
      String? quote,
      String? url,
      Uint8List? unit8Image,
      String? imageName}) async {
    final result = await methodChannel.invokeMethod<String?>('facebook_share', {
      'type': type,
      'url': url,
      'unit8Image': unit8Image,
      'imageName': imageName,
      'quote': quote,
    });
    return result;
  }
}
