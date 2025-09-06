import 'package:chitchat/core/errors/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'database_services.dart';

class FireStoreServices implements DatabaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Future<bool> checkIfDocumentExists({
    required String path,
    required String documentId,
  }) async {
    var doc = await firestore.collection(path).doc(documentId).get();
    return doc.exists;
  }

  @override
  Future<void> deleteData({
    required String path,
    dynamic documentId,
    Map<String, dynamic>? queryParameters,
  }) async {
    final collectionRef = firestore.collection(path);

    try {
      if (documentId != null && queryParameters == null) {
        // Handle single document deletion
        if (documentId is String) {
          final docRef = collectionRef.doc(documentId);

          // 🔥 Delete messages subcollection first
          await deleteMessagesSubcollection(docRef);

          // ✅ Delete the main document
          await docRef.delete();
        } else if (documentId is List<String>) {
          for (var docId in documentId) {
            final docRef = collectionRef.doc(docId);
            await deleteMessagesSubcollection(docRef);
            await docRef.delete();
          }
        } else {
          throw ArgumentError('documentId must be a String or List<String>');
        }
      } else if (documentId == null) {
        // 🔍 Query-based deletion
        Query<Map<String, dynamic>> query = collectionRef;

        if (queryParameters != null &&
            queryParameters['where'] != null &&
            queryParameters['isEqualTo'] != null) {
          query = query.where(
            queryParameters['where'],
            isEqualTo: queryParameters['isEqualTo'],
          );
        }

        final snapshot = await query.get();

        for (var doc in snapshot.docs) {
          await deleteMessagesSubcollection(doc.reference);
          await doc.reference.delete();
        }
      } else if (queryParameters != null && documentId != null) {
        collectionRef.doc(documentId).update({
          'members': FieldValue.arrayRemove([queryParameters['memberId']]),
        });
      }
    } catch (e) {
      throw ServerFailure('Failed to delete data: $e');
    }
  }

  Future<void> deleteMessagesSubcollection(DocumentReference docRef) async {
    final messagesRef = docRef.collection('Messages'); // 🧠 Consistent casing
    final messagesSnapshot = await messagesRef.get();
    for (var messageDoc in messagesSnapshot.docs) {
      await messageDoc.reference.delete();
    }
  }

  @override
  Stream fetchUser({
    required String path,
    String? documentId,
    List<String>? listOfIds,
  }) {
    if (documentId != null) {
      return firestore
          .collection(path)
          .doc(documentId)
          .snapshots()
          .map((snapshot) => snapshot.data());
    } else if (listOfIds != null && listOfIds.isNotEmpty) {
      return firestore
          .collection(path)
          .where(FieldPath.documentId, whereIn: listOfIds)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } else {
      throw ArgumentError('Either documentId or listOfIds must be provided');
    }
  }

  @override
  Future<dynamic> getData({
    required String path,
    String? documentId,
    Map<String, dynamic>? queryParameters,
  }) async {
    if (documentId != null) {
      // If documentId is provided, fetch the specific document
      var doc = await firestore.collection(path).doc(documentId).get();
      return doc.data();
    } else {
      // If documentId is not provided, fetch the entire collection
      Query<Map<String, dynamic>> querySnapshot = firestore.collection(path);
      if (queryParameters != null) {
        // Apply query parameters if provided
        if (queryParameters["orderBy"] != null) {
          var orderBy = queryParameters["orderBy"];
          var descending = queryParameters["descending"] ?? false;
          querySnapshot = querySnapshot.orderBy(
            orderBy,
            descending: descending,
          );
        }

        if (queryParameters["limit"] != null) {
          var limit = queryParameters["limit"];
          querySnapshot = querySnapshot.limit(limit);
        }

        if (queryParameters["where"] != null &&
            queryParameters["isEqualTo"] != null) {
          var where = queryParameters["where"];
          var isEqualTo = queryParameters["isEqualTo"];
          querySnapshot = querySnapshot.where(where, isEqualTo: isEqualTo);
        }
      }
      var querySnapshotResult = await querySnapshot.get();
      // Convert the query snapshot to a list of maps
      return querySnapshotResult.docs.map((doc) => doc.data()).toList();
    }
  }

  @override
  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    if (documentId != null) {
      await firestore.collection(path).doc(documentId).set(data);
    } else {
      await firestore.collection(path).add(data);
    }
  }

  @override
  Stream streamData({
    required String path,
    Map<String, dynamic>? queryParameters,
    String? documentId,
  }) {
    if (documentId != null) {
      return firestore.collection(path).doc(documentId).snapshots().map((
        snapshot,
      ) {
        final data = snapshot.data();
        if (data != null) {
          data['messageId'] = snapshot.id;
        }
        return data;
      });
    } else {
      Query<Map<String, dynamic>> querySnapshot = firestore.collection(path);

      if (queryParameters != null) {
        if (queryParameters["where"] != null &&
            queryParameters["isEqualTo"] != null) {
          var where = queryParameters["where"];
          var isEqualTo = queryParameters["isEqualTo"];
          querySnapshot = querySnapshot.where(where, isEqualTo: isEqualTo);
        }

        if (queryParameters["arrayContains"] != null &&
            queryParameters["field"] != null) {
          var field = queryParameters["field"];
          var value = queryParameters["arrayContains"];
          querySnapshot = querySnapshot.where(field, arrayContains: value);
        }

        if (queryParameters["orderBy"] != null) {
          var orderBy = queryParameters["orderBy"];
          var descending = queryParameters["descending"] ?? false;
          querySnapshot = querySnapshot.orderBy(
            orderBy,
            descending: descending,
          );
        }

        if (queryParameters["limit"] != null) {
          var limit = queryParameters["limit"];
          querySnapshot = querySnapshot.limit(limit);
        }
      }

      return querySnapshot.snapshots(includeMetadataChanges: true).map((
        snapshot,
      ) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['messageId'] = doc.id; // ✅ Important!
          return data;
        }).toList();
      });
    }
  }

  @override
  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    if (documentId != null) {
      await firestore.collection(path).doc(documentId).update(data);
    }
  }
}
