import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/features/auth/widgets/auth_screen.dart';
import 'package:dato/features/auth/widgets/pw_field.dart';

class ResetScreen extends ConsumerStatefulWidget {
  const ResetScreen({super.key});

  @override
  ConsumerState<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends ConsumerState<ResetScreen> {
  final _pwCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _pwCtrl.addListener(() => setState(() {}));
    _confirmCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pwCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool get _mismatch =>
      _confirmCtrl.text.isNotEmpty && _pwCtrl.text != _confirmCtrl.text;

  bool get _canSubmit =>
      _pwCtrl.text.isNotEmpty &&
      _confirmCtrl.text.isNotEmpty &&
      _pwCtrl.text == _confirmCtrl.text;

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(newPassword: _pwCtrl.text);
      if (mounted) context.go(Routes.onboardingLogin);
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
      title: 'Nouveau mot de passe',
      subtitle: 'Choisissez un mot de passe sûr et facile à retenir.',
      onBack: () => context.go(Routes.onboardingForgot),
      children: [
        if (_error != null) ...[
          _ErrorBox(message: _error!),
          const SizedBox(height: 16),
        ],
        PwField(
          fieldKey: const Key('reset_pw1'),
          controller: _pwCtrl,
          label: 'Nouveau mot de passe',
        ),
        const SizedBox(height: 16),
        PwField(
          fieldKey: const Key('reset_pw2'),
          controller: _confirmCtrl,
          label: 'Confirmer le mot de passe',
          error: _mismatch
              ? 'Les mots de passe ne correspondent pas'
              : null,
        ),
        const SizedBox(height: 20),
        Opacity(
          opacity: _canSubmit ? 1 : 0.5,
          child: FilledButton(
            key: const Key('reset_submit'),
            onPressed: _loading || !_canSubmit ? null : _submit,
            child: _loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Réinitialiser'),
          ),
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
          style:
              const TextStyle(color: AppColors.danger, fontSize: 13.5)),
    );
  }
}
