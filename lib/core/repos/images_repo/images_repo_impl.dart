import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../errors/failure.dart';
import '../../services/storage_services.dart';
import 'images_repo.dart';

class ImagesRepoImpl implements ImagesRepo {
  final StorageServices storageServices;

  ImagesRepoImpl({required this.storageServices});
  @override
  Future<Either<Failure, String>> uploadImage({required File image, required String path}) async {
    try {
      String url = await storageServices.uploadImageToStorage(
        path ,
        image,
      );

      return Right(url);
    } catch (e) {
      return const Left(ServerFailure("Failed to upload image"));
    }
  }
}
