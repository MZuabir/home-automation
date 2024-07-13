import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:home_automation/app/data/models/user_model.dart';

class FireBaseServices {
  final firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  createUser(UserModel userData) async {
    await firebaseFirestore
        .collection('users')
        .doc(userData.email)
        .set(userData.toJson());
  }

  Future<String> uploadPhoto(File image) async {
    try {
      Reference reference = storage.ref().child(image.path.split('/').last);
      UploadTask uploadTask = reference.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } on Exception {
      rethrow;
    }
  }
}
