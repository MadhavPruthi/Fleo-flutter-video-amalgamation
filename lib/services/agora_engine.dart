import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AgoraEngineService {
  static final _users = List<int>();
  String APP_ID = DotEnv().env['API_ID'];
  final StreamController streamController = new StreamController();

  void initialize(String channelName) {
    if (APP_ID.length == 0) {
      streamController.add("APP_ID missing, "
          "please provide your APP_ID in .env file which is located "
          "in top level folder");
      return;
    }

    _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    AgoraRtcEngine.enableWebSdkInteroperability(true);
    AgoraRtcEngine.setParameters(
        '{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":30,\"bitRate\":140}}');
    AgoraRtcEngine.joinChannel(null, channelName, null, 0);
    streamController.add("Welcome to the stream");
  }

  Future<void> _initAgoraRtcEngine() async {
    AgoraRtcEngine.create(APP_ID);
    AgoraRtcEngine.enableVideo();
  }

  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onError = (dynamic code) {
      String info = 'onError: ' + code.toString();
      streamController.add(info);
    };

    AgoraRtcEngine.onJoinChannelSuccess =
        (String channel, int uid, int elapsed) {
      String info = 'onJoinChannel: ' + channel + ', uid: ' + uid.toString();
      streamController.add(info);
    };

    AgoraRtcEngine.onLeaveChannel = () {
      streamController.add('onLeaveChannel');
      _users.clear();
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      String info = 'userJoined: ' + uid.toString();
      streamController.add(info);
      _users.add(uid);
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      String info = 'userOffline: ' + uid.toString();
      streamController.add(info);
      _users.remove(uid);
    };

    AgoraRtcEngine.onFirstRemoteVideoFrame =
        (int uid, int width, int height, int elapsed) {
      String info = 'firstRemoteVideo: ' +
          uid.toString() +
          ' ' +
          width.toString() +
          'x' +
          height.toString();
      streamController.add(info);
    };
  }

  List<Widget> getRenderViews() {
    List<Widget> list = [AgoraRenderWidget(0, local: true, preview: true)];
    _users.forEach((int uid) => {list.add(AgoraRenderWidget(uid))});
    return list;
  }

  void endCall() {
    _users.clear();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    streamController.close();
  }

  void onSwitchCamera() {
    AgoraRtcEngine.switchCamera();
  }

  void onToggleMute(bool muted) {
    muted = !muted;

    AgoraRtcEngine.muteLocalAudioStream(muted);
  }
}
