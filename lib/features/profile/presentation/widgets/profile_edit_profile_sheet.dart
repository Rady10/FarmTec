import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/app_fonts.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/profile/presentation/widgets/profile_sheet.dart';
import 'package:farmtec/features/profile/presentation/widgets/profile_sheet_field.dart';
import 'package:farmtec/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEditProfileSheet extends StatefulWidget {
  final bool isDark;
  final AppLocalizations l;

  const ProfileEditProfileSheet({
    super.key,
    required this.isDark,
    required this.l,
  });

  @override
  State<ProfileEditProfileSheet> createState() => _ProfileEditProfileSheetState();
}

class _ProfileEditProfileSheetState extends State<ProfileEditProfileSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.user;
    _nameController = TextEditingController(text: user?.username ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileSheet(
      title: widget.l.tr('edit_profile'),
      isDark: widget.isDark,
      child: Column(
        children: [
          ProfileSheetField(
            widget.l.tr('full_name'),
            _nameController.text,
            Icons.person_outline_rounded,
            isDark: widget.isDark,
            controller: _nameController,
          ),
          const SizedBox(height: 12),
          // Email address is read-only (not updated via backend put API)
          ProfileSheetField(
            widget.l.tr('email_address'),
            _emailController.text,
            Icons.email_outlined,
            isDark: widget.isDark,
            controller: _emailController,
          ),
          const SizedBox(height: 12),
          ProfileSheetField(
            widget.l.tr('phone_number'),
            _phoneController.text,
            Icons.phone_outlined,
            isDark: widget.isDark,
            controller: _phoneController,
          ),
          const SizedBox(height: 20),
          _isSaving
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Pallete.primary),
                  ),
                )
              : ProfileSheetButton(
                  widget.l.tr('save_changes'),
                  onTap: _saveChanges,
                ),
        ],
      ),
    );
  }

  Future<void> _saveChanges() async {
    final username = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.l.isArabic ? 'الاسم لا يمكن أن يكون فارغاً' : 'Name cannot be empty',
            style: AppFonts.font(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      await auth.updateProfile(username: username, phoneNumber: phone);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.l.tr('profile_updated'),
              style: AppFonts.font(),
            ),
            backgroundColor: Pallete.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.l.isArabic ? 'فشل تحديث الملف الشخصي' : 'Failed to update profile',
              style: AppFonts.font(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
