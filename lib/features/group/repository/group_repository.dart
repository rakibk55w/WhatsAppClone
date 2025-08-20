import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app_clone/common/repositories/supabase_storage_repository.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/models/group_model.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(supabase: Supabase.instance.client, ref: ref),
);

class GroupRepository {
  GroupRepository({required this.supabase, required this.ref});

  final SupabaseClient supabase;
  final Ref ref;

  Future<void> createGroup(
    BuildContext context,
    String groupName,
    File? groupCoverPic,
    List<Contact> contactList,
  ) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < contactList.length; i++) {
        String phoneNumber = contactList[i].phones[0].number
            .replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll('+', '');
        var userData = await supabase
            .from('users')
            .select()
            .eq('phoneNumber', phoneNumber);

        if (userData.isNotEmpty) {
          uids.add(userData[0]['uid']);
        }
      }

      var groupId = const Uuid().v1();

      String groupCoverPicUrl = await ref
          .read(commonSupabaseStorageRepositoryProvider)
          .storeFileToSupabase(
            bucket: 'group-pic',
            path: groupId,
            file: groupCoverPic!,
          );

      GroupModel group = GroupModel(
        groupName: groupName,
        groupId: groupId,
        groupCoverPic: groupCoverPicUrl,
        members: [supabase.auth.currentUser!.id, ...uids],
        lastSenderId: supabase.auth.currentUser!.id,
        lastMessage: 'New group created',
        timeSent: DateTime.now(),
      );

      await supabase.from('group').insert(group.toJson());
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }
}
