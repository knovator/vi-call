import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class KnoviCall extends StatefulWidget {
  final String apiKey;
  final String sessionId;
  final String token;

  const KnoviCall({
    Key key,
    this.apiKey,
    this.sessionId,
    this.token,
  }) : super(key: key);

  @override
  _KnoviCallState createState() => _KnoviCallState();
}

class _KnoviCallState extends State<KnoviCall> {
  static const platformMethodChannel = MethodChannel('com.example.knovi_call');

  SdkState _sdkState = SdkState.WAIT;

  bool _publishAudio = true;
  bool _publishVideo = true;

  Future<dynamic> methodCallHandler(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'updateState':
        {
          var arguments = 'SdkState.${methodCall.arguments}';
          _sdkState = SdkState.values.firstWhere((v) {
            return v.toString() == arguments;
          });
          if (_sdkState == SdkState.LOGGED_OUT || _sdkState == SdkState.ERROR) {
            Navigator.of(context).pop();
          }
          setState(() {});
        }
        break;
      default:
        throw MissingPluginException('notImplemented');
    }
  }

  Future<void> _initSession() async {
    await requestPermissions();

    dynamic params = {
      'apiKey': widget.apiKey,
      'sessionId': widget.sessionId,
      'token': widget.token
    };

    try {
      await platformMethodChannel.invokeMethod('initSession', params);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  Future<void> _swapCamera() async {
    try {
      await platformMethodChannel.invokeMethod('swapCamera');
    } on PlatformException catch (e) {}
  }

  Future<void> _toggleAudio() async {
    _publishAudio = !_publishAudio;

    dynamic params = {'publishAudio': _publishAudio};

    try {
      await platformMethodChannel.invokeMethod('toggleAudio', params);
    } on PlatformException catch (e) {}
  }

  Future<void> _toggleVideo() async {
    _publishVideo = !_publishVideo;
    setState(() {});
    dynamic params = {'publishVideo': _publishVideo};

    try {
      await platformMethodChannel.invokeMethod('toggleVideo', params);
    } on PlatformException catch (e) {}
  }

  Future<void> _cancelSession() async {
    try {
      await platformMethodChannel.invokeMethod('cancelSession');
    } on PlatformException catch (e) {}
  }

  @override
  void initState() {
    _initSession();
    platformMethodChannel.setMethodCallHandler(methodCallHandler);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        await _cancelSession().then((value) => () {
              Navigator.of(context).pop();
            });
        return true;
      },
      child: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: videoCallWidget(),
      ),
    );
  }

  Widget videoCallWidget() {
    if (_sdkState == SdkState.WAIT) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_sdkState == SdkState.LOGGED_IN) {
      return callingWidget();
    } else if (_sdkState == SdkState.ON_CALL) {
      return callWidget();
    } else {
      return Container();
    }
  }

  Widget callingWidget() {
    return Stack(
      children: [
        callWidget(),
        const Positioned(
          top: 100.0,
          child: Text(
            "Connecting",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 5.0,
            ),
          ),
        ),
      ],
      alignment: Alignment.center,
    );
  }

  Widget callWidget() {
    return Stack(
      alignment: Alignment.center,
      children: [
        videoContainerWidget(),
        callFunctionButtons(),
      ],
    );
  }

  Widget videoContainerWidget() {
    if (Platform.isAndroid) {
      return const AndroidView(
        viewType: 'video-container',
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
        creationParams: {},
        creationParamsCodec: StandardMessageCodec(),
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        layoutDirection: TextDirection.ltr,
      );
    } else {
      return const UiKitView(
        viewType: 'video-container',
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{},
        creationParams: {},
        creationParamsCodec: StandardMessageCodec(),
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
        layoutDirection: TextDirection.ltr,
      );
    }
  }

  Widget callFunctionButtons() {
    return Positioned(
      bottom: 50.0,
      child: Row(
        children: [
          VideoCallButtons(
            onPress: () async {
              await _toggleAudio();
              setState(() {});
            },
            icon: _publishAudio
                ? Icons.mic_off_outlined
                : Icons.mic_none_outlined,
            isCancelCall: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: VideoCallButtons(
              onPress: () async {
                await _cancelSession();
              },
              icon: Icons.call_end_outlined,
              isCancelCall: true,
            ),
          ),
          VideoCallButtons(
            onPress: () async {
              await _swapCamera();
              setState(() {});
            },
            icon: getCameraSwitchWidget(),
            isCancelCall: false,
          ),
        ],
      ),
    );
  }

  IconData getCameraSwitchWidget() {
    if (Platform.isAndroid) {
      return Icons.flip_camera_android_outlined;
    } else {
      return Icons.flip_camera_ios_outlined;
    }
  }
}

class VideoCallButtons extends StatelessWidget {
  final VoidCallback onPress;
  final IconData icon;
  final bool isCancelCall;

  const VideoCallButtons({
    Key key,
    this.onPress,
    this.icon,
    this.isCancelCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isCancelCall
          ? MediaQuery.of(context).size.height * 0.1
          : MediaQuery.of(context).size.height * 0.08,
      width: isCancelCall
          ? MediaQuery.of(context).size.height * 0.1
          : MediaQuery.of(context).size.height * 0.08,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: onPress,
          backgroundColor: !isCancelCall ? Colors.white : Colors.red,
          child: Icon(
            icon,
            color: !isCancelCall ? Colors.black45 : Colors.white,
          ),
        ),
      ),
    );
  }
}

enum SdkState {
  LOGGED_OUT,
  LOGGED_IN,
  WAIT,
  ON_CALL,
  ERROR,
}
