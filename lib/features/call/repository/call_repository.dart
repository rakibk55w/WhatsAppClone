import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final callRepositoryProvider = Provider<CallRepository>(
  (ref) => CallRepository(supabase: Supabase.instance.client),
);

class CallRepository {
  CallRepository({required this.supabase});

  final SupabaseClient supabase;
}
