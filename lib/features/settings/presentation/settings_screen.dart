import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dato/core/network/network_providers.dart';
import 'package:dato/core/router/routes.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/app_network_image.dart';
import 'package:dato/core/widgets/dato_text_field.dart';
import 'package:dato/features/auth/providers/auth_provider.dart';
import 'package:dato/features/settings/domain/company.dart';
import 'package:dato/features/settings/providers/company_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  // ── Entreprise ────────────────────────────────────────────────────────────
  final _nameCtrl     = TextEditingController();
  final _activityCtrl = TextEditingController();
  final _addressCtrl  = TextEditingController();
  final _cityCtrl     = TextEditingController();
  final _phonesCtrl   = TextEditingController();
  String _currency         = 'FCFA';
  String _logoUrl          = '';
  String _templateDocxUrl  = '';
  String? _nameErr;
  // Aperçu local d'un logo capturé hors-ligne, en attente d'upload.
  String _pendingLogoPath  = '';

  // ── Signatures ────────────────────────────────────────────────────────────
  final _sigLeftCtrl  = TextEditingController();
  final _sigRightCtrl = TextEditingController();

  // ── Numérotation ──────────────────────────────────────────────────────────
  final _prefixCtrl = TextEditingController();
  bool _numberByObject = false;

  // ── Préférences ───────────────────────────────────────────────────────────
  final _locationCtrl = TextEditingController();

  bool _loading           = true;
  bool _saving            = false;
  bool _uploadingLogo     = false;
  bool _uploadingTemplate = false;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 5, vsync: this)
      ..addListener(() => setState(() {}));
    _hydrate(ref.read(currentCompanyProvider));
    _load();
  }

  @override
  void dispose() {
    _tab.dispose();
    _nameCtrl.dispose();
    _activityCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _phonesCtrl.dispose();
    _sigLeftCtrl.dispose();
    _sigRightCtrl.dispose();
    _prefixCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _hydrate(Company c) {
    _nameCtrl.text     = c.name;
    _activityCtrl.text = c.activity;
    _addressCtrl.text  = c.address;
    _cityCtrl.text     = c.city;
    _phonesCtrl.text   = c.phones;
    _currency          = c.currency.isEmpty ? 'FCFA' : c.currency;
    _logoUrl           = c.logoUrl;
    _templateDocxUrl   = c.templateDocxUrl;
    _sigLeftCtrl.text  = c.signatureLeft;
    _sigRightCtrl.text = c.signatureRight;
    _prefixCtrl.text   = c.quotePrefix;
    _numberByObject    = c.quoteNumberByObject;
    _locationCtrl.text = c.location;
  }

  Future<void> _load() async {
    try {
      final res = await ref.read(apiClientProvider).get('/api/company');
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        final company = Company.fromJson(data);
        // Pull serveur : ne pas re-marquer « à synchroniser ».
        ref.read(currentCompanyProvider.notifier).update(company, markDirty: false);
        if (mounted) setState(() => _hydrate(company));
      }
    } catch (_) {
      // 404 ou backend indisponible : valeurs locales.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Company _buildCompany() {
    final current = ref.read(currentCompanyProvider);
    final prefix = _prefixCtrl.text.trim().toUpperCase();
    return current.copyWith(
      name:           _nameCtrl.text.trim(),
      activity:       _activityCtrl.text.trim(),
      address:        _addressCtrl.text.trim(),
      city:           _cityCtrl.text.trim(),
      phones:         _phonesCtrl.text.trim(),
      currency:       _currency,
      logoUrl:        _logoUrl,
      templateDocxUrl: _templateDocxUrl,
      // On enregistre exactement ce que l'utilisateur a saisi (pas de valeur
      // par défaut imposée) ; les placeholders guident la saisie.
      signatureLeft:  _sigLeftCtrl.text.trim(),
      signatureRight: _sigRightCtrl.text.trim(),
      quotePrefix:    prefix.isEmpty ? 'DV' : prefix,
      quoteNumberByObject: _numberByObject,
      location:       _locationCtrl.text.trim(),
    );
  }

  // ── Logo ──────────────────────────────────────────────────────────────────

  Future<void> _pickLogo() async {
    if (_uploadingLogo) return;
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery, maxWidth: 2000, imageQuality: 85);
    if (picked == null) return;

    final previousUrl = _logoUrl;
    setState(() => _uploadingLogo = true);
    try {
      final url = await ref.read(apiClientProvider).uploadImage(picked.path);
      if (!mounted) return;
      setState(() {
        _logoUrl = url;
        _pendingLogoPath = '';
      });
      // Persiste + déclenche la sync (offline-first).
      ref.read(currentCompanyProvider.notifier).update(_buildCompany());
      // Supprime l'ancien logo côté Cloudinary (best-effort).
      if (previousUrl.isNotEmpty && previousUrl != url) {
        await ref.read(apiClientProvider).deleteImage(previousUrl);
      }
    } catch (_) {
      // Hors-ligne : on garde l'image localement et on l'enverra plus tard.
      if (!mounted) return;
      setState(() => _pendingLogoPath = picked.path);
      ref.read(currentCompanyProvider.notifier).queuePendingLogo(
            picked.path,
            previousRemoteUrl: previousUrl,
          );
      _toast('Logo enregistré — envoi au prochain retour réseau.');
    } finally {
      if (mounted) setState(() => _uploadingLogo = false);
    }
  }

  void _clearLogo() {
    final previousUrl = _logoUrl;
    setState(() {
      _logoUrl = '';
      _pendingLogoPath = '';
    });
    ref.read(currentCompanyProvider.notifier).update(_buildCompany());
    if (previousUrl.isNotEmpty) {
      ref.read(apiClientProvider).deleteImage(previousUrl);
    }
  }

  // ── Modèle Word ───────────────────────────────────────────────────────────

  Future<void> _pickTemplate() async {
    if (_uploadingTemplate) return;
    final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx'],
        allowMultiple: false);
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;

    setState(() => _uploadingTemplate = true);
    try {
      final url = await ref.read(apiClientProvider).uploadTemplate(path);
      if (!mounted) return;
      setState(() => _templateDocxUrl = url);
      ref.read(currentCompanyProvider.notifier).update(_buildCompany());
      _toast('Modèle Word importé avec succès.');
    } catch (_) {
      // Stockage distant indisponible (réseau / Supabase) : on conserve le
      // fichier en attente et on réessaiera automatiquement plus tard.
      if (!mounted) return;
      ref.read(currentCompanyProvider.notifier).queuePendingTemplate(path);
      _toast('Modèle enregistré — envoi dès que le stockage sera disponible.');
    } finally {
      if (mounted) setState(() => _uploadingTemplate = false);
    }
  }

  Future<void> _clearTemplate() async {
    try {
      await ref.read(apiClientProvider).deleteTemplate();
    } catch (_) {}
    setState(() => _templateDocxUrl = '');
    ref.read(currentCompanyProvider.notifier).update(_buildCompany());
  }

  // ── Sauvegarde ────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (_saving) return;
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _nameErr = "Le nom de l'entreprise est obligatoire.");
      // Bascule sur l'onglet Entreprise pour montrer le champ en erreur.
      if (_tab.index != 0) _tab.animateTo(0);
      return;
    }
    setState(() {
      _saving = true;
      _nameErr = null;
    });
    // Offline-first : on persiste localement et la sync pousse au backend
    // dès que possible (immédiatement si en ligne).
    ref.read(currentCompanyProvider.notifier).update(_buildCompany());
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (mounted) {
      setState(() => _saving = false);
      _toast('Réglages enregistrés.');
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final onCompteTab = _tab.index == 3;
    return Scaffold(
      backgroundColor: AppColors.bg,
      // On gère nous-mêmes l'inset clavier via le padding de `_scrollPad`
      // (sinon double décompte = grand bloc blanc impossible à scroller).
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Réglages'),
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 13.5),
          tabs: const [
            Tab(text: 'Entreprise'),
            Tab(text: 'Signatures'),
            Tab(text: 'Numérotation'),
            Tab(text: 'Compte'),
            Tab(text: 'Préférences'),
          ],
        ),
        actions: [
          if (!onCompteTab)
            TextButton(
              key: const Key('settings_save'),
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Enregistrer',
                      style: TextStyle(fontWeight: FontWeight.w700)),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tab,
              children: [
                // ── Onglet 0 : Entreprise ────────────────────────────────
                _scrollPad(Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionLabel('Identité'),
                    _logoUploader(),
                    const SizedBox(height: 16),
                    DatoTextField(
                      key: const Key('settings_name'),
                      controller: _nameCtrl,
                      label: "Nom de l'entreprise",
                      hint: 'MILLENAIRE DECOR',
                      error: _nameErr,
                      onChanged: (_) {
                        if (_nameErr != null) setState(() => _nameErr = null);
                      },
                    ),
                    const SizedBox(height: 14),
                    DatoTextField(
                      key: const Key('settings_activity'),
                      controller: _activityCtrl,
                      label: 'Activité',
                      hint: 'Menuiserie générale',
                    ),
                    const SizedBox(height: 26),
                    _sectionLabel('Coordonnées'),
                    DatoTextField(
                      key: const Key('settings_address'),
                      controller: _addressCtrl,
                      label: 'Adresse',
                      hint: 'BP : 705 YDE',
                    ),
                    const SizedBox(height: 14),
                    DatoTextField(
                      key: const Key('settings_city'),
                      controller: _cityCtrl,
                      label: 'Ville',
                      hint: 'Yaoundé',
                    ),
                    const SizedBox(height: 14),
                    DatoTextField(
                      key: const Key('settings_phones'),
                      controller: _phonesCtrl,
                      label: 'Téléphone(s)',
                      hint: '674 70 20 37 / 695 42 93 71',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 26),
                    _sectionLabel('Document Word'),
                    const _Hint(
                      'Importez votre modèle Word (.docx) pour que les PDF '
                      'reprennent votre en-tête et pied de page. '
                      'Seul le tableau des articles sera remplacé.',
                    ),
                    const SizedBox(height: 12),
                    _templateUploader(),
                  ],
                )),

                // ── Onglet 1 : Signatures ────────────────────────────────
                _scrollPad(Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionLabel('Étiquettes de signature'),
                    const _Hint(
                      'Ces libellés apparaissent en bas du devis, '
                      'à gauche et à droite.',
                    ),
                    const SizedBox(height: 16),
                    DatoTextField(
                      key: const Key('settings_sig_left'),
                      controller: _sigLeftCtrl,
                      label: 'Signature gauche',
                      hint: 'Le Client :',
                    ),
                    const SizedBox(height: 14),
                    DatoTextField(
                      key: const Key('settings_sig_right'),
                      controller: _sigRightCtrl,
                      label: 'Signature droite',
                      hint: 'Le Prestataire :',
                    ),
                    const SizedBox(height: 24),
                    _sectionLabel('Aperçu'),
                    _SignaturePreview(
                      left: _sigLeftCtrl.text.trim().isEmpty
                          ? 'Le Client :'
                          : _sigLeftCtrl.text.trim(),
                      right: _sigRightCtrl.text.trim().isEmpty
                          ? 'Le Prestataire :'
                          : _sigRightCtrl.text.trim(),
                    ),
                  ],
                )),

                // ── Onglet 2 : Numérotation ──────────────────────────────
                _scrollPad(Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionLabel('Préfixe du numéro de devis'),
                    _Hint(
                      _numberByObject
                          ? 'Le numéro généré sera de la forme : '
                              'PRÉFIXE-OBJET.\nEx. DV-Réfection toiture'
                          : 'Le numéro généré sera de la forme : '
                              'PRÉFIXE-ANNÉE-SÉQUENCE.\nEx. DV-2026-001',
                    ),
                    const SizedBox(height: 16),
                    DatoTextField(
                      key: const Key('settings_prefix'),
                      controller: _prefixCtrl,
                      label: 'Préfixe',
                      hint: 'DV',
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 8),
                    CheckboxListTile(
                      key: const Key('settings_number_by_object'),
                      value: _numberByObject,
                      onChanged: (v) =>
                          setState(() => _numberByObject = v ?? false),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      title: const Text(
                        "Utiliser l'objet du devis après le préfixe",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        "L'objet du devis remplace l'année et la séquence, "
                        'juste après le préfixe.',
                        style: TextStyle(
                            fontSize: 12.5, color: AppColors.textMuted),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _sectionLabel('Aperçu'),
                    _NumberPreview(
                      prefix: _prefixCtrl.text.trim().isEmpty
                          ? 'DV'
                          : _prefixCtrl.text.trim().toUpperCase(),
                      byObject: _numberByObject,
                    ),
                  ],
                )),

                // ── Onglet 3 : Compte ────────────────────────────────────
                _scrollPad(_CompteTabContent(ref: ref, context: context)),

                // ── Onglet 4 : Préférences ───────────────────────────────
                _scrollPad(Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionLabel('Devise'),
                    _currencyPicker(),
                    const SizedBox(height: 26),
                    _sectionLabel('Pied de page'),
                    DatoTextField(
                      key: const Key('settings_location'),
                      controller: _locationCtrl,
                      label: 'Localisation',
                      hint: 'Situé à NKOLFOULOU (carrefour ENIET de SOA)',
                      maxLines: 2,
                    ),
                  ],
                )),
              ],
            ),
    );
  }

  // ── Helpers de mise en page ───────────────────────────────────────────────

  Widget _scrollPad(Widget child) => SingleChildScrollView(
        // Ajoute l'inset clavier au padding bas pour que le champ focalisé
        // puisse remonter au-dessus du clavier (sinon « grand bloc blanc »
        // impossible à scroller en onglet Préférences).
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, 40 + MediaQuery.viewInsetsOf(context).bottom),
        child: child,
      );

  Widget _sectionLabel(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: AppColors.textMuted,
          ),
        ),
      );

  Widget _currencyPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Devise',
            style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.text)),
        const SizedBox(height: 7),
        DropdownButtonFormField<String>(
          key: const Key('settings_currency'),
          initialValue: _currency,
          onChanged: (v) => setState(() => _currency = v ?? 'FCFA'),
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

  Widget _logoUploader() {
    return Row(
      children: [
        GestureDetector(
          onTap: _uploadingLogo ? null : _pickLogo,
          child: Container(
            width: 84, height: 84,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderStrong, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: _uploadingLogo
                ? const CircularProgressIndicator(strokeWidth: 2)
                : _pendingLogoPath.isNotEmpty
                    ? Image.file(File(_pendingLogoPath),
                        width: 84, height: 84, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.textMuted))
                    : _logoUrl.isNotEmpty
                        ? AppNetworkImage(_logoUrl,
                            width: 84, height: 84, fit: BoxFit.cover,
                            errorBuilder: (_) => const Icon(
                                Icons.broken_image_outlined,
                                color: AppColors.textMuted))
                        : const Icon(Icons.add_a_photo_outlined,
                            color: AppColors.textMuted, size: 26),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Logo de l'entreprise",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                _logoUrl.isEmpty
                    ? "Optionnel — sans logo, l'en-tête n'en affiche aucun."
                    : 'Logo défini.',
                style: const TextStyle(
                    fontSize: 12.5, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              Row(children: [
                TextButton(
                  key: const Key('settings_logo_pick'),
                  onPressed: _uploadingLogo ? null : _pickLogo,
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  child: Text(_logoUrl.isEmpty ? 'Ajouter' : 'Changer'),
                ),
                if (_logoUrl.isNotEmpty) ...[
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _clearLogo,
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.danger),
                    child: const Text('Retirer'),
                  ),
                ],
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _templateUploader() {
    final hasTemplate = _templateDocxUrl.isNotEmpty;
    final fileName = hasTemplate
        ? _templateDocxUrl.split('/').last.split('?').first
        : null;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(
          color: hasTemplate ? AppColors.ink : AppColors.borderStrong,
          width: hasTemplate ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: hasTemplate
                  ? AppColors.ink.withValues(alpha: 0.08)
                  : AppColors.bg,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: _uploadingTemplate
                ? const SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(
                    hasTemplate
                        ? Icons.description_outlined
                        : Icons.upload_file_outlined,
                    color: hasTemplate ? AppColors.ink : AppColors.textMuted,
                    size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasTemplate ? 'Modèle Word importé' : 'Aucun modèle Word',
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: hasTemplate ? AppColors.ink : AppColors.text),
                ),
                const SizedBox(height: 2),
                Text(
                  hasTemplate
                      ? (fileName ?? 'template.docx')
                      : 'Fichiers acceptés : .doc et .docx uniquement',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (hasTemplate)
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppColors.danger, size: 20),
              tooltip: 'Retirer le modèle',
              onPressed: _uploadingTemplate ? null : _clearTemplate,
            )
          else
            TextButton(
              key: const Key('settings_template_pick'),
              onPressed: _uploadingTemplate ? null : _pickTemplate,
              style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
              child: const Text('Importer'),
            ),
        ],
      ),
    );
  }
}

// ── Widgets de prévisualisation ──────────────────────────────────────────────

class _SignaturePreview extends StatelessWidget {
  const _SignaturePreview({required this.left, required this.right});

  final String left;
  final String right;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(left,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 28),
                Container(height: 1, color: AppColors.borderStrong),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(right,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 28),
                Container(height: 1, color: AppColors.borderStrong),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberPreview extends StatelessWidget {
  const _NumberPreview({required this.prefix, this.byObject = false});

  final String prefix;
  final bool byObject;

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    final example =
        byObject ? '$prefix-Réfection toiture' : '$prefix-$year-001';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.ink.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.ink.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.tag, size: 18, color: AppColors.ink),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              example,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                  letterSpacing: 0.5),
            ),
          ),
          const SizedBox(width: 10),
          const Text('prochain devis',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
        ],
      ),
    );
  }
}

// ── Onglet Compte ────────────────────────────────────────────────────────────

class _CompteTabContent extends StatelessWidget {
  const _CompteTabContent({required this.ref, required this.context});

  final WidgetRef ref;
  final BuildContext context;

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Se déconnecter ?'),
        content: const Text(
            'Vos devis restent enregistrés localement. '
            'Vous pourrez vous reconnecter à tout moment.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            child: const Text('Se déconnecter'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(authRepositoryProvider).signOut();
  }

  @override
  Widget build(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Déconnexion ──────────────────────────────────────────────────
        _SettingRow(
          icon: Icons.logout,
          iconColor: AppColors.danger,
          label: 'Se déconnecter',
          onTap: _logout,
          danger: true,
        ),
        const Divider(height: 1),

        // ── Page légale ──────────────────────────────────────────────────
        _SettingRow(
          icon: Icons.article_outlined,
          label: 'Mentions légales',
          onTap: () => context.push(Routes.legal),
        ),
        const Divider(height: 1),

        const SizedBox(height: 32),
        const Center(
          child: Text(
            'DATO v1.0.0',
            style: TextStyle(
                fontSize: 12, color: AppColors.textLight),
          ),
        ),
      ],
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.danger : AppColors.text;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: iconColor ?? color),
            const SizedBox(width: 14),
            Text(label, style: TextStyle(fontSize: 14.5, color: color)),
            const Spacer(),
            const Icon(Icons.chevron_right, size: 18, color: AppColors.textLight),
          ],
        ),
      ),
    );
  }
}

// ── Utilitaires communs ───────────────────────────────────────────────────────

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 12.5, color: AppColors.textMuted, height: 1.4));
  }
}
