import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/agora_service.dart';

class VoiceCallScreen extends StatefulWidget {
  final dynamic remoteUser;
  final String localUser;

  const VoiceCallScreen({
    Key? key,
    required this.remoteUser,
    required this.localUser,
  }) : super(key: key);

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  late AgoraService agoraService;
  bool isMuted = false;
  bool isCallActive = false;
  late Duration callDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    agoraService = AgoraService.instance;
    startCall();
  }

  Future<void> startCall() async {
    try {
      await agoraService.initialize();
      // Join channel with channelName as the remote user's UID
      await agoraService.joinChannel(
        channelName: widget.remoteUser.uid,
        token: '', // Generate token from your backend
      );
      setState(() => isCallActive = true);
    } catch (e) {
      Get.snackbar('Error', 'Failed to start call: $e');
    }
  }

  Future<void> endCall() async {
    try {
      await agoraService.leaveChannel();
      await agoraService.dispose();
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to end call: $e');
    }
  }

  Future<void> toggleMute() async {
    try {
      await agoraService.muteAudio(isMuted);
      setState(() => isMuted = !isMuted);
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle mute: $e');
    }
  }

  @override
  void dispose() {
    endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2196F3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.call_received,
              size: 80,
              color: Colors.white,
            ),
            Column(
              children: [
                Text(
                  'Calling...',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.remoteUser.name ?? 'User',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: toggleMute,
                  backgroundColor: isMuted ? Colors.red : Colors.white,
                  child: Icon(
                    isMuted ? Icons.mic_off : Icons.mic,
                    color: const Color(0xFF2196F3),
                  ),
                ),
                const SizedBox(width: 24),
                FloatingActionButton(
                  onPressed: endCall,
                  backgroundColor: Colors.red,
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}