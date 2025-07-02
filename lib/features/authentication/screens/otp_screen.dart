import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/features/authentication/controller/authentication_controller.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;
  static const String routeName = '/otp-screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Verify your number'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text('We have sent an SMS with code.'),
            SizedBox(width: AppDeviceUtils.getScreenWidth(context) * 0.5,
            child: TextField(
              decoration: InputDecoration(
                hintText: '- - - - - -',
                hintStyle: TextStyle(fontSize: 30),
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (val){
                if(val.length == 6){
                  verifyOTP(ref, context, val.trim());
                }
              },
            ),),

          ],
        ),
      ),
    );
  }

  void verifyOTP(WidgetRef ref, BuildContext context, String userOTP){
    ref.read(authenticationControllerProvider).verifyOTP(context, phoneNumber, userOTP);
  }
}
