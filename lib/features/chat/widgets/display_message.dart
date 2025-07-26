import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_clone/features/chat/widgets/video_player_item.dart';

import '../../../common/enums/message_enum.dart';

class DisplayMessage extends StatelessWidget {
  const DisplayMessage({super.key, required this.message, required this.type});

  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();
    return switch (type) {
      MessageEnum.text => Text(message, style: const TextStyle(fontSize: 16)),
      MessageEnum.image => CachedNetworkImage(
        imageUrl: message,
        height: 180,
        fit: BoxFit.contain,
      ),
      MessageEnum.audio => StatefulBuilder(
        builder: (context, setState) {
          return IconButton(
            constraints: BoxConstraints(minWidth: 400),
            onPressed: () async {
              if (isPlaying) {
                await audioPlayer.pause();
              } else {
                await audioPlayer.play(UrlSource(message));
              }
              setState(() {
                isPlaying = !isPlaying;
              });
            },
            icon:
                isPlaying ? Icon(Icons.pause_circle) : Icon(Icons.play_circle),
          );
        },
      ),
      MessageEnum.video => VideoPlayerItem(videoUrl: message),
      MessageEnum.gif => CachedNetworkImage(imageUrl: message),
    };
  }
}
