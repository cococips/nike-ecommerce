import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nike_ecommerce/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:nike_ecommerce/core/utils/logger.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService(FirebaseStorage.instance);
});

class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  Future<Either<Failure, String>> uploadImage(File file, String path) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child(path).child(fileName);
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
      );
      
      final snapshot = await ref.putFile(file, metadata);
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      log.d('Successfully uploaded image to $downloadUrl');
      return right(downloadUrl);
    } catch (e) {
      log.e('Failed to upload image', error: e);
      return left(ServerFailure('Gagal mengunggah gambar: ${e.toString()}'));
    }
  }
}
