import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/widgets/error.dart';
import 'package:whats_app_clone/common/widgets/loader.dart';
import 'package:whats_app_clone/features/select_contacts/controller/select_contacts_controller.dart';

class SelectContactsScreen extends ConsumerWidget {
  const SelectContactsScreen({super.key});

  static const String routeName = '/select-contact';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select contact'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: ref
          .watch(getContactsProvider)
          .when(
            data:
                (contactList) => ListView.builder(
                  itemCount: contactList.length,
                  itemBuilder:
                      (context, index) => InkWell(
                        onTap: () => selectContact(ref, contactList[index], context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(contactList[index].displayName, style: TextStyle(fontSize: 18),),
                            leading:
                                contactList[index].photo == null
                                    ? CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/profile_default.png',
                                      ),
                                      radius: 30,
                                    )
                                    : CircleAvatar(
                                      backgroundImage: MemoryImage(
                                        contactList[index].photo!,
                                      ),
                                      radius: 30,
                                    ),
                          ),
                        ),
                      ),
                ),
            error: (err, stack) => ErrorScreen(error: err.toString()),
            loading: () => const Loader(),
          ),
    );
  }

  void selectContact(WidgetRef ref, Contact selectedContact, BuildContext context){
    ref.read(selectContactControllerProvider).selectContact(selectedContact, context);
  }
}
