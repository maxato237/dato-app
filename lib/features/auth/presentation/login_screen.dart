import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/dato_text_field.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/features/auth/widgets/auth_screen.dart';
import 'package:dato/features/auth/widgets/pw_field.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final id = _idCtrl.text.trim();
    final pw = _pwCtrl.text;
    if (id.isEmpty || pw.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .signIn(identifier: id, password: pw);
      // Le router redirige automatiquement vers home via le RouterNotifier.
    } on Exception catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      title: 'Content de vous revoir',
      subtitle: 'Connectez-vous pour accéder à vos devis.',
      children: [
        if (_error != null) ...[
          _ErrorBox(message: _error!),
          const SizedBox(height: 16),
        ],
        DatoTextField(
          key: const Key('login_identifier'),
          controller: _idCtrl,
          label: 'Téléphone ou e-mail',
          hint: '+237 6 74 70 20 37',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        PwField(
          fieldKey: const Key('login_password'),
          controller: _pwCtrl,
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push(Routes.onboardingForgot),
            child: const Text('Mot de passe oublié ?'),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          key: const Key('login_submit'),
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Se connecter'),
        ),
        const SizedBox(height: 18),
        _AuthFooter(
          text: 'Pas encore de compte ? ',
          linkLabel: 'Créer un compte',
          onTap: () => context.push(Routes.onboardingSignup),
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
      child: Text(
        message,
        style: const TextStyle(
            color: AppColors.danger, fontSize: 13.5),
      ),
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
