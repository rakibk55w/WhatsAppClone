import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/features/chat/widgets/display_message.dart';

import '../../../common/utils/colors.dart';

class MyMessageCard extends StatelessWidget {
  const MyMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
    required this.onSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedType,
    required this.isSeen,
  });

  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedType;
  final bool isSeen;

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;

    return SwipeTo(
      onLeftSwipe: (_) => onSwipe(),
      onRightSwipe: (_) => onSwipe(),
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: AppDeviceUtils.getScreenWidth(context) - 45,
          ),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: AppColors.messageColor,
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Stack(
              children: [
                Padding(
                  padding:
                      type == MessageEnum.text
                          ? const EdgeInsets.only(
                            left: 10,
                            right: 30,
                            top: 5,
                            bottom: 20,
                          )
                          : const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            top: 10,
                            bottom: 25,
                          ),
                  child: Column(
                    children: [
                      if (isReplying) ...[
                        Text(
                          username,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.backgroundColor.withAlpha((255 * 0.3).toInt()),
                          ),
                          child: DisplayMessage(
                            message: repliedText,
                            type: repliedType,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      DisplayMessage(message: message, type: type),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        isSeen ? Icons.done_all : Icons.done,
                        size: 20,
                        color: isSeen ? Colors.blue : Colors.white60,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
