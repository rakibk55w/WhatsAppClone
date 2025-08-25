import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:whats_app_clone/features/call/controller/call_controller.dart';
import 'package:whats_app_clone/features/call/screens/call_screen.dart';
import 'package:whats_app_clone/models/call_model.dart';

class CallPickupScreen extends ConsumerWidget {
  const CallPickupScreen({super.key, required this.scaffold});

  final Widget scaffold;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Logger logger = Logger();
    final SupabaseClient supabase = Supabase.instance.client;
    return StreamBuilder(
      stream: ref.watch(callControllerProvider).callStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          logger.i('Async Snapshot Data: $snapshot');
          final call = snapshot.data!.first;
          CallModel callData = CallModel.fromMap(call as Map<String, dynamic>);

          logger.i('Converted call: $call');
          logger.i('Call Data: $callData');

          if (callData.receiverId == supabase.auth.currentUser!.id &&
              callData.callOngoing == true) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 50),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          callData.callerImage.isNotEmpty
                              ? NetworkImage(callData.callerImage)
                              : const AssetImage(
                                    'assets/images/profile_default.png',
                                  )
                                  as ImageProvider,
                    ),
                    const SizedBox(height: 50),
                    Text(
                      callData.callerName,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 75),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            ref
                                .read(callControllerProvider)
                                .endCall(context, callData.callId);
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.call_end,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(width: 25),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => CallScreen(
                                      channelId: callData.callId,
                                      call: callData,
                                      isGroupChat: false,
                                    ),
                              ),
                            );
                          },
                          icon: Icon(Icons.call, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
