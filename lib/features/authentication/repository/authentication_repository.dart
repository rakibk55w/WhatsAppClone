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
import '../screens/login_screen.dart';
import '../screens/user_information_screen.dart';

final authenticationRepositoryProvider = Provider(
  (ref) => AuthenticationRepository(supabase: Supabase.instance.client),
);

class AuthenticationRepository {
  final SupabaseClient supabase;

  AuthenticationRepository({required this.supabase});

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user;
    final uid = supabase.auth.currentUser?.id;

    if (uid == null) {
      return user;
    }

    var userData =
        await supabase.from('users').select().eq('uid', uid).single();
    user = UserModel.fromJson(userData);

    return user;
  }

  /// Send OTP to user's phone
  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await supabase.auth.signInWithOtp(phone: phoneNumber);
      AppDeviceUtils.showSnackBar(
        context: context,
        content: 'OTP sent to $phoneNumber',
      );

      Navigator.pushNamed(context, OtpScreen.routeName, arguments: phoneNumber);
    } catch (e) {
      AppDeviceUtils.showSnackBar(
        context: context,
        content: 'OTP sending failed: $e',
      );
    }
  }

  /// Verify the OTP code entered by user
  Future<void> verifyOTP(
    BuildContext context,
    String phoneNumber,
    String token,
  ) async {
    try {
      final res = await supabase.auth.verifyOTP(
        phone: phoneNumber,
        token: token,
        type: OtpType.sms,
      );
      if (res.session != null) {
        AppDeviceUtils.showSnackBar(
          context: context,
          content: 'OTP verified successfully',
        );
      }
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      AppDeviceUtils.showSnackBar(
        context: context,
        content: 'OTP verification failed: $e',
      );
    }
  }

  /// Logout user
  Future<void> logout(BuildContext context) async {
    try {
      await supabase.auth.signOut();
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginScreen.routeName,
        (route) => false,
      );
    } catch (e) {
      AppDeviceUtils.showSnackBar(
        context: context,
        content: 'Logout failed: $e',
      );
    }
  }

  /// Store user data to supabase
  void saveUserDataToSupabase({
    required String name,
    required File? profilePic,
    required Ref ref,
    required BuildContext context,
  }) async {
    try {
      String uid = supabase.auth.currentUser!.id;
      String? imageUrl = info[0]['profilePic'].toString();

      if (profilePic != null) {
        imageUrl = await ref
            .read(commonSupabaseStorageRepositoryProvider)
            .storeFileToSupabase(
              bucket: 'profile-pic',
              path: '$uid/profile.jpg',
              file: profilePic,
            );
      }

      var user = UserModel(
        name: name,
        uid: uid,
        profilePic: imageUrl,
        isOnline: true,
        phoneNumber: supabase.auth.currentUser!.phone!,
        groupId: [],
      );

      await supabase.from('users').upsert(user.toJson());

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MobileScreenLayout()),
        (route) => false,
      );
    } catch (e) {
      AppDeviceUtils.showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<UserModel> userData(String userId) {
    return supabase
        .from('users')
        .stream(primaryKey: ['uid'])
        .eq('uid', userId)
        .map((event) => UserModel.fromJson(event.first));
  }

  Future<void> setUserState(bool isOnline) async {
    await supabase
        .from('users')
        .update({'isOnline': isOnline})
        .eq('uid', supabase.auth.currentUser!.id);
  }
}
