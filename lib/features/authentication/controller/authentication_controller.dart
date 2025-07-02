import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/authentication/repository/authentication_repository.dart';
import 'package:flutter/material.dart';

final authenticationControllerProvider = Provider((ref) => AuthenticationController(authRepo: ref.watch(authenticationRepositoryProvider)));

class AuthenticationController{
  AuthenticationController({required this.authRepo});

  final AuthenticationRepository authRepo;

  void signInWithPhone(BuildContext context, String phoneNumber){
    authRepo.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP(BuildContext context, String phoneNumber, String userOTP){
    authRepo.verifyOTP(context, phoneNumber, userOTP);
  }
}