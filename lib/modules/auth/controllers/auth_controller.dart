import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_text.dart';
import '../../../services/auth_service.dart';
import '../../home/controllers/home_controller.dart';

class AuthController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;
  final RxString errorText = ''.obs;

  User? get currentUser => _firebaseAuth.currentUser;

  Future<bool> signInWithEmail(String email, String password) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty || password.isEmpty) {
      errorText.value = 'Please enter your email and password.';
      return false;
    }

    return _guard(() async {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
    });
  }

  Future<bool> signUpWithEmail({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final trimmedFirst = firstName.trim();
    final trimmedLast = lastName.trim();
    final trimmedEmail = email.trim();

    if (trimmedFirst.isEmpty || trimmedLast.isEmpty) {
      errorText.value = 'Please enter your first and last name.';
      return false;
    }
    if (trimmedEmail.isEmpty || password.isEmpty) {
      errorText.value = 'Please enter your email and password.';
      return false;
    }
    if (password.length < 6) {
      errorText.value = 'Password must be at least 6 characters.';
      return false;
    }
    if (password != confirmPassword) {
      errorText.value = 'Passwords do not match.';
      return false;
    }

    return _guard(() async {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );

      await credential.user?.updateDisplayName('$trimmedFirst $trimmedLast');

      await _firestore
          .collection(AppTexts.colUsers)
          .doc(credential.user?.uid)
          .set({
        'firstName': trimmedFirst,
        'lastName': trimmedLast,
        'email': trimmedEmail,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      errorText.value = 'Please enter your email address.';
      return false;
    }

    return _guard(() async {
      await _firebaseAuth.sendPasswordResetEmail(email: trimmedEmail);
    });
  }


  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      final result = await AuthService.signInWithGoogle();
      if (result != null) {
        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchHomeData();
        }
      }
    } catch (e) {
      errorText.value = 'Sign-in failed. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithApple() async {
    await _guard(() => AuthService.signInWithApple());
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<bool> _guard(Future<void> Function() action) async {
    isLoading.value = true;
    errorText.value = '';
    try {
      await action();
      return true;
    } catch (e) {
      errorText.value = _mapError(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _mapError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'That email address looks invalid.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'user-not-found':
          return 'No account found with that email.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Incorrect email or password.';
        case 'email-already-in-use':
          return 'An account already exists with that email.';
        case 'weak-password':
          return 'Please choose a stronger password.';
        case 'network-request-failed':
          return 'Network error — please check your connection.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        default:
          return error.message ?? 'Something went wrong. Please try again.';
      }
    }
    return 'Something went wrong. Please try again.';
  }
}