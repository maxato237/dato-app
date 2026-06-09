import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/features/auth/widgets/auth_screen.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _controllers = List.generate(6, (_) => TextEditingController());
  final _focuses = List.generate(6, (_) => FocusNode());
  Timer? _timer;
  int _seconds = 42;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
    for (final c in _controllers) {
      c.addListener(() => setState(() {}));
    }
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 42);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_seconds <= 0) {
        _timer?.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focuses) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();
  bool get _complete => _code.length == 6;

  Future<void> _verify() async {
    if (!_complete) return;
    final repo = ref.read(authRepositoryProvider);
    final phone = repo.pendingPhone ?? '';
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await repo.verifyOtp(phone: phone, token: _code);
      if (!mounted) return;
      if (repo.isResetFlow) {
        context.go(Routes.onboardingReset);
      } else {
        context.go(Routes.onboarding1);
      }
    } on Exception catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    final repo = ref.read(authRepositoryProvider);
    final phone = repo.pendingPhone ?? '';
    try {
      await repo.resendOtp(phone: phone);
      _startTimer();
    } on Exception catch (e) {
      if (mounted) setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.read(authRepositoryProvider);
    final phone = repo.pendingPhone ?? '';
    final back = repo.isResetFlow ? Routes.onboardingForgot : Routes.onboardingSignup;

    return AuthScreen(
      title: 'Vérification',
      subtitle:
          'Saisissez le code à 6 chiffres envoyé par SMS au $phone.',
      onBack: () => context.go(back),
      children: [
        if (_error != null) ...[
          _ErrorBox(message: _error!),
          const SizedBox(height: 16),
        ],
        const SizedBox(height: 8),
        _OtpRow(controllers: _controllers, focuses: _focuses),
        const SizedBox(height: 18),
        _TimerRow(seconds: _seconds, onResend: _resend),
        const SizedBox(height: 22),
        Opacity(
          opacity: _complete ? 1 : 0.5,
          child: FilledButton(
            key: const Key('otp_verify_btn'),
            onPressed: _loading || !_complete ? null : _verify,
            child: _loading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Vérifier'),
          ),
        ),
      ],
    );
  }
}

class _OtpRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focuses;

  const _OtpRow({required this.controllers, required this.focuses});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (i) {
        final filled = controllers[i].text.isNotEmpty;
        return Padding(
          padding: EdgeInsets.only(right: i < 5 ? 10 : 0),
          child: SizedBox(
            width: 46,
            height: 58,
            child: TextField(
              key: Key('otp_field_$i'),
              controller: controllers[i],
              focusNode: focuses[i],
              maxLength: 1,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              buildCounter: (_, {required currentLength,
                required isFocused, maxLength}) => null,
              onChanged: (value) {
                if (value.length == 1 && i < 5) {
                  focuses[i + 1].requestFocus();
                }
              },
              style: const TextStyle(
                fontFamily: 'Sora',
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: AppColors.ink,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: filled,
                fillColor: filled ? AppColors.ink050 : AppColors.surface,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  borderSide: BorderSide(
                    color: filled ? AppColors.ink : AppColors.borderStrong,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                  borderSide:
                      const BorderSide(color: AppColors.ink, width: 1.5),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _TimerRow extends StatelessWidget {
  final int seconds;
  final VoidCallback onResend;

  const _TimerRow({required this.seconds, required this.onResend});

  @override
  Widget build(BuildContext context) {
    if (seconds > 0) {
      final s = seconds.toString().padLeft(2, '0');
      return Text.rich(
        TextSpan(
          text: 'Renvoyer le code dans ',
          style: const TextStyle(fontSize: 13.5, color: AppColors.textMuted),
          children: [
            TextSpan(
              text: '0:$s',
              style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                  fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      );
    }
    return GestureDetector(
      onTap: onResend,
      child: const Text(
        'Renvoyer le code',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 13.5,
            color: AppColors.ink,
            fontWeight: FontWeight.w600),
      ),
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
