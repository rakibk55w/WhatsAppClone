import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final commonSupabaseStorageRepositoryProvider = Provider(
  (ref) =>
      CommonSupabaseStorageRepository(supabaseClient: Supabase.instance.client),
);

class CommonSupabaseStorageRepository {
  CommonSupabaseStorageRepository({required this.supabaseClient});

  final SupabaseClient supabaseClient;

  Future<String> storeFileToSupabase({
    required String bucket,
    required String path,
    required File file,
  }) async {
    final fileBytes = await file.readAsBytes();

    final response = await supabaseClient.storage
        .from(bucket)
        .uploadBinary(
          path,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );

    if (response.isEmpty) {
      throw Exception('File upload failed.');
    }

    final publicUrl = supabaseClient.storage.from(bucket).getPublicUrl(path);
    return publicUrl;
  }
}
