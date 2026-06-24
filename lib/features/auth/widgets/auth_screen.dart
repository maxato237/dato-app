import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dato/core/theme/app_theme.dart';

/// Mise en page commune à tous les écrans auth :
/// en-tête dégradé DATO + carte blanche scrollable en dessous.
class AuthScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final List<Widget> children;

  const AuthScreen({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B4965), Color(0xFF163D56)],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (onBack != null)
                          GestureDetector(
                            onTap: onBack,
                            child: const Padding(
                              padding: EdgeInsets.only(right: 4),
                              child: Icon(Icons.chevron_left,
                                  color: Colors.white, size: 24),
                            ),
                          )
                        else
                          SvgPicture.asset(
                            'assets/icons/dato_logo.svg',
                            width: 40,
                            height: 40,
                          ),
                        const SizedBox(width: 10),
                        const Text(
                          'DATO',
                          style: TextStyle(
                            fontFamily: 'Sora',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.bg,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(22)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
