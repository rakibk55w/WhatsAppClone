import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/enums/message_enum.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/features/chat/controller/chat_controller.dart';

import '../../../common/utils/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  const BottomChatField({super.key, required this.receiverId});

  final String receiverId;

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() async {
    if (isShowSendButton) {
      ref
          .read(chatControllerProvider)
          .sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverId,
          );
      setState(() {
        _messageController.text = '';
      });
    }
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(context, file, widget.receiverId, messageEnum);
  }

  Future<void> selectImage() async{
    File? image = await AppDeviceUtils.pickImageFromGallery(context);
    if(image != null){
      sendFileMessage(image, MessageEnum.image);
    }
  }

  Future<void> selectVideo() async{
    File? video = await AppDeviceUtils.pickVideoFromGallery(context);
    if(video != null){
      sendFileMessage(video, MessageEnum.video);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _messageController,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              } else {
                isShowSendButton = false;
              }
            },
            decoration: InputDecoration(
              fillColor: AppColors.mobileChatBoxColor,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.gif, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: selectVideo,
                      icon: const Icon(Icons.attach_file, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.camera_alt, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              hintText: 'Type a messsage',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(width: 0, style: BorderStyle.none),
              ),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 2, right: 2),
          child: CircleAvatar(
            backgroundColor: AppColors.sendButtonColor,
            radius: 25,
            child: GestureDetector(
              onTap: sendTextMessage,
              child: Icon(
                isShowSendButton ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
