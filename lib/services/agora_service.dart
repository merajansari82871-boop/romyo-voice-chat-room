import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class AgoraService {
  static final AgoraService instance = AgoraService._();

  AgoraService._();

  late RtcEngine agoraEngine;
  String agoraAppId = 'YOUR_AGORA_APP_ID'; // Replace with your Agora App ID
  bool isJoined = false;
  int uid = 0;

  Future<void> initialize() async {
    await requestPermissions();

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(
      appId: agoraAppId,
    ));

    // Set channel event handlers
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('Local user uid:${connection.localUid} joined the channel');
          isJoined = true;
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('Remote user uid:$remoteUid joined the channel');
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print('Remote user uid:$remoteUid left the channel');
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          print('Local user left the channel');
          isJoined = false;
        },
        onError: (ErrorCodeType code) {
          print('Agora Engine Error: $code');
        },
      ),
    );

    await agoraEngine.enableAudio();
  }

  Future<void> requestPermissions() async {
    final permission = await [Permission.microphone, Permission.camera]
        .request();

    if (permission.isGranted) {
      print('Permissions granted');
    } else {
      print('Permissions denied');
    }
  }

  Future<void> joinChannel(
      {required String channelName, required String token}) async {
    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const RtcChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: false,
        publishMicrophoneTrack: true,
      ),
    );
  }

  Future<void> leaveChannel() async {
    await agoraEngine.leaveChannel();
  }

  Future<void> muteAudio(bool muted) async {
    await agoraEngine.muteLocalAudioStream(muted);
  }

  Future<void> dispose() async {
    await agoraEngine.leaveChannel();
    await agoraEngine.release();
  }
}