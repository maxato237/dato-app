import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/features/auth/widgets/auth_screen.dart';

class ForgotScreen extends ConsumerStatefulWidget {
  const ForgotScreen({super.key});

  @override
  ConsumerState<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends ConsumerState<ForgotScreen> {
  final _idCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  String? _idErr;

  @override
  void dispose() {
    _idCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final id = _idCtrl.text.trim();
    if (id.isEmpty) {
      setState(() => _idErr = 'Le numéro est obligatoire.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _idErr = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .sendPasswordReset(identifier: id);
      if (mounted) context.push(Routes.onboardingOtp);
    } on Exception catch (e) {
      if (mounted) {
        setState(
            () => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthScreen(
      title: 'Mot de passe oublié',
      subtitle:
          'Indiquez votre numéro, nous vous enverrons un code de réinitialisation.',
      onBack: () => context.go(Routes.onboardingLogin),
      children: [
        if (_error != null) ...[
          _ErrorBox(message: _error!),
          const SizedBox(height: 16),
        ],
        _PhoneOrEmailField(
          controller: _idCtrl,
          error: _idErr,
          onChanged: (_) {
            if (_idErr != null) setState(() => _idErr = null);
          },
        ),
        const SizedBox(height: 20),
        FilledButton(
          key: const Key('forgot_submit'),
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Envoyer le code'),
        ),
        const SizedBox(height: 18),
        Center(
          child: TextButton(
            onPressed: () => context.go(Routes.onboardingLogin),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Retour à la connexion',
              style: TextStyle(
                  fontSize: 14,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhoneOrEmailField extends StatelessWidget {
  final TextEditingController controller;
  final String? error;
  final ValueChanged<String>? onChanged;
  const _PhoneOrEmailField(
      {required this.controller, this.error, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    final borderColor = hasError ? AppColors.danger : AppColors.borderStrong;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Téléphone ou e-mail',
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
                key: const Key('forgot_identifier'),
                controller: controller,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: onChanged,
                style:
                    const TextStyle(fontSize: 16, color: AppColors.text),
                decoration: InputDecoration(
                  hintText: '6 74 70 20 37',
                  hintStyle:
                      const TextStyle(color: AppColors.textLight),
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
          style:
              const TextStyle(color: AppColors.danger, fontSize: 13.5)),
    );
  }
}
