import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/info.dart';

import '../controller/authentication_controller.dart';

class UserInformationScreen extends ConsumerStatefulWidget {
  const UserInformationScreen({super.key});

  static const String routeName = '/user-information';

  @override
  ConsumerState<UserInformationScreen> createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends ConsumerState<UserInformationScreen> {
  final TextEditingController nameController = TextEditingController();
  File? image;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
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
              Row(
                children: [
                  Container(
                    width: AppDeviceUtils.getScreenWidth(context) * 0.85,
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: 'Enter your name'),
                    ),
                  ),
                  IconButton(onPressed: storeUserData, icon: Icon(Icons.done)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectImage() async {
    image = await AppDeviceUtils().pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async{
    String name = nameController.text.trim();

    if (name.isNotEmpty) {
        ref.read(authenticationControllerProvider).saveUserDataToSupabase(context, name, image);
    }
  }
}
