import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_clone/common/repositories/supabase_storage_repository.dart';
import 'package:whats_app_clone/common/utils/device_utility.dart';
import 'package:whats_app_clone/features/authentication/screens/otp_screen.dart';
import 'package:whats_app_clone/responsive/screens/mobile_screen_layout.dart';

import '../../../info.dart';
import '../../../models/user_model.dart';
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

  void saveUserDataToSupabase({required String name, required File? profilePic, required Ref ref, required BuildContext context}) async{
    try{
      String uid = supabase.auth.currentUser!.id;
      String? imageUrl = info[0]['profilePic'].toString();

      if(profilePic != null){
        imageUrl = await ref.read(commonSupabaseStorageRepositoryProvider).storeFileToSupabase(bucket: 'profile-pic', path: 'profilePic/$uid', file: profilePic);
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: imageUrl,
        isOnline: true,
        phoneNumber: supabase.auth.currentUser!.id,
        groupId: [],
      );

      await supabase.from('users').upsert(user.toJson());

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MobileScreenLayout()), (route) => false);
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }
}
