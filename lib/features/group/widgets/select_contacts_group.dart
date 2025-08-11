import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/widgets/error.dart';
import 'package:whats_app_clone/common/widgets/loader.dart';
import 'package:whats_app_clone/features/select_contacts/controller/select_contacts_controller.dart';

final selectedGroupContacts = StateProvider<List<Contact>>((ref) => []);

class SelectContactsGroup extends ConsumerStatefulWidget {
  const SelectContactsGroup({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectContactsGroupState();
}

class _SelectContactsGroupState extends ConsumerState<SelectContactsGroup> {
  List<int> selectedContactsIndex = [];

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(getContactsProvider)
        .when(
          data: (contactList) {
            return Expanded(
              child: ListView.builder(
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => selectContact(index, contactList[index]),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          contactList[index].displayName,
                          style: TextStyle(fontSize: 18),
                        ),
                        leading:
                            selectedContactsIndex.contains(index)
                                ? IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.done),
                                )
                                : null,
                      ),
                    ),
                  );
                },
              ),
            );
          },
          error: (err, stackTrace) => ErrorScreen(error: err.toString()),
          loading: () => const Loader(),
        );
  }

  void selectContact(int index, Contact contact) {
    if (selectedContactsIndex.contains(index)) {
      selectedContactsIndex.removeAt(index);
    } else {
      selectedContactsIndex.add(index);
    }
    setState(() {});
    ref
        .read(selectedGroupContacts.notifier)
        .update((state) => [...state, contact]);
  }
}
