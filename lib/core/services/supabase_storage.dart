import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants/keys/keys.dart';
import 'storage_services.dart';

class SupabaseStorage implements StorageServices {
  static late Supabase _supabase;

  @override
  Future<String> uploadImageToStorage(String path, File file) async {
    // Ensure the bucket exists
    String ext = file.path.split('.').last;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final filename = "$path/$timestamp.$ext";

    await _supabase.client.storage
        .from("chat-images")
        .upload(filename, file, fileOptions: const FileOptions(upsert: true));

    final imageUrl = _supabase.client.storage
        .from("chat-images")
        .getPublicUrl(filename);

    return imageUrl;
  }

  static createBucket(String bucketName) async {
    // Check if the bucket already exists
    final existingBuckets = await _supabase.client.storage.listBuckets();

    if (existingBuckets.any((bucket) => bucket.id == bucketName)) {
      return;
    } else {
      await _supabase.client.storage.createBucket(
        bucketName,
        const BucketOptions(public: true),
      );
    }
  }

  static initSupabase() async {
    // Initialize Supabase
    _supabase = await Supabase.initialize(
      url: Keys.supabaseUrl,
      anonKey: Keys.supabaseKey,
    );
  }
}
