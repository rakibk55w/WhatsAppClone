import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/features/call/screens/call_screen.dart';
import 'package:whats_app_clone/models/call_model.dart';

final callRepositoryProvider = Provider<CallRepository>(
  (ref) => CallRepository(supabase: Supabase.instance.client),
);

class CallRepository {
  CallRepository({required this.supabase});

  final SupabaseClient supabase;

  Stream<List<dynamic>> callStream() {
    return supabase
        .from('call')
        .stream(primaryKey: ['callId'])
        .eq('receiverId', supabase.auth.currentUser!.id);
  }

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

      Navigator.push(context, MaterialPageRoute(builder: (context) => CallScreen(channelId: senderData.callId, call: senderData, isGroupChat: false)));
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }
}
