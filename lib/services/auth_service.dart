import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Register a new user with email, password, name, and optional profile image
  Future<User?> registerWithEmail({
    required String name,
    required String email,
    required String password,
    File? profileImage,
  }) async {
    try {
      final UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = cred.user;
      if (user == null) return null;

      // Upload profile image to Firebase Storage if provided
      String? photoUrl;
      if (profileImage != null) {
        try {
          final ref = _storage.ref().child('users/${user.uid}/profile.jpg');
          final UploadTask uploadTask = ref.putFile(
            profileImage,
            SettableMetadata(contentType: 'image/jpeg'),
          );
          final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
          photoUrl = await snapshot.ref.getDownloadURL();
        } catch (e) {
          // Upload failed; log and continue without photo
          // Caller will receive registration success but no photo URL
          // You can surface this error to the UI if desired
          print('Profile image upload failed: $e');
          photoUrl = null;
        }
      }

      // Update user profile with name and photo URL
      await user.updateDisplayName(name);
      if (photoUrl != null) await user.updatePhotoURL(photoUrl);
      await user.reload();

      // Save user profile to Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'displayName': name,
        'email': email,
        'photoURL': photoUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return _auth.currentUser;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign in user with email and password
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;
}
