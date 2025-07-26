import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:whats_app_clone/common/widgets/loader.dart';

class VideoPlayerItem extends StatefulWidget {
  const VideoPlayerItem({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<VideoPlayerItem> createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late final CachedVideoPlayerPlus player;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    player = CachedVideoPlayerPlus.networkUrl(
      Uri.parse(widget.videoUrl),
    );
    player.initialize().then((onValue) {
      setState(() {});
      player.controller.setVolume(1.0);
    });
  }

  @override
  void dispose() {
    //player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child:
          player.isInitialized
              ? Stack(
                children: [
                  VideoPlayer(player.controller),
                  Align(
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: () {
                        if (isPlaying) {
                          player.controller.pause();
                        } else {
                          player.controller.play();
                        }
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                      },
                      icon:
                          isPlaying
                              ? const Icon(Icons.pause_circle)
                              : const Icon(Icons.play_circle),
                    ),
                  ),
                ],
              )
              : const Loader(),
    );
  }
}
