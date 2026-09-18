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
  final RxString errorText = ''.obs; // generic, non-field-specific errors

  // ---- Field-level errors — each field reads only its own, so the
  // message shows directly underneath it instead of one blob at the end. ----
  final RxnString emailError = RxnString();
  final RxnString passwordError = RxnString();
  final RxnString confirmPasswordError = RxnString();
  final RxnString firstNameError = RxnString();
  final RxnString lastNameError = RxnString();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  User? get currentUser => _firebaseAuth.currentUser;

  void _clearFieldErrors() {
    emailError.value = null;
    passwordError.value = null;
    confirmPasswordError.value = null;
    firstNameError.value = null;
    lastNameError.value = null;
    errorText.value = '';
  }

  // Call these from a field's onChanged so the red state clears the moment
  // the person starts fixing it, rather than waiting for another submit tap.
  void clearEmailError() => emailError.value = null;
  void clearPasswordError() => passwordError.value = null;
  void clearConfirmPasswordError() => confirmPasswordError.value = null;
  void clearFirstNameError() => firstNameError.value = null;
  void clearLastNameError() => lastNameError.value = null;

  Future<bool> signInWithEmail(String email, String password) async {
    final trimmedEmail = email.trim();
    _clearFieldErrors();

    bool valid = true;
    if (trimmedEmail.isEmpty) {
      emailError.value = 'Please enter your email';
      valid = false;
    } else if (!_emailPattern.hasMatch(trimmedEmail)) {
      emailError.value = 'Enter a valid email address';
      valid = false;
    }
    if (password.isEmpty) {
      passwordError.value = 'Please enter your password';
      valid = false;
    }
    if (!valid) return false;

    isLoading.value = true;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: trimmedEmail, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      _mapSignInError(e);
      return false;
    } catch (_) {
      errorText.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _mapSignInError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        emailError.value = 'That email address looks invalid.';
        break;
      case 'user-not-found':
        emailError.value = 'No account found with that email.';
        break;
      case 'user-disabled':
        emailError.value = 'This account has been disabled.';
        break;
      case 'wrong-password':
      case 'invalid-credential':
        passwordError.value = 'Incorrect email or password.';
        break;
      case 'too-many-requests':
        errorText.value = 'Too many attempts. Please try again later.';
        break;
      case 'network-request-failed':
        errorText.value = 'Network error — please check your connection.';
        break;
      default:
        errorText.value = e.message ?? 'Something went wrong. Please try again.';
    }
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
    _clearFieldErrors();

    bool valid = true;
    if (trimmedFirst.isEmpty) {
      firstNameError.value = 'Required';
      valid = false;
    }
    if (trimmedLast.isEmpty) {
      lastNameError.value = 'Required';
      valid = false;
    }
    if (trimmedEmail.isEmpty) {
      emailError.value = 'Please enter your email';
      valid = false;
    } else if (!_emailPattern.hasMatch(trimmedEmail)) {
      emailError.value = 'Enter a valid email address';
      valid = false;
    }
    if (password.isEmpty) {
      passwordError.value = 'Please enter a password';
      valid = false;
    } else if (password.length < 6) {
      passwordError.value = 'Must be at least 6 characters';
      valid = false;
    }
    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = 'Please confirm your password';
      valid = false;
    } else if (password.isNotEmpty && password != confirmPassword) {
      confirmPasswordError.value = 'Passwords do not match';
      valid = false;
    }
    if (!valid) return false;

    isLoading.value = true;
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: password,
      );
      await credential.user?.updateDisplayName('$trimmedFirst $trimmedLast');
      await _firestore.collection(AppTexts.colUsers).doc(credential.user?.uid).set({
        'firstName': trimmedFirst,
        'lastName': trimmedLast,
        'email': trimmedEmail,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          emailError.value = 'An account already exists with that email.';
          break;
        case 'invalid-email':
          emailError.value = 'That email address looks invalid.';
          break;
        case 'weak-password':
          passwordError.value = 'Please choose a stronger password.';
          break;
        case 'network-request-failed':
          errorText.value = 'Network error — please check your connection.';
          break;
        default:
          errorText.value = e.message ?? 'Something went wrong. Please try again.';
      }
      return false;
    } catch (_) {
      errorText.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    final trimmedEmail = email.trim();
    _clearFieldErrors();

    if (trimmedEmail.isEmpty) {
      emailError.value = 'Please enter your email address';
      return false;
    }
    if (!_emailPattern.hasMatch(trimmedEmail)) {
      emailError.value = 'Enter a valid email address';
      return false;
    }

    isLoading.value = true;
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: trimmedEmail);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          emailError.value = 'That email address looks invalid.';
          break;
        case 'user-not-found':
          emailError.value = 'No account found with that email.';
          break;
        default:
          errorText.value = e.message ?? 'Something went wrong. Please try again.';
      }
      return false;
    } catch (_) {
      errorText.value = 'Something went wrong. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithGoogle() async {
    isLoading.value = true;
    errorText.value = '';
    try {
      final result = await AuthService.signInWithGoogle();
      if (result == null) return false;   // user ne cancel kiya — error nahi, bas false
      await _saveUserToFirestoreIfNew(result);
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchHomeData();
      }
      return true;
    } catch (e) {
      errorText.value = 'Sign-in failed. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithApple() async {
    isLoading.value = true;
    errorText.value = '';
    try {
      final result = await AuthService.signInWithApple();
      await _saveUserToFirestoreIfNew(result);
      return true;
    } catch (e) {
      errorText.value = 'Sign-in failed. Please try again.';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveUserToFirestoreIfNew(UserCredential credential) async {
    final user = credential.user;
    if (user == null) return;

    final docRef = _firestore.collection(AppTexts.colUsers).doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      final nameParts = (user.displayName ?? '').trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      await docRef.set({
        'firstName': firstName,
        'lastName': lastName,
        'email': user.email ?? '',
        'photoUrl': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}