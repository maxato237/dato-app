import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/dato_text_field.dart';
import 'package:dato/features/auth/domain/auth_status.dart';
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
  String? _nameErr;
  String? _phoneErr;
  String? _pwErr;

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

    final nameErr = name.isEmpty ? 'Le nom complet est obligatoire.' : null;
    final phoneErr =
        _phoneCtrl.text.trim().isEmpty ? 'Le téléphone est obligatoire.' : null;
    final pwErr = pw.isEmpty
        ? 'Le mot de passe est obligatoire.'
        : (pw.length < 8
            ? 'Le mot de passe doit contenir au moins 8 caractères.'
            : null);

    if (nameErr != null || phoneErr != null || pwErr != null) {
      setState(() {
        _error = null;
        _nameErr = nameErr;
        _phoneErr = phoneErr;
        _pwErr = pwErr;
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _nameErr = null;
      _phoneErr = null;
      _pwErr = null;
    });
    try {
      final email = _emailCtrl.text.trim();
      final repo = ref.read(authRepositoryProvider);
      await repo.signUp(
        name: name,
        phone: phone,
        password: pw,
        email: email.isEmpty ? null : email,
      );
      if (mounted) {
        // REQUIRE_OTP=false → tokens déjà reçus : aller au stepper de
        // configuration entreprise (étape 1), qui crée l'entreprise via
        // POST /api/company. Sans ça, le router enverrait l'utilisateur
        // directement au dashboard sans entreprise → /api/quotes, /api/company
        // et /api/company/template renvoient alors 404.
        // REQUIRE_OTP=true  → aller à l'écran OTP ; la vérification SMS
        // enchaînera ensuite sur le même stepper (onboarding1).
        if (repo.status == AuthStatus.authenticated) {
          context.go(Routes.onboarding1);
        } else {
          context.push(Routes.onboardingOtp);
        }
      }
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
          error: _nameErr,
          textInputAction: TextInputAction.next,
          onChanged: (_) {
            if (_nameErr != null) setState(() => _nameErr = null);
          },
        ),
        const SizedBox(height: 16),
        _PhoneField(
          controller: _phoneCtrl,
          error: _phoneErr,
          onChanged: (_) {
            if (_phoneErr != null) setState(() => _phoneErr = null);
          },
        ),
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
          error: _pwErr,
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
  final String? error;
  final ValueChanged<String>? onChanged;
  const _PhoneField({required this.controller, this.error, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    final borderColor = hasError ? AppColors.danger : AppColors.borderStrong;
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
                border: Border.all(color: borderColor, width: 1.5),
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
                onChanged: onChanged,
                style: const TextStyle(fontSize: 16, color: AppColors.text),
                decoration: InputDecoration(
                  hintText: '6 74 70 20 37',
                  hintStyle: const TextStyle(color: AppColors.textLight),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    borderSide: BorderSide(color: borderColor, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                    borderSide: BorderSide(
                        color: hasError ? AppColors.danger : AppColors.ink,
                        width: 1.5),
                  ),
                  filled: true,
                  fillColor: AppColors.surface,
                ),
              ),
            ),
          ],
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(error!,
              style: const TextStyle(fontSize: 12, color: AppColors.danger)),
        ],
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
