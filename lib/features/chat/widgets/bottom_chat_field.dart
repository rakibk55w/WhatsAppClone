import 'package:flutter/material.dart';

import '../../../common/utils/colors.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({super.key});

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  bool isShowSendButton = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            onChanged: (value){
              if (value.isNotEmpty) {
                setState(() {
                  isShowSendButton = true;
                });
              }
              else{
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
                      onPressed: () {},
                      icon: const Icon(Icons.attach_file, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {},
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
            child: Icon(
              isShowSendButton ? Icons.send : Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
