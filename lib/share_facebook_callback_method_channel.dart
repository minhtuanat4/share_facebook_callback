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
      String? imageUrl,
      String? imageName}) async {
    final result = await methodChannel.invokeMethod<String?>('facebook_share', {
      'type': type,
      'url': url,
      'imageUrl': imageUrl,
      'imageName': imageName,
      'quote': quote,
    });
    return result;
  }
}
