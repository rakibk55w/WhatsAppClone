import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/features/chat/screens/mobile_chat_screen.dart';

import '../../../models/user_model.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactsRepository(supabase: Supabase.instance.client),
);

class SelectContactsRepository {
  SelectContactsRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];

    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      final response = await supabase.from('users').select();
      bool isFound = false;

      for (var userMap in response) {
        var userData = UserModel.fromJson(userMap);
        String selectedPhoneNum = selectedContact.phones[0].number
            .replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll('+', '');

        if (selectedPhoneNum == userData.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name': userData.name,
            'uid': userData.uid,
          });
        }
      }

      if (!isFound) {
        AppDeviceUtils.showSnackBar(
          context: context,
          content: 'This contact is not on WhatsApp.',
        );
      }
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }
}
