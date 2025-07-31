import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/status/controller/status_controller.dart';

import '../../../common/utils/colors.dart';

class ConfirmStatusScreen extends ConsumerWidget {
  const ConfirmStatusScreen({super.key, required this.file});

  static const String routeName = '/confirm-status-screen';
  final File file;

  void addStatus(BuildContext context, WidgetRef ref) {
    ref.read(statusControllerProvider).addStatus(context, file);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: AspectRatio(aspectRatio: 16 / 9, child: Image.file(file)),
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () => addStatus(context, ref),
        backgroundColor: AppColors.tabColor,
        child: const Icon(Icons.done, color: Colors.white),
      ),
    );
  }
}
