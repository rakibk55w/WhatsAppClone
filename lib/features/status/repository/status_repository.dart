import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/models/status_model.dart';
import 'package:whats_app_clone/models/user_model.dart';

import '../../../common/repositories/supabase_storage_repository.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(supabase: Supabase.instance.client, ref: ref),
);

class StatusRepository {
  StatusRepository({required this.supabase, required this.ref});

  final SupabaseClient supabase;
  final Ref ref;

  void uploadStatus({
    required BuildContext context,
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = supabase.auth.currentUser!.id;
      String imageUrl = await ref
          .read(commonSupabaseStorageRepositoryProvider)
          .storeFileToSupabase(
            bucket: 'status',
            path: statusId,
            file: statusImage,
          );
      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      List<String> uidWhoCanSee = [];
      for (int i = 0; i < contacts.length; i++) {
        String phoneNumber = contacts[i].phones[0].number
            .replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll('+', '');
        var userDataSupabase =
            await supabase
                .from('users')
                .select()
                .eq('phoneNumber', phoneNumber)
                .single();
        var userData = UserModel.fromJson(userDataSupabase);
        uidWhoCanSee.add(userData.uid);
      }

      List<String> statusImageUrls = [];
      var statusSnapshot = await supabase
          .from('status')
          .select()
          .eq('uid', uid)
          .maybeSingle()
          .limit(1);

      if (statusSnapshot != null) {
        StatusModel status = StatusModel.fromJson(statusSnapshot);
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imageUrl);
        await supabase
            .from('status')
            .update({'photoUrl': statusImageUrls})
            .eq('uid', uid);
        return;
      } else {
        statusImageUrls = [imageUrl];
      }

      StatusModel status = StatusModel(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusImageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusId,
        whoCanSee: uidWhoCanSee,
      );

      await supabase.from('status').insert(status.toJson());
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    List<StatusModel> statusList = [];
    try {
      String cutoffTimeStamp =
          DateTime.now().subtract(const Duration(hours: 24)).toIso8601String();
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        String phoneNumber = contacts[i].phones[0].number
            .replaceAll(' ', '')
            .replaceAll('-', '')
            .replaceAll('+', '');
        var statusData = await supabase
            .from('status')
            .select()
            .eq('phoneNumber', phoneNumber)
            .gt('createdAt', cutoffTimeStamp);

        for (var tempData in statusData) {
          StatusModel tempStatus = StatusModel.fromJson(tempData);
          if (tempStatus.whoCanSee.contains(supabase.auth.currentUser!.id)) {
            statusList.add(tempStatus);
          }
        }
      }
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
    return statusList;
  }
}
