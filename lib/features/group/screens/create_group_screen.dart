import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/info.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  static const String routeName = '/create-group';

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  File? image;
  final TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Group'), centerTitle: true),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Stack(
              children: [
                image == null
                    ? CircleAvatar(
                      radius: 64,
                      backgroundImage: NetworkImage(
                        info[0]['profilePic'].toString(),
                      ),
                    )
                    : CircleAvatar(
                      radius: 64,
                      backgroundImage: FileImage(image!),
                    ),
                Positioned(
                  left: 80,
                  bottom: -10,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(hintText: 'Enter Group Name'),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Selece Contacts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.tabColor,
        shape: CircleBorder(),

        child: const Icon(Icons.done, color: Colors.white),
      ),
    );
  }

  Future<void> selectImage() async {
    image = await AppDeviceUtils.pickImageFromGallery(context);
    setState(() {});
  }
}
