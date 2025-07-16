import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
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
    final mimeType = lookupMimeType(file.path, headerBytes: fileBytes);

    if (mimeType == null || !mimeType.startsWith('image/')) {
      throw Exception('Invalid file type. Only image files are allowed.');
    }

    final extension = extensionFromMime(mimeType);
    if (extension == null) {
      throw Exception('Unsupported image type.');
    }
    final pathWithExtension = '$path.$extension';

    try {
      await supabaseClient.storage
          .from(bucket)
          .uploadBinary(
            pathWithExtension,
            fileBytes,
            fileOptions: FileOptions(upsert: true, contentType: mimeType),

          );

      final publicUrl = supabaseClient.storage.from(bucket).getPublicUrl(pathWithExtension);
      return publicUrl;
    } catch (e){
      throw Exception('File upload failed: $e');
    }
  }

  String? extensionFromMime(String mime) {
    final map = {
      'image/jpeg': 'jpg',
      'image/png': 'png',
      'image/webp': 'webp',
      'image/gif': 'gif',
    };
    return map[mime];
  }
}
