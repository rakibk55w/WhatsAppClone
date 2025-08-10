import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/authentication/controller/authentication_controller.dart';
import 'package:whats_app_clone/features/status/repository/status_repository.dart';

import '../../../models/status_model.dart';

final statusControllerProvider = Provider(
  (ref) => StatusController(
    statusRepository: ref.read(statusRepositoryProvider),
    ref: ref,
  ),
);

class StatusController {
  StatusController({required this.statusRepository, required this.ref});

  final StatusRepository statusRepository;
  final Ref ref;

  void addStatus(BuildContext context, File file) {
    ref.watch(userDataAuthProvider).whenData((value) {
      statusRepository.uploadStatus(
        context: context,
        username: value!.name,
        profilePic: value.profilePic,
        phoneNumber: value.phoneNumber,
        statusImage: file,
      );
    });
  }

  Future<List<StatusModel>> getStatus(BuildContext context) async {
    return await statusRepository.getStatus(context);
  }
}
