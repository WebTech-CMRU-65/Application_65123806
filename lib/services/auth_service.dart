import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
	AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
		: _auth = auth ?? FirebaseAuth.instance,
			_firestore = firestore ?? FirebaseFirestore.instance;

	final FirebaseAuth _auth;
	final FirebaseFirestore _firestore;

	Stream<User?> authStateChanges() => _auth.authStateChanges();

	Future<UserCredential> registerWithEmail({
		required String email,
		required String password,
		required String displayName,
	}) async {
		final credential = await _auth.createUserWithEmailAndPassword(
			email: email,
			password: password,
		);
		await credential.user?.updateDisplayName(displayName);
		await _createUserProfile(credential.user!, displayName: displayName);
		return credential;
	}

	Future<UserCredential> loginWithEmail({
		required String email,
		required String password,
	}) {
		return _auth.signInWithEmailAndPassword(email: email, password: password);
	}

	Future<void> logout() => _auth.signOut();

	Future<void> _createUserProfile(User user, {required String displayName}) async {
		final doc = _firestore.collection('users').doc(user.uid);
		await doc.set({
			'uid': user.uid,
			'email': user.email,
			'displayName': displayName,
			'createdAt': FieldValue.serverTimestamp(),
		}, SetOptions(merge: true));
	}
}
