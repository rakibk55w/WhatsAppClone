import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/group/repository/group_repository.dart';

final groupControllerProvider = Provider(
  (ref) => GroupController(
    groupRepository: ref.watch(groupRepositoryProvider),
    ref: ref,
  ),
);

class GroupController {
  GroupController({required this.groupRepository, required this.ref});

  final GroupRepository groupRepository;
  final Ref ref;

  Future<void> createGroup(
    BuildContext context,
    String groupName,
    File? groupCoverPic,
    List<Contact> contactList,
  ) async {
    await groupRepository.createGroup(
      context,
      groupName,
      groupCoverPic,
      contactList,
    );
  }
}
