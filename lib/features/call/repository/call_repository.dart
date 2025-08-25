import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
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
    final logger = Logger();
    // final initial = await supabase
    //   .from('call')
    //   .select()
    //   .eq('callOngoing', true);
    // yield initial;

    // final realtimeStream = supabaseP
    //   .from('call')
    //   .stream(primaryKey: ['callId'])
    //   .eq('callOngoing', true);

    // yield* realtimeStream;

    final userId = supabase.auth.currentUser!.id;
    final realtimeStream = supabase
        .from('call')
        .stream(primaryKey: ['callId'])
        .eq('callOngoing', true)
        .order('callTime', ascending: true)
        .map((rows) {
          return rows.where((r) => r['receiverId'] == userId).toList();
        });

    logger.i('Call Stream Result: $realtimeStream');
    return realtimeStream;
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
        'callOngoing': senderData.callOngoing,
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => CallScreen(
                channelId: senderData.callId,
                call: senderData,
                isGroupChat: false,
              ),
        ),
      );
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }

  Future<void> endCall(BuildContext context, String callId) async {
    try {
      await supabase
          .from('call')
          .update({'callOngoing': false})
          .eq('callId', callId);
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }
}
