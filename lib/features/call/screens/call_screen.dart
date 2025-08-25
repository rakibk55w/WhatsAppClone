import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whats_app_clone/common/widgets/loader.dart';
import 'package:whats_app_clone/config/agora_config.dart';
import 'package:whats_app_clone/features/call/controller/call_controller.dart';

import 'package:whats_app_clone/models/call_model.dart';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({
    super.key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  });

  final String channelId;
  final CallModel call;
  final bool isGroupChat;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  late RtcEngine _engine;
  bool _localUserJoined = false;
  int? _remoteUid;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            _remoteUid != null
                ? AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: _engine,
                    canvas: VideoCanvas(uid: _remoteUid),
                    connection: RtcConnection(
                      channelId: widget.channelId,
                    ),
                  ),
                )
                : const Loader(),
            Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 120,
                height: 160,
                child:
                    _localUserJoined
                        ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: _engine,
                            canvas: const VideoCanvas(uid: 0),
                          ),
                        )
                        : const Loader(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.white),
                    onPressed: () async {
                      await _engine.muteLocalAudioStream(true);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.call_end, color: Colors.red),
                    onPressed: () async {
                      await _engine.leaveChannel();
                      ref
                          .read(callControllerProvider)
                          .endCall(context, widget.call.callId);
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.videocam, color: Colors.white),
                    onPressed: () async {
                      await _engine.muteLocalVideoStream(true);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initAgora() async {
    final token = AgoraConfig.token;
    final logger = Logger();
    logger.i('Agora Token: $token');
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: AgoraConfig.appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.enableAudio();
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: widget.channelId,
      uid: 0,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );
  }
}
