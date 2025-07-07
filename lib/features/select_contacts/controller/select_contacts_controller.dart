import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/select_contacts/repository/select_contacts_repository.dart';

final getContactsProvider = FutureProvider(
  (ref) => ref.watch(selectContactsRepositoryProvider).getContacts(),
);

final selectContactControllerProvider = Provider(
  (ref) => SelectContactsController(
    ref: ref,
    selectContactsRepository: ref.watch(selectContactsRepositoryProvider),
  ),
);

class SelectContactsController {
  SelectContactsController({
    required this.ref,
    required this.selectContactsRepository,
  });

  final Ref ref;
  final SelectContactsRepository selectContactsRepository;

  void selectContact(Contact selectedContact, BuildContext context) {
    selectContactsRepository.selectContact(selectedContact, context);
  }
}
