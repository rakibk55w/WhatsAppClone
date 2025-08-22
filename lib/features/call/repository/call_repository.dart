import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/models/call_model.dart';

final callRepositoryProvider = Provider<CallRepository>(
  (ref) => CallRepository(supabase: Supabase.instance.client),
);

class CallRepository {
  CallRepository({required this.supabase});

  final SupabaseClient supabase;

  Future<void> createCall(
    BuildContext context,
    CallModel senderData,
    CallModel receiverData,
  ) async {
    try {
      await supabase.from('call').insert({
        'callId': senderData.callId,
        'callerId': senderData.callerId,
        'callerName': senderData.callerName,
        'callerImage': senderData.callerImage,
        'receiverId': receiverData.receiverId,
        'receiverName': receiverData.receiverName,
        'receiverImage': receiverData.receiverImage,
        'hasCalled': true,
      });
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }
}
