import 'dart:typed_data';

import 'share_facebook_callback_platform_interface.dart';

enum ShareType { shareLinksFacebook, sharePhotoFacebook, more }

class ShareFacebookCallback {
  Future<String?> getPlatformVersion() {
    return ShareFacebookCallbackPlatform.instance.getPlatformVersion();
  }

  Future<String?> shareFacebook(
      {required ShareType type,
      String? quote,
      String? url,
      Uint8List? unit8Image,
      String? imageName}) {
    return ShareFacebookCallbackPlatform.instance.shareFacebook(
      type: type.toString(),
      quote: quote,
      url: url,
      unit8Image: unit8Image,
      imageName: imageName,
    );
  }
}
