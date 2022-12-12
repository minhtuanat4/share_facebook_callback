import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:share_facebook_callback/share_facebook_callback.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _shareFacebookCallbackPlugin = ShareFacebookCallback();

  String _platformVersion = 'Unknown';
  String _shareFaceStatus = 'Unknow status';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _shareFacebookCallbackPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> shareFacebook(String url, String msg) async {
    String shareFaceStatus;
    try {
      shareFaceStatus = await _shareFacebookCallbackPlugin.shareFacebook(
              type: ShareType.shareLinksFacebook,
              url: 'https://vtcpay.vn/',
              quote: 'Happy new year',
              imageUrl: 'example/assets/images/image001.jpeg') ??
          'Unknow sharing Facebook Status';
    } catch (e) {
      shareFaceStatus = 'Failed to call shareFacebook';
    }
    if (!mounted) return;
    setState(() {
      _shareFaceStatus = shareFaceStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ShareFacebook CallBack'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  shareFacebook('https://pub.dev/', 'Flutter');
                },
                style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                child: const Text('Share Facebook'),
              ),
              const SizedBox(
                height: 30,
              ),
              Text('ShareFacebook Status: $_shareFaceStatus\n'),
              Text('Platform Version: $_platformVersion\n'),
            ],
          ),
        ),
      ),
    );
  }
}
