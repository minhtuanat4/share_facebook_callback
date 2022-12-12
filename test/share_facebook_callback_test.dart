import 'package:flutter_test/flutter_test.dart';
import 'package:share_facebook_callback/share_facebook_callback.dart';
import 'package:share_facebook_callback/share_facebook_callback_platform_interface.dart';
import 'package:share_facebook_callback/share_facebook_callback_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockShareFacebookCallbackPlatform
    with MockPlatformInterfaceMixin
    implements ShareFacebookCallbackPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> shareFacebook(
      {required String type,
      String? quote,
      String? url,
      String? imageUrl,
      String? imageName}) {
    throw UnimplementedError();
  }
}

void main() {
  final ShareFacebookCallbackPlatform initialPlatform =
      ShareFacebookCallbackPlatform.instance;

  test('$MethodChannelShareFacebookCallback is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelShareFacebookCallback>());
  });

  test('getPlatformVersion', () async {
    ShareFacebookCallback shareFacebookCallbackPlugin = ShareFacebookCallback();
    MockShareFacebookCallbackPlatform fakePlatform =
        MockShareFacebookCallbackPlatform();
    ShareFacebookCallbackPlatform.instance = fakePlatform;

    expect(await shareFacebookCallbackPlugin.getPlatformVersion(), '42');
  });
}
