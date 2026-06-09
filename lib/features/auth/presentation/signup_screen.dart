import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/dato_text_field.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/features/auth/widgets/auth_screen.dart';
import 'package:dato/features/auth/widgets/pw_field.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final phone = '+237${_phoneCtrl.text.trim().replaceAll(' ', '')}';
    final pw = _pwCtrl.text;

    if (name.isEmpty || _phoneCtrl.text.trim().isEmpty || pw.isEmpty) {
      setState(() => _error = 'Veuillez remplir tous les champs obligatoires.');
      return;
    }
    if (pw.length < 8) {
      setState(() => _error = 'Le mot de passe doit contenir au moins 8 caractères.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final email = _emailCtrl.text.trim();
      await ref.read(authRepositoryProvider).signUp(
            name: name,
            phone: phone,
            password: pw,
            email: email.isEmpty ? null : email,
          );
      if (mounted) context.push(Routes.onboardingOtp);
    } on Exception catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      title: 'Créez votre compte',
      subtitle:
          'Vos premiers devis professionnels en quelques minutes. C\'est gratuit.',
      children: [
        if (_error != null) ...[
          _ErrorBox(message: _error!),
          const SizedBox(height: 16),
        ],
        DatoTextField(
          key: const Key('signup_name'),
          controller: _nameCtrl,
          label: 'Nom complet',
          hint: 'Ex. Jean-Pierre Mballa',
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        _PhoneField(controller: _phoneCtrl),
        const SizedBox(height: 16),
        DatoTextField(
          key: const Key('signup_email'),
          controller: _emailCtrl,
          label: 'E-mail (optionnel)',
          hint: 'vous@exemple.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        PwField(
          fieldKey: const Key('signup_password'),
          controller: _pwCtrl,
        ),
        const SizedBox(height: 4),
        const Text(
          '8 caractères minimum',
          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        const SizedBox(height: 20),
        FilledButton(
          key: const Key('signup_submit'),
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Créer mon compte'),
        ),
        const SizedBox(height: 18),
        _AuthFooter(
          text: 'Déjà un compte ? ',
          linkLabel: 'Se connecter',
          onTap: () => context.go(Routes.onboardingLogin),
        ),
      ],
    );
  }
}

/// Champ téléphone avec préfixe +237.
class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Téléphone',
          style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.text),
        ),
        const SizedBox(height: 7),
        Row(
          children: [
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.bg,
                border: Border.all(
                    color: AppColors.borderStrong, width: 1.5),
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              alignment: Alignment.center,
              child: const Text(
                '+237',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                key: const Key('signup_phone'),
                controller: controller,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(fontSize: 16, color: AppColors.text),
                decoration: InputDecoration(
                  hintText: '6 74 70 20 37',
                  hintStyle: const TextStyle(color: AppColors.textLight),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    borderSide: const BorderSide(
                        color: AppColors.borderStrong, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    borderSide:
                        const BorderSide(color: AppColors.ink, width: 1.5),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ErrorBox extends StatelessWidget {
  final String message;
  const _ErrorBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.danger100,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Text(message,
          style: const TextStyle(color: AppColors.danger, fontSize: 13.5)),
    );
  }
}

class _AuthFooter extends StatelessWidget {
  final String text;
  final String linkLabel;
  final VoidCallback onTap;

  const _AuthFooter({
    required this.text,
    required this.linkLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textMuted)),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(linkLabel,
              style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}
