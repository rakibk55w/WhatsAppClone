import 'package:flutter/material.dart';
import 'package:whats_app_clone/features/chat/widgets/display_message.dart';

import '../../../common/enums/message_enum.dart';
import '../../../common/utils/colors.dart';
import '../../../common/utils/device_utility.dart';

class SenderMessageCard extends StatelessWidget {
  const SenderMessageCard({
    super.key,
    required this.message,
    required this.date,
    required this.type,
  });

  final String message;
  final String date;
  final MessageEnum type;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: AppDeviceUtils.getScreenWidth(context) + 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: AppColors.senderMessageColor,
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
                child: DisplayMessage(message: message, type: type),
              ),
              Positioned(
                bottom: 2,
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
                    const Icon(Icons.done_all, size: 20, color: Colors.white60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
