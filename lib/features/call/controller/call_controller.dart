import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whats_app_clone/features/call/repository/call_repository.dart';

final callControllerProvider = Provider(
  (ref) => CallController(
    callRepository: ref.watch(callRepositoryProvider),
    ref: ref,
  ),
);

class CallController {
  CallController({required this.callRepository, required this.ref});

  final CallRepository callRepository;
  final Ref ref;
}
