import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:whats_app_clone/features/authentication/controller/authentication_controller.dart';
import 'package:whats_app_clone/features/call/repository/call_repository.dart';
import 'package:whats_app_clone/models/call_model.dart';

final callControllerProvider = Provider(
  (ref) => CallController(
    callRepository: ref.read(callRepositoryProvider),
    ref: ref,
    supabase: Supabase.instance.client,
  ),
);

class CallController {
  CallController({
    required this.callRepository,
    required this.ref,
    required this.supabase,
  });

  final CallRepository callRepository;
  final Ref ref;
  final SupabaseClient supabase;

  void createCall(
    BuildContext context,
    String receiverId,
    String receiverName,
    String receiverImage,
    bool isGroupCall,
  ) {
    ref.watch(userDataAuthProvider).whenData((value) {
      String callId = const Uuid().v1();
      CallModel senderData = CallModel(
        callId: callId,
        callerId: supabase.auth.currentUser!.id,
        callerName: value!.name,
        callerImage: value.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverImage: receiverImage,
        hasCalled: true,
      );

      CallModel receiverData = CallModel(
        callId: callId,
        callerId: supabase.auth.currentUser!.id,
        callerName: value.name,
        callerImage: value.profilePic,
        receiverId: receiverId,
        receiverName: receiverName,
        receiverImage: receiverImage,
        hasCalled: false,
      );

      callRepository.createCall(context, senderData, receiverData);
    });
  }

  Stream<List<dynamic>> callStream() {
    return callRepository.callStream();
  }
}
