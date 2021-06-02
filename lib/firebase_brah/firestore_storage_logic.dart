/// need import firebase_auth, firebase_storage, firestore packages.

class FirebaseController {
  @override
  Future<String> signInAnonymouslyToFirebase() async {
    UserCredential userCredential = await _anonymousAuth.signInAnonymously();
    User user = _anonymousAuth.currentUser;
    assert(userCredential.user.uid == user.uid && user.isAnonymous);
    debugPrint(
        'Anonymously sign in succeeded. uid:${_anonymousAuth.currentUser.uid}');
    return user.uid;
  }

  // firebase storage docs -> see : https://firebase.flutter.dev/docs/storage/usage
  @override
  Future<Map<String, String>> uploadFilesToFirebaseStorage(
    String userID,
    String noteID,
    List<String> paths,
  ) async {
    var result = <String, String>{};
    await Future.wait(paths.map((path) async {
      final nameUrlPair =
          await uploadFileToFirebaseStorage(userID, noteID, path);
      if (nameUrlPair.key != '') {
        result[nameUrlPair.key] = nameUrlPair.value;
      }
    }));
    return result;
  }

  @override
  Future<MapEntry<String, String>> uploadFileToFirebaseStorage(
    String userID,
    String noteID,
    String filePath,
  ) async {
    final fileName = path.basename(filePath).replaceAll('.', '');
    var imageFileToUpload = File(filePath);
    if (File(filePath).lengthSync() / 1000 > 1000) {
      final compressedFile = await _imageCompressor(filePath);
      if (compressedFile != null && compressedFile.existsSync()) {
        imageFileToUpload = compressedFile;
      }
    }

    // firestoreでのクエリ作成で、値にdotが含まれていると厄介だったのでdotを除去した
    // TODO: fileNameのアルファベット順で画像の順番が変わるのがまずいので, img1, img2,...とかで名前つけよう -> 登録時にリストインデックスの情報が必要? indexNum_filenameという感じ

    try {
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(firebaseStorageDir + '$userID/$noteID/$fileName');
      firebase_storage.UploadTask uploadTask =
          storageReference.putFile(imageFileToUpload);
      await uploadTask;

      final downloadUrl = await storageReference.getDownloadURL();
      return MapEntry(fileName, downloadUrl);
    } catch (e) {
      debugPrint(
          'ERROR:$e on note_repository_impl.uploadFileToFirebaseStorage');
      return MapEntry('', '');
    }
  }

  Future<File> _imageCompressor(String filePath) async {
    final targetPath =
        File(filePath).parent.path + '/compressed_' + path.basename(filePath);

    // The returned file may be null. In addition, please decide for yourself whether the file exists. see:https://pub.dev/packages/flutter_image_compress#result

    final result = await FlutterImageCompress.compressAndGetFile(
      filePath,
      targetPath,
      quality: 25,
    ).catchError((e) {
      debugPrint('ERROR:$e on noteRepoImpl._imageCompressor');
      return null;
    });
    if (result == null) {
      return null;
    }
    final originalSize = File(filePath).lengthSync() / 1000;
    final compressedSize = result.lengthSync() / 1000;
    debugPrint('original file size : $originalSize MB');
    debugPrint('compressed file size : $compressedSize MB');

    return result;
  }

  @override
  Future<List<String>> deleteFilesOnFirebaseStorage(
    String userID,
    String noteID,
    List<String> fileNames,
  ) async {
    var deletedFiles = await Future.wait(fileNames.map((fileName) async {
      var result = await deleteFileOnFirebaseStorage(userID, noteID, fileName);
      if (result) {
        return fileName;
      }
    }));
    debugPrint('deletedFileNames : ${deletedFiles.toString()}');
    return deletedFiles;
  }

  @override
  Future<bool> deleteFileOnFirebaseStorage(
      String userID, String noteID, String fileName) async {
    try {
      firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(firebaseStorageDir + '$userID/$noteID/$fileName');
      await storageReference.delete();
      return true;
    } catch (e) {
      debugPrint('ERROR:$e deleteFileOnFirebaseStorage()');
      return false;
    }
  }

  static const parentCollection = 'user';
  static const childCollection = 'imageUrls';
  static const fieldName = 'nameUrlPair';

  @override
  Future<void> editDocumentOnFirestore(
    String userID,
    String noteID, {
    Map<String, String> nameUrlPairToAdd,
    List<String> fileNamesToDelete,
  }) async {
    cloud_firestore.CollectionReference user =
        cloud_firestore.FirebaseFirestore.instance.collection(parentCollection);

    /// TODO: 各分岐の動作確認
    /// if (fileNamesToDelete == null && nameUrlPairToAdd != null) -> doc新規作成:OK, docアップデート(単/複数画像):OK
    /// else if (fileNamesToDelete != null && nameUrlPairToAdd == null) -> 画像削除(単/複数):OK
    /// -> imageUrlsコレクションに複数のdocがあれば、空になったdocのみを削除. 一つのdocしかなければuserコレクションのdoc(userID)も削除
    /// else if (fileNamesToDelete != null && nameUrlPairToAdd != null) -> 画像削除 & 追加:OK
    ///

    if (fileNamesToDelete == null && nameUrlPairToAdd != null) {
      var fieldToAdd = <String, dynamic>{};
      fieldToAdd[fieldName] = nameUrlPairToAdd;

      await user.doc(userID).collection(childCollection).doc(noteID).set(
            fieldToAdd,
            cloud_firestore.SetOptions(merge: true),
          );
    } else if (fileNamesToDelete != null && nameUrlPairToAdd == null) {
      var fieldToDelete = <String, dynamic>{};
      fileNamesToDelete.forEach((fileName) {
        fieldToDelete[fieldName + '.' + fileName] =
            cloud_firestore.FieldValue.delete();
      });
      await user.doc(userID).collection(childCollection).doc(noteID).update(
            fieldToDelete,
          );
      await user
          .doc(userID)
          .collection(childCollection)
          .where(fieldName, isEqualTo: <String, String>{})
          .get()
          .then((snapshot) => snapshot.docs.forEach((doc) {
                debugPrint('Will delete doc:${doc.id}');
                doc.reference.delete();
              }));
    } else if (fileNamesToDelete != null && nameUrlPairToAdd != null) {
      var fieldToAdd = <String, String>{};
      nameUrlPairToAdd.forEach((fileName, imageUrl) {
        fieldToAdd[fieldName + '.' + fileName] = imageUrl;
      });
      var fieldToDelete = <String, dynamic>{};
      fileNamesToDelete.forEach((fileName) {
        fieldToDelete[fieldName + '.' + fileName] =
            cloud_firestore.FieldValue.delete();
      });
      await user.doc(userID).collection(childCollection).doc(noteID).update({
        ...fieldToAdd,
        ...fieldToDelete,
      });
    } else {
      // オプショナルパラメータのうち一つは必ず設定して呼び出す使い方を想定しているため、
      // そのような呼び方をした場合はAssertionErrorを投げてクラッシュさせる。
      debugPrint('Unexpected use of editDocumentOnFirestore()');
      throw AssertionError('Unexpected type: $this}');
    }
  }

  @override
  Future<Map<String, Map<String, String>>> getDownloadUrls(
    String userID,
    List<String> noteIdList,
  ) async {
    debugPrint('getDownloadUrls() on noteRepoImpl');
    cloud_firestore.CollectionReference user =
        cloud_firestore.FirebaseFirestore.instance.collection(parentCollection);
    /*  await user.get().then(
        (value) => debugPrint('isFromCache:${value.metadata.isFromCache}')); */
    var result = <String, Map<String, String>>{};

    await Future.wait(noteIdList.map((noteID) async {
      await user
          .doc(userID)
          .collection(childCollection)
          .doc(noteID)
          .get()
          .then((doc) {
        if (doc.data() == null) {
          debugPrint('No document of noteID:$noteID');
          result[noteID] = <String, String>{};
        } else {
          /* debugPrint('${doc.data()}'); */
          debugPrint('Found document of noteID:$noteID');
          result[noteID] = Map<String, String>.from(doc.data()[fieldName]);
        }
      }).catchError((e) {
        debugPrint('ERROR:$e on getDownloadUrls()');
      });
    }));

    return result;
  }
}
