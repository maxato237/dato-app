import 'package:flutter/material.dart';
import 'package:dato/core/theme/app_theme.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(title: const Text('Mentions légales')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
        children: const [
          _Section('Éditeur de l\'application'),
          _Body(
            'DATO est une application mobile de génération de devis '
            'pour artisans et prestataires d\'Afrique francophone.\n\n'
            'Développé par l\'équipe DATO — Cameroun.',
          ),
          SizedBox(height: 24),
          _Section('Données personnelles'),
          _Body(
            'DATO collecte uniquement les données nécessaires au '
            'fonctionnement du service : numéro de téléphone ou '
            'adresse e-mail (authentification), et les informations '
            'de votre entreprise (nom, adresse, logo).\n\n'
            'Vos devis sont stockés localement sur votre appareil. '
            'Lorsque vous activez la synchronisation cloud, ils sont '
            'chiffrés en transit (HTTPS) et stockés sur nos serveurs '
            'sécurisés.\n\n'
            'Nous ne vendons ni ne partageons vos données avec des tiers.',
          ),
          SizedBox(height: 24),
          _Section('Responsabilité'),
          _Body(
            'DATO est fourni « tel quel », sans garantie d\'exactitude '
            'des calculs à des fins fiscales ou comptables. '
            'L\'utilisateur est seul responsable des devis qu\'il émet.',
          ),
          SizedBox(height: 24),
          _Section('Contact'),
          _Body(
            'Pour toute question relative à vos données ou à '
            'l\'application, contactez-nous :\n'
            'nkengatomaxime2@gmail.com',
          ),
          SizedBox(height: 24),
          _Section('Version'),
          _Body('DATO v1.0.0 — © 2026 DATO. Tous droits réservés.'),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.text),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 13.5, color: AppColors.textMuted, height: 1.55),
    );
  }
}
