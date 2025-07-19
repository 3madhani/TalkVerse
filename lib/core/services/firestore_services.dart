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
    String? documentId,
    Map<String, dynamic>? queryParameters,
  }) async {
    final collectionRef = firestore.collection(path);

    // Delete by document ID
    if (documentId != null) {
      final docRef = collectionRef.doc(documentId);

      // 🔥 First delete all messages in the subcollection 'messages'
      final messagesRef = docRef.collection('Messages');
      final messagesSnapshot = await messagesRef.get();
      for (var doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // ✅ Then delete the chat room document itself
      await docRef.delete();
    } else {
      // Delete based on query
      Query<Map<String, dynamic>> query = collectionRef;

      if (queryParameters != null) {
        if (queryParameters["where"] != null &&
            queryParameters["isEqualTo"] != null) {
          var where = queryParameters["where"];
          var isEqualTo = queryParameters["isEqualTo"];
          query = query.where(where, isEqualTo: isEqualTo);
        }
      }

      final snapshot = await query.get();
      for (var doc in snapshot.docs) {
        // 🔥 First delete subcollection 'messages'
        final messagesRef = doc.reference.collection('messages');
        final messagesSnapshot = await messagesRef.get();
        for (var messageDoc in messagesSnapshot.docs) {
          await messageDoc.reference.delete();
        }

        // ✅ Delete main doc
        await doc.reference.delete();
      }
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
