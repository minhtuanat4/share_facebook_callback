import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'share_facebook_callback_method_channel.dart';

abstract class ShareFacebookCallbackPlatform extends PlatformInterface {
  /// Constructs a ShareFacebookCallbackPlatform.
  ShareFacebookCallbackPlatform() : super(token: _token);

  static final Object _token = Object();

  static ShareFacebookCallbackPlatform _instance =
      MethodChannelShareFacebookCallback();

  /// The default instance of [ShareFacebookCallbackPlatform] to use.
  ///
  /// Defaults to [MethodChannelShareFacebookCallback].
  static ShareFacebookCallbackPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ShareFacebookCallbackPlatform] when
  /// they register themselves.
  static set instance(ShareFacebookCallbackPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> shareFacebook({
    required String type,
    String? quote,
    String? url,
    Uint8List? unit8Image,
    String? imageName,
  }) {
    throw UnimplementedError('shareFacebook() has not been implemented.');
  }
}
