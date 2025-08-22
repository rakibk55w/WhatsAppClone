import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whats_app_clone/common/widgets/loader.dart';
import 'package:whats_app_clone/features/chat/controller/chat_controller.dart';
import 'package:whats_app_clone/features/chat/screens/mobile_chat_screen.dart';
import 'package:whats_app_clone/models/chat_contact_model.dart';
import 'package:whats_app_clone/models/group_model.dart';

import '../../../common/utils/colors.dart';

class ContactsList extends ConsumerWidget {
  const ContactsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<GroupModel>>(
              stream: ref.watch(chatControllerProvider).getChatGroups(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                if (asyncSnapshot.hasError) {
                  return Center(child: Text('Error: ${asyncSnapshot.error}'));
                }

                if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
                  return const Center(child: Text('No data found'));
                }
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: asyncSnapshot.data!.length,
                  itemBuilder: (context, index) {
                    var groupData = asyncSnapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              MobileChatScreen.routeName,
                              arguments: {
                                'name': groupData.groupName,
                                'uid': groupData.groupId,
                                'isGroupChat': true,
                                'profilePic': groupData.groupCoverPic,
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                groupData.groupName,
                                style: const TextStyle(fontSize: 18),
                              ),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  groupData.groupCoverPic,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  groupData.lastMessage,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              trailing: Text(
                                DateFormat.Hm().format(
                                  groupData.timeSent,
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: AppColors.dividerColor,
                          indent: 85,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            StreamBuilder<List<ChatContactModel>>(
              stream: ref.watch(chatControllerProvider).getChatContacts(),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                }
                if (asyncSnapshot.hasError) {
                  return Center(child: Text('Error: ${asyncSnapshot.error}'));
                }

                if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
                  return const Center(child: Text('No data found'));
                }
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: asyncSnapshot.data!.length,
                  itemBuilder: (context, index) {
                    var chatContactData = asyncSnapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              MobileChatScreen.routeName,
                              arguments: {
                                'name': chatContactData.name,
                                'uid': chatContactData.contactId,
                                'isGroupChat': false,
                                'profilePic': chatContactData.profilePic,
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                chatContactData.name,
                                style: const TextStyle(fontSize: 18),
                              ),
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  chatContactData.profilePic,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  chatContactData.lastMessage,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                              trailing: Text(
                                DateFormat.Hm().format(
                                  chatContactData.timeSent,
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.greyColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: AppColors.dividerColor,
                          indent: 85,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
