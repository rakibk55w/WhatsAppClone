import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../common/enums/message_enum.dart';

class DisplayMessage extends StatelessWidget {
  const DisplayMessage({super.key, required this.message, required this.type});

  final String message;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    return type == MessageEnum.text
        ? Text(message, style: const TextStyle(fontSize: 16))
        : CachedNetworkImage(imageUrl: message, height: 200, width: 200, fit: BoxFit.cover,);
  }
}
