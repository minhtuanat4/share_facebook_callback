import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_facebook_callback/share_facebook_callback_method_channel.dart';

void main() {
  MethodChannelShareFacebookCallback platform = MethodChannelShareFacebookCallback();
  const MethodChannel channel = MethodChannel('share_facebook_callback');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
