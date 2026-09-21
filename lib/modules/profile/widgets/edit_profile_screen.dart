import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_text.dart';
import '../../auth/screens/login_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isDeleting = false;
  bool _isLoadingProfile = true;

  String _phone = ''; // Firestore ka 'phone' field — FirebaseAuth.phoneNumber nahi,
  // kyunki wo sirf phone-auth users ke liye set hota hai

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final uid = _user?.uid;
    if (uid == null) {
      setState(() => _isLoadingProfile = false);
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance.collection(AppTexts.colUsers).doc(uid).get();
      final data = doc.data();
      if (!mounted) return;
      setState(() {
        _phone = (data?['phone'] as String?) ?? '';
        _isLoadingProfile = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _editName() async {
    final result = await _editTextField(title: 'Name', initialValue: _user?.displayName ?? '');
    if (result == null || result.trim().isEmpty) return;
    final name = result.trim();
    try {
      await _user?.updateDisplayName(name);
      await FirebaseFirestore.instance.collection(AppTexts.colUsers).doc(_user?.uid).set({
        'firstName': name.split(' ').first,
        'lastName': name.split(' ').length > 1 ? name.split(' ').sublist(1).join(' ') : '',
      }, SetOptions(merge: true));
      if (mounted) setState(() {});
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update name. Please try again.')),
        );
      }
    }
  }

  Future<void> _editPhone() async {
    final result = await _editTextField(
      title: 'Phone Number',
      initialValue: _phone,
      keyboardType: TextInputType.phone,
    );
    if (result == null) return;
    final phone = result.trim();
    try {
      await FirebaseFirestore.instance.collection(AppTexts.colUsers).doc(_user?.uid).set({
        'phone': phone,
      }, SetOptions(merge: true));
      if (mounted) setState(() => _phone = phone);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update phone. Please try again.')),
        );
      }
    }
  }

  Future<String?> _editTextField({
    required String title,
    required String initialValue,
    TextInputType? keyboardType,
  }) {
    final ctrl = TextEditingController(text: initialValue);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: keyboardType,
          decoration: InputDecoration(hintText: 'Enter $title'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(ctrl.text), child: const Text('Save')),
        ],
      ),
    );
  }

  void _copyUserId() {
    final uid = _user?.uid ?? '';
    Clipboard.setData(ClipboardData(text: uid));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User ID copied')),
    );
  }

  // ===== Delete Account — proper reauth handling + full profile data cleanup =====
  Future<void> _confirmDeleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This will permanently delete your account and all your data. This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await _performDelete();
  }

  Future<void> _performDelete() async {
    setState(() => _isDeleting = true);
    final user = _user;
    final uid = user?.uid;

    try {
      if (uid != null) {
        await _deleteAllUserData(uid);
      }
      await user?.delete();
      await _cleanupGoogleSession();

      if (!mounted) return;
      Get.offAll(() => LoginScreen());
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'requires-recent-login') {
        final reauthSuccess = await _reauthenticate();
        if (reauthSuccess) {
          try {
            await FirebaseAuth.instance.currentUser?.delete();
            await _cleanupGoogleSession();
            if (!mounted) return;
            Get.offAll(() => LoginScreen());
            return;
          } catch (_) {
            if (!mounted) return;
            setState(() => _isDeleting = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Could not delete account. Please try again.')),
            );
            return;
          }
        }
        setState(() => _isDeleting = false);
      } else {
        setState(() => _isDeleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not delete account. Please try again.')),
        );
      }
    } catch (e) {
      debugPrint('Account deletion failed: $e');
      if (!mounted) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not delete account. Please try again.')),
      );
    }
  }

  /// Sirf user-owned PROFILE data delete karta hai (bookings/reviews yahan
  /// se exclude hain — jaisa tay hua tha).
  Future<void> _deleteAllUserData(String uid) async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection(AppTexts.colUsers).doc(uid);

    await _deleteSubcollection(userDoc.collection('favorites'));
    await _deleteSubcollection(userDoc.collection('favoriteDestinations'));

    // Purani profile picture agar Firebase Storage mein kabhi upload hui thi
    // to usko bhi clean kar dete hain (ab feature hata diya hai, lekin
    // purane users ke liye leftover file na rahe)
    try {
      await FirebaseStorage.instance.ref().child('profile_pictures/$uid.jpg').delete();
    } catch (_) {}

    await userDoc.delete();
  }

  Future<void> _deleteSubcollection(CollectionReference ref) async {
    final snapshot = await ref.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> _cleanupGoogleSession() async {
    try {
      await GoogleSignIn.instance.signOut(); // v6.x ho to: GoogleSignIn().signOut()
    } catch (_) {}
  }

  Future<bool> _reauthenticate() async {
    final user = _user;
    if (user == null) return false;

    final providerIds = user.providerData.map((p) => p.providerId).toList();

    if (providerIds.contains('google.com')) {
      try {
        final googleSignIn = GoogleSignIn.instance;
        await googleSignIn.initialize();
        final googleUser = await googleSignIn.authenticate();

        final googleAuth = googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        await user.reauthenticateWithCredential(credential);
        return true;
      } catch (e) {
        debugPrint('Google reauth failed: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Google sign-in failed. Please try again.')),
          );
        }
        return false;
      }
    }

    if (providerIds.contains('password')) {
      final password = await _promptPassword();
      if (password == null || password.isEmpty) return false;
      try {
        final credential = EmailAuthProvider.credential(email: user.email!, password: password);
        await user.reauthenticateWithCredential(credential);
        return true;
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Incorrect password. Please try again.')),
          );
        }
        return false;
      }
    }

    if (mounted) {
      await showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Please Log In Again'),
          content: const Text(
            'For your security, please log out and log back in, then try deleting your account again.',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: const Text('OK')),
          ],
        ),
      );
    }
    return false;
  }

  Future<String?> _promptPassword() {
    final ctrl = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Password'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          obscureText: true,
          decoration: const InputDecoration(hintText: 'Enter your password'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(ctrl.text), child: const Text('Confirm')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final background = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final divider = isDark ? AppColors.dividerDark : AppColors.dividerLight;
    final primary = isDark ? AppColors.primaryDarkMode : AppColors.primary;
    final primaryLight = isDark ? AppColors.surfaceDark : AppColors.primaryLight;

    final displayName = _user?.displayName?.trim() ?? '';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
    final uid = _user?.uid ?? '';
    final shortUid = uid.length > 20 ? '${uid.substring(0, 20)}…' : uid;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: Text('Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textPrimary)),
      ),
      body: _isLoadingProfile
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(AppSizes.md),
        children: [
          _SectionHeader('Profile Information', textPrimary: textPrimary),
          _InfoCard(
            surface: surface,
            divider: divider,
            children: [
              _InfoRow(
                label: 'Name',
                value: displayName.isNotEmpty ? displayName : 'Not Set',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                onTap: _editName,
              ),
              _InfoRow(
                label: 'Phone Number',
                value: _phone.isNotEmpty ? _phone : 'Not Set',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                onTap: _editPhone,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.md),

          _SectionHeader('Personal Information', textPrimary: textPrimary),
          _InfoCard(
            surface: surface,
            divider: divider,
            children: [
              _InfoRow(
                label: 'User ID',
                value: shortUid,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                trailing: Icon(Icons.copy_rounded, size: 17, color: textSecondary),
                onTap: _copyUserId,
              ),
              _InfoRow(
                label: 'Email',
                value: _user?.email ?? 'Not Set',
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ],
          ),
          const SizedBox(height: AppSizes.lg),

          Center(
            child: TextButton(
              onPressed: _isDeleting ? null : _confirmDeleteAccount,
              child: _isDeleting
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.error),
              )
                  : const Text(
                'Delete Account',
                style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Color textPrimary;
  const _SectionHeader(this.title, {required this.textPrimary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.sm),
      child: Text(title, style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w800, color: textPrimary)),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final Color surface;
  final Color divider;
  final List<Widget> children;
  const _InfoCard({required this.surface, required this.divider, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
        border: Border.all(color: divider),
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (i) {
          if (i.isOdd) return Divider(height: 1, color: divider, indent: AppSizes.md);
          return children[i ~/ 2];
        }),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color textPrimary;
  final Color textSecondary;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.textPrimary,
    required this.textSecondary,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm + 6),
        child: Row(
          children: [
            SizedBox(
              width: 110,
              child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textSecondary)),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
              ),
            ),
            const SizedBox(width: 6),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              Icon(Icons.chevron_right_rounded, size: 18, color: textPrimary.withOpacity(0.35)),
          ],
        ),
      ),
    );
  }
}