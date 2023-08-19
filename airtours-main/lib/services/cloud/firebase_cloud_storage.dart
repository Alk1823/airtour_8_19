
import 'package:cloud_firestore/cloud_firestore.dart';



class FirebaseCloudStorage {
  //user
  final user = FirebaseFirestore.instance.collection('user');
  final admin = FirebaseFirestore.instance.collection('admin');

  Future<bool> isUser({required ownerUserId}) async {
    final docRef = user.doc(ownerUserId);
    final docSnap = await docRef.get(); //get makes it snapshot
    return docSnap.exists;
  }


  void updateUser({
  required String ownerUserId,
  required String email,
  required String phoneNum}) async {
    DocumentReference docRef = user.doc(ownerUserId);
    await docRef.update({
      "email" : email,
      "phoneNum" : phoneNum
    });
  }
  
  void createNewAdmin({
    required String email,
    required String phoneNum
  }) async {
    await admin.add({
      "email": email,
      "phoneNum": phoneNum
      });
  }

 
  void createNewUser({ 
    required String ownerUserId,
    required String email,
    required String phoneNum,
    required double balance
    })  async {
     DocumentReference doc_ref = user.doc(ownerUserId);
     await doc_ref.set({
      "email" : email,
      "phoneNum" : phoneNum,
      "balance" : balance
     });
  }

  static final FirebaseCloudStorage _shared = 
  FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage()  => _shared;
  
}