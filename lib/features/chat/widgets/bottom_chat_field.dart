import 'package:flutter/material.dart';

import '../../../common/utils/colors.dart';

class BottomChatField extends StatelessWidget {
  const BottomChatField({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              fillColor: AppColors.mobileChatBoxColor,
              filled: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(onPressed: (){}, icon: const Icon(Icons.emoji_emotions, color: Colors.grey)),
                      IconButton(onPressed: (){}, icon: const Icon(Icons.gif, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){}, icon: const Icon(Icons.attach_file, color: Colors.grey)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.camera_alt, color: Colors.grey)),
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
            radius: 25
            , child: Icon(Icons.send, color: Colors.white,),
          ),
        )
      ],
    );
  }
}
