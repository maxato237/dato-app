import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/router/routes.dart';

/// Écran de démarrage DATO 
/// Après [_kSplashDuration], navigue vers l'accueil ; le router redirige
/// ensuite vers la connexion ou le tableau de bord selon la session.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

const _kSplashDuration = Duration(milliseconds: 3500);

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
    )..repeat(reverse: true);
    _timer = Timer(_kSplashDuration, () {
      if (mounted) context.go(Routes.home);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1F5274), Color(0xFF1B4965), Color(0xFF143850)],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 1.04).animate(
                      CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/dato_logo.svg',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    'DEVIS PAR ATO',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.5,
                      color: Color(0xFFF4A300),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'DATO',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      height: 1,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Devis professionnels en 3 minutes,\npartagés sur WhatsApp.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        height: 1.6,
                        color: Color(0xDDFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 56,
              left: 0,
              right: 0,
              child: _LoaderDots(controller: _pulse),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoaderDots extends StatelessWidget {
  const _LoaderDots({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Padding(
          padding: EdgeInsets.only(right: i < 2 ? 7 : 0),
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              final t = (controller.value + i * 0.18) % 1.0;
              final opacity = 0.3 + 0.7 * (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0);
              return Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: opacity),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
