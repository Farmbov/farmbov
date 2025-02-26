import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmbov/src/domain/models/firestore/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

const usersCollection = 'users';

class UserRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential?> createAccountWithEmail(
      String email, String password) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(), password: password);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> findUserById(String id) async {
    try {
      return await _firestore.collection(usersCollection).doc(id).get().then(
            (doc) => UserModel.getDocumentFromData(
              doc.data() as Map<String, dynamic>,
              doc.reference,
            ),
          );
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> findUserByDocumentOrEmail(String documentOrEmail) async {
    UserModel? userByEmail;
    UserModel? userByDocument;

    final QuerySnapshot emailResult = await _firestore
        .collection(usersCollection)
        .where('email', isEqualTo: documentOrEmail)
        .get();
    final List<QueryDocumentSnapshot> emailDocs = emailResult.docs;
    if (emailDocs.isNotEmpty) {
      userByEmail = UserModel.getDocumentFromData(
          emailDocs.first.data() as Map<String, dynamic>,
          emailDocs.first.reference);
    }

    final QuerySnapshot documentResult = await _firestore
        .collection(usersCollection)
        .where('document', isEqualTo: documentOrEmail)
        .get();

    if (documentResult.docs.isNotEmpty) {
      final List<QueryDocumentSnapshot> documentDocs = documentResult.docs;
      userByDocument = UserModel.getDocumentFromData(
          documentDocs.first.data() as Map<String, dynamic>,
          documentDocs.first.reference);
    }

    if (userByEmail != null) {
      return userByEmail;
    } else if (userByDocument != null) {
      return userByDocument;
    } else {
      return null;
    }
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;
}
