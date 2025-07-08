import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/authentication/repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:whats_app_clone/models/user_model.dart';

final authenticationControllerProvider = Provider(
  (ref) => AuthenticationController(
    authRepo: ref.watch(authenticationRepositoryProvider),
    ref: ref,
  ),
);
final userDataAuthProvider = FutureProvider(
  (ref) => ref.watch(authenticationControllerProvider).getUserData(),
);

class AuthenticationController {
  AuthenticationController({required this.authRepo, required this.ref});

  final AuthenticationRepository authRepo;
  final Ref ref;

  Future<UserModel?> getUserData() async {
    return await authRepo.getCurrentUserData();
  }

  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepo.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String phoneNumber, String userOTP) {
    authRepo.verifyOTP(context, phoneNumber, userOTP);
  }

  void logout(BuildContext context) {
    authRepo.logout(context);
  }

  void saveUserDataToSupabase(
    BuildContext context,
    String name,
    File? profilePic,
  ) {
    authRepo.saveUserDataToSupabase(
      name: name,
      profilePic: profilePic,
      ref: ref,
      context: context,
    );
  }

  Stream<UserModel> userData(String userId) {
    return authRepo.userData(userId);
  }
}
