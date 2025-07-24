import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

abstract class ContactsRepo {
  Stream<Either<Failure, List<String>>> getContacts();
  Future<Either<Failure, String>> createContact(String email);
  Future<Either<Failure, String>> deleteContact(String uId);
}