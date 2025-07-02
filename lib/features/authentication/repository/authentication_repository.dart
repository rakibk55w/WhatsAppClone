import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/features/authentication/screens/otp_screen.dart';

import '../screens/user_information_screen.dart';

final authenticationRepositoryProvider = Provider((ref) => AuthenticationRepository(supabase: Supabase.instance.client));

class AuthenticationRepository {
  final SupabaseClient supabase;

  AuthenticationRepository({required this.supabase});

  /// Send OTP to user's phone
  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await supabase.auth.signInWithOtp(
        phone: phoneNumber,
      );
      AppDeviceUtils.showSnackBar(context: context, content: 'OTP sent to $phoneNumber');

      Navigator.pushNamed(context, OtpScreen.routeName, arguments: phoneNumber);
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: 'OTP sending failed: $e');
    }
  }

  /// Verify the OTP code entered by user
  Future<void> verifyOTP(
      BuildContext context, String phoneNumber, String token) async {
    try {
      final res = await supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: token,
        type: OtpType.sms,
      );
      if (res.session != null) {
        AppDeviceUtils.showSnackBar(context: context, content: 'OTP verified successfully');
      }
      Navigator.pushNamedAndRemoveUntil(context, UserInformationScreen.routeName, (route) => false);
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: 'OTP verification failed: $e');
    }
  }
}
