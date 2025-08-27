abstract class DatabaseServices {
  Future<bool> checkIfDocumentExists({
    required String path,
    required String documentId,
  });

  Future<void> deleteData({
    required String path,
    dynamic documentId,
    Map<String, dynamic>? queryParameters,
  });

  Stream<dynamic> fetchUser({
    required String path,
    String? documentId,
    List<String>? listOfIds,
  });

  Future<dynamic> getData({
    required String path,
    String? documentId,
    Map<String, dynamic>? queryParameters,
  });

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });
  Stream<dynamic> streamData({
    required String path,
    String? documentId,
    Map<String, dynamic>? queryParameters,
  });

  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  });
}
