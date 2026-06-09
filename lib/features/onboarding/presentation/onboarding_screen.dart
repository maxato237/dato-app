import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:dato/core/network/network_providers.dart';
import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/dato_text_field.dart';
import 'package:dato/features/settings/providers/company_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  final int step;
  const OnboardingScreen({super.key, required this.step});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  // Étape 1 — entreprise
  final _nameCtrl = TextEditingController();
  final _activityCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _phonesCtrl = TextEditingController();
  String _currency = 'FCFA';
  bool _savingStep1 = false;
  bool _savingStep2 = false;

  // Étape 2 — signatures
  List<TextEditingController> _sigCtrls = [];

  @override
  void initState() {
    super.initState();
    final company = ref.read(currentCompanyProvider);
    _nameCtrl.text = company.name;
    _activityCtrl.text = company.activity;
    _cityCtrl.text = company.city;
    _phonesCtrl.text = company.phones;
    _currency = company.currency;
    _sigCtrls = [
      TextEditingController(text: 'Le Technicien'),
      TextEditingController(text: 'Le Client'),
    ];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _activityCtrl.dispose();
    _cityCtrl.dispose();
    _phonesCtrl.dispose();
    for (final c in _sigCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  /// Sauvegarde l'entreprise dans le provider local ET appelle le backend.
  Future<void> _saveStep1() async {
    if (_savingStep1) return;
    setState(() => _savingStep1 = true);
    try {
      final phones = _phonesCtrl.text
          .trim()
          .split(',')
          .map((p) => p.trim())
          .where((p) => p.isNotEmpty)
          .toList();

      // Mise à jour du provider local (UI immédiate)
      ref.read(currentCompanyProvider.notifier).update(
            ref.read(currentCompanyProvider).copyWith(
                  name: _nameCtrl.text.trim(),
                  activity: _activityCtrl.text.trim(),
                  city: _cityCtrl.text.trim(),
                  phones: _phonesCtrl.text.trim(),
                  currency: _currency,
                ),
          );

      // Appel backend Flask
      await ref.read(apiClientProvider).post('/api/company', body: {
        'name': _nameCtrl.text.trim(),
        'activity': _activityCtrl.text.trim(),
        'city': _cityCtrl.text.trim(),
        'phones': phones,
        'currency': _currency,
      });

      if (mounted) context.go(Routes.onboarding2);
    } catch (_) {
      // En cas d'erreur réseau, on passe quand même (les données sont en local)
      if (mounted) context.go(Routes.onboarding2);
    } finally {
      if (mounted) setState(() => _savingStep1 = false);
    }
  }

  /// Sauvegarde les signatures côté backend.
  Future<void> _saveStep2() async {
    if (_savingStep2) return;
    setState(() => _savingStep2 = true);
    try {
      final client = ref.read(apiClientProvider);
      for (var i = 0; i < _sigCtrls.length; i++) {
        final label = _sigCtrls[i].text.trim();
        if (label.isNotEmpty) {
          await client.post('/api/company/signatures', body: {
            'label': label,
            'text': label,
            'order_index': i,
          });
        }
      }
    } catch (_) {
      // Signatures non critiques — on continue vers step 3
    } finally {
      if (mounted) {
        setState(() => _savingStep2 = false);
        context.go(Routes.onboarding3);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.step) {
      1 => _Step1(
          nameCtrl: _nameCtrl,
          activityCtrl: _activityCtrl,
          cityCtrl: _cityCtrl,
          phonesCtrl: _phonesCtrl,
          currency: _currency,
          onCurrencyChanged: (v) => setState(() => _currency = v!),
          onNext: _savingStep1 ? null : _saveStep1,
          onSkip: () => context.go(Routes.home),
        ),
      2 => _Step2(
          sigCtrls: _sigCtrls,
          onAdd: () => setState(() =>
              _sigCtrls.add(TextEditingController(text: 'Signature'))),
          onRemove: (i) => setState(() {
            _sigCtrls[i].dispose();
            _sigCtrls.removeAt(i);
          }),
          onBack: () => context.go(Routes.onboarding1),
          onNext: _savingStep2 ? null : _saveStep2,
        ),
      _ => _Step3(
          onCreateQuote: () => context.go(Routes.quoteEditorPath('new')),
          onDashboard: () => context.go(Routes.home),
        ),
    };
  }
}

// ─────────────────────────────── Composants partagés ────────────────────────

class _ObScaffold extends StatelessWidget {
  final int step;
  final Widget body;
  final Widget footer;

  const _ObScaffold({
    required this.step,
    required this.body,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(3, (i) {
                          final done = i + 1 < step;
                          final active = i + 1 == step;
                          return Expanded(
                            child: Container(
                              height: 5,
                              margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                              decoration: BoxDecoration(
                                color: done
                                    ? AppColors.green
                                    : active
                                        ? AppColors.ink
                                        : AppColors.border,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Étape $step sur 3',
                            style: const TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textMuted),
                          ),
                          const Text(
                            'Configuration',
                            style: TextStyle(
                                fontSize: 12.5,
                                color: AppColors.textMuted),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: body),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: footer,
            ),
          ],
        ),
      ),
    );
  }
}

class _ObFooter extends StatelessWidget {
  final String? leftLabel;
  final VoidCallback? onLeft;
  final String rightLabel;
  final VoidCallback? onRight;
  const _ObFooter({
    this.leftLabel,
    this.onLeft,
    required this.rightLabel,
    this.onRight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(245),
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        children: [
          if (leftLabel != null) ...[
            TextButton(
              onPressed: onLeft,
              style: TextButton.styleFrom(foregroundColor: AppColors.ink),
              child: Text(leftLabel!),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: FilledButton(
              onPressed: onRight,
              child: Text(rightLabel),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── Étape 1 ────────────────────────────────────

class _Step1 extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController activityCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController phonesCtrl;
  final String currency;
  final ValueChanged<String?> onCurrencyChanged;
  final VoidCallback? onNext;
  final VoidCallback? onSkip;

  const _Step1({
    required this.nameCtrl,
    required this.activityCtrl,
    required this.cityCtrl,
    required this.phonesCtrl,
    required this.currency,
    required this.onCurrencyChanged,
    this.onNext,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return _ObScaffold(
      step: 1,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'En-tête de l\'entreprise',
              style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
            ),
            const SizedBox(height: 6),
            const Text(
              'Ces informations apparaîtront en haut de chaque devis.',
              style: TextStyle(fontSize: 14, color: AppColors.textMuted, height: 1.5),
            ),
            const SizedBox(height: 22),
            _LogoCircle(name: nameCtrl),
            const SizedBox(height: 22),
            DatoTextField(
              key: const Key('ob1_name'),
              controller: nameCtrl,
              label: 'Nom de l\'entreprise',
              hint: 'MILLENAIRE DECOR',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            DatoTextField(
              key: const Key('ob1_activity'),
              controller: activityCtrl,
              label: 'Activité',
              hint: 'Menuiserie générale',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            DatoTextField(
              key: const Key('ob1_city'),
              controller: cityCtrl,
              label: 'Ville',
              hint: 'Yaoundé',
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            DatoTextField(
              key: const Key('ob1_phones'),
              controller: phonesCtrl,
              label: 'Téléphone(s)',
              hint: '674 70 20 37',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 16),
            _CurrencyPicker(
                value: currency, onChanged: onCurrencyChanged),
          ],
        ),
      ),
      footer: _ObFooter(
        leftLabel: 'Passer',
        onLeft: onSkip,
        rightLabel: 'Suivant',
        onRight: onNext,
      ),
    );
  }
}

class _LogoCircle extends StatelessWidget {
  final TextEditingController name;
  const _LogoCircle({required this.name});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: name,
      builder: (_, __) {
        final initial = name.text.trim().isEmpty
            ? null
            : name.text.trim()[0].toUpperCase();
        return Column(
          children: [
            Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: initial != null
                      ? AppColors.ink
                      : AppColors.borderStrong,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  style: initial != null
                      ? BorderStyle.solid
                      : BorderStyle.solid,
                ),
                color: initial != null
                    ? AppColors.ink
                    : AppColors.surface,
              ),
              alignment: Alignment.center,
              child: initial != null
                  ? Text(
                      initial,
                      style: const TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w800,
                          fontSize: 34,
                          color: Colors.white),
                    )
                  : const Icon(Icons.add,
                      size: 28, color: AppColors.textMuted),
            ),
            const SizedBox(height: 10),
            Text(
              initial != null ? 'Changer le logo' : 'Ajouter votre logo',
              style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.ink,
                  fontWeight: FontWeight.w600),
            ),
          ],
        );
      },
    );
  }
}

class _CurrencyPicker extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const _CurrencyPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Devise',
          style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.text),
        ),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          key: const Key('ob1_currency'),
          // ignore: deprecated_member_use
          value: value,
          onChanged: onChanged,
          items: const [
            DropdownMenuItem(value: 'FCFA', child: Text('FCFA')),
            DropdownMenuItem(value: 'EUR', child: Text('EUR (€)')),
            DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
          ],
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              borderSide:
                  const BorderSide(color: AppColors.borderStrong, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────── Étape 2 ────────────────────────────────────

class _Step2 extends StatelessWidget {
  final List<TextEditingController> sigCtrls;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;
  final VoidCallback onBack;
  final VoidCallback? onNext;

  const _Step2({
    required this.sigCtrls,
    required this.onAdd,
    required this.onRemove,
    required this.onBack,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return _ObScaffold(
      step: 2,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Blocs de signature',
              style: TextStyle(
                  fontFamily: 'Sora',
                  fontWeight: FontWeight.w700,
                  fontSize: 22),
            ),
            const SizedBox(height: 6),
            const Text(
              'Définissez les signatures affichées en bas de vos devis. Modifiable à tout moment.',
              style: TextStyle(
                  fontSize: 14, color: AppColors.textMuted, height: 1.5),
            ),
            const SizedBox(height: 22),
            ...List.generate(sigCtrls.length, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SigItem(
                key: Key('sig_item_$i'),
                controller: sigCtrls[i],
                canRemove: sigCtrls.length > 1,
                onRemove: () => onRemove(i),
              ),
            )),
            const SizedBox(height: 4),
            OutlinedButton.icon(
              key: const Key('sig_add_btn'),
              onPressed: onAdd,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Ajouter un bloc'),
            ),
          ],
        ),
      ),
      footer: _ObFooter(
        leftLabel: 'Retour',
        onLeft: onBack,
        rightLabel: 'Suivant',
        onRight: onNext,
      ),
    );
  }
}

class _SigItem extends StatelessWidget {
  final TextEditingController controller;
  final bool canRemove;
  final VoidCallback onRemove;

  const _SigItem({
    super.key,
    required this.controller,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.borderStrong, width: 1.5),
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.draw_outlined, size: 17, color: AppColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                isDense: true,
              ),
            ),
          ),
          if (canRemove) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onRemove,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(Icons.close,
                    size: 17, color: AppColors.textMuted),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────── Étape 3 ────────────────────────────────────

class _Step3 extends StatelessWidget {
  final VoidCallback onCreateQuote;
  final VoidCallback onDashboard;

  const _Step3({required this.onCreateQuote, required this.onDashboard});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(3, (i) {
                      return Expanded(
                        child: Container(
                          height: 5,
                          margin:
                              EdgeInsets.only(right: i < 2 ? 6 : 0),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Terminé',
                          style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textMuted)),
                      Text('Configuration',
                          style: TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.green100,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.check,
                          size: 46, color: AppColors.green700),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Tout est prêt !',
                      style: TextStyle(
                          fontFamily: 'Sora',
                          fontWeight: FontWeight.w700,
                          fontSize: 22),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Votre entreprise est configurée. Créez dès maintenant votre premier devis professionnel.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                          height: 1.5),
                    ),
                    const SizedBox(height: 28),
                    FilledButton.icon(
                      key: const Key('ob3_create_quote'),
                      onPressed: onCreateQuote,
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text('Créer mon premier devis'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      key: const Key('ob3_dashboard'),
                      onPressed: onDashboard,
                      child: const Text('Aller au tableau de bord'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
