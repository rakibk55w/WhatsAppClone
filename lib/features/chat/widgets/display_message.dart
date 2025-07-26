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
    return switch(type){
      MessageEnum.text => Text(message, style: const TextStyle(fontSize: 16)),
      MessageEnum.image => CachedNetworkImage(imageUrl: message, height: 180, fit: BoxFit.contain,),
      // TODO: Handle this case.
      MessageEnum.audio => throw UnimplementedError(),
      MessageEnum.video => VideoPlayerItem(videoUrl: message),
      MessageEnum.gif => CachedNetworkImage(imageUrl: message),
    };
  }
}
