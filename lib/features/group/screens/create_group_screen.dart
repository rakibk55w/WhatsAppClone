import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/utils/colors.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/features/group/controller/group_controller.dart';
import 'package:whats_app_clone/features/group/widgets/select_contacts_group.dart';
import 'package:whats_app_clone/info.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});

  static const String routeName = '/create-group';

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
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
            const SelectContactsGroup(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
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

  void createGroup() {
    if (textController.text.trim().isNotEmpty) {
      ref
          .read(groupControllerProvider)
          .createGroup(
            context,
            textController.text.trim(),
            image,
            ref.read(selectedGroupContacts),
          );
          ref.read(selectedGroupContacts.notifier).update((state) => []);
          Navigator.pop(context);
    }
  }
}
