import 'package:chitchat/core/errors/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/constants/backend/backend_end_points.dart';
import '../../../../core/services/database_services.dart';
import '../../../auth/data/model/user_model.dart';
import '../../domain/repos/contacts_repo.dart';

class ContactsRepoImpl implements ContactsRepo {
  final DatabaseServices databaseServices;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  ContactsRepoImpl({required this.databaseServices});

  @override
  Future<Either<Failure, String>> createContact(String email) async {
    try {
      if (currentUser == null) {
        return const Left(ServerFailure("User not logged in"));
      }

      final userId = currentUser!.uid;

      // Step 1: Find user by email
      final users = await databaseServices.getData(
        path: BackendEndPoints.getUser,
        queryParameters: {"where": "email", "isEqualTo": email},
      );

      if (users == null || users.isEmpty) {
        return const Left(ServerFailure("User not found"));
      }

      final contactModel = UserModel.fromJson(users.first);
      final contactUserId = contactModel.uId;

      // Step 2: Check if already in friends
      final myData = await databaseServices.getData(
        path: BackendEndPoints.getUser,
        documentId: userId,
      );

      if (myData != null) {
        final currentFriends = List<String>.from(myData['friends'] ?? []);
        if (currentFriends.contains(contactUserId)) {
          return const Right("Contact already exists");
        }
      }

      // Step 3: Add contact userId to current user's friends
      await databaseServices.updateData(
        path: BackendEndPoints.addUsers,
        data: {
          "friends": FieldValue.arrayUnion([contactUserId]),
        },
        documentId: userId,
      );

      return const Right("Contact added successfully");
    } catch (e) {
      return Left(ServerFailure("Failed to create contact: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteContact(String uId) async {
    try {
      if (currentUser == null) {
        return const Left(ServerFailure("User not logged in"));
      }

      final userId = currentUser!.uid;

      // Step 2: Remove contact userId from current user's friends
      await databaseServices.updateData(
        path: BackendEndPoints.addUsers,
        data: {
          "friends": FieldValue.arrayRemove([uId]),
        },
        documentId: userId,
      );

      return const Right("Contact deleted successfully");
    } catch (e) {
      return Left(ServerFailure("Failed to delete contact: ${e.toString()}"));
    }
  }

  @override
  Stream<Either<Failure, List<UserModel>>> getContacts() async* {
    if (currentUser == null) {
      yield const Left(ServerFailure("User not logged in"));
      return;
    }

    final userId = currentUser!.uid;

    yield* databaseServices
        .streamData(path: BackendEndPoints.getUser, documentId: userId)
        .asyncMap((myData) async {
          if (myData == null) {
            return const Left(ServerFailure("User not found"));
          }

          final friends = List<String>.from(myData['friends'] ?? []);
          if (friends.isEmpty) {
            return const Right(<UserModel>[]);
          }
          List<UserModel> contacts = [];
          try {
            for (final friendId in friends) {
              final friendData = await databaseServices.getData(
                path: BackendEndPoints.getUser,
                documentId: friendId,
              );

              if (friendData != null) {
                contacts.add(UserModel.fromJson(friendData));
              }
            }

            return Right(contacts);
          } catch (e) {
            return Left(
              ServerFailure("Failed to fetch contacts: ${e.toString()}"),
            );
          }
        });
  }
}
