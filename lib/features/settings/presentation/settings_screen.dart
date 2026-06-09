import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dato/core/network/api_exception.dart';
import 'package:dato/core/network/network_providers.dart';
import 'package:dato/core/theme/app_theme.dart';
import 'package:dato/core/widgets/dato_text_field.dart';
import 'package:dato/features/settings/domain/company.dart';
import 'package:dato/features/settings/providers/company_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _nameCtrl = TextEditingController();
  final _activityCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _phonesCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  String _currency = 'FCFA';

  String _logoUrl = '';
  String _headerImageUrl = '';
  String _footerImageUrl = '';

  bool _loading = true;
  bool _saving = false;
  String? _uploadingTarget; // 'logo' | 'header' | 'footer'

  @override
  void initState() {
    super.initState();
    _hydrate(ref.read(currentCompanyProvider)); // valeurs locales immédiates
    _load(); // puis synchro backend
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _activityCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _phonesCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _hydrate(Company c) {
    _nameCtrl.text = c.name;
    _activityCtrl.text = c.activity;
    _addressCtrl.text = c.address;
    _cityCtrl.text = c.city;
    _phonesCtrl.text = c.phones;
    _locationCtrl.text = c.location;
    _currency = c.currency.isEmpty ? 'FCFA' : c.currency;
    _logoUrl = c.logoUrl;
    _headerImageUrl = c.headerImageUrl;
    _footerImageUrl = c.footerImageUrl;
  }

  Future<void> _load() async {
    try {
      final res = await ref.read(apiClientProvider).get('/api/company');
      final data = res['data'];
      if (data is Map<String, dynamic>) {
        final company = Company.fromJson(data);
        ref.read(currentCompanyProvider.notifier).update(company);
        if (mounted) setState(() => _hydrate(company));
      }
    } catch (_) {
      // Pas d'entreprise encore enregistrée (404) ou backend indisponible :
      // on garde les valeurs locales seedées.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Company _buildCompany() {
    final current = ref.read(currentCompanyProvider);
    return current.copyWith(
      name: _nameCtrl.text.trim(),
      activity: _activityCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      phones: _phonesCtrl.text.trim(),
      currency: _currency,
      location: _locationCtrl.text.trim(),
      logoUrl: _logoUrl,
      headerImageUrl: _headerImageUrl,
      footerImageUrl: _footerImageUrl,
    );
  }

  Future<void> _pickAndUpload(String target) async {
    if (_uploadingTarget != null) return;
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _uploadingTarget = target);
    try {
      final url = await ref.read(apiClientProvider).uploadImage(picked.path);
      if (!mounted) return;
      setState(() {
        switch (target) {
          case 'logo':
            _logoUrl = url;
          case 'header':
            _headerImageUrl = url;
          case 'footer':
            _footerImageUrl = url;
        }
      });
      // Mise à jour réactive immédiate du provider (aperçu/PDF reflètent le changement).
      final updated = _buildCompany();
      ref.read(currentCompanyProvider.notifier).update(updated);
      // Sauvegarde automatique en BD pour que le chemin ne soit pas perdu.
      await _autoSave(updated);
    } on ApiException catch (e) {
      _toast(e.message);
    } catch (_) {
      _toast('Échec de l\'envoi de l\'image.');
    } finally {
      if (mounted) setState(() => _uploadingTarget = null);
    }
  }

  void _clearImage(String target) {
    setState(() {
      switch (target) {
        case 'logo':
          _logoUrl = '';
        case 'header':
          _headerImageUrl = '';
        case 'footer':
          _footerImageUrl = '';
      }
    });
    // Mise à jour du provider + sauvegarde silencieuse après retrait.
    final updated = _buildCompany();
    ref.read(currentCompanyProvider.notifier).update(updated);
    _autoSave(updated);
  }

  /// Sauvegarde silencieuse (sans vérification de nom, sans toast) utilisée
  /// après chaque upload ou retrait d'image. Erreurs swallowées : l'URL est
  /// déjà dans le state local et sera renvoyée à la prochaine sauvegarde manuelle.
  Future<void> _autoSave(Company company) async {
    try {
      await ref.read(apiClientProvider).put('/api/company', body: company.toJson());
    } on ApiException catch (e) {
      if (e.statusCode == 404 && company.name.trim().isNotEmpty) {
        // Pas encore d'entreprise en BD → on la crée.
        try {
          await ref.read(apiClientProvider).post('/api/company', body: company.toJson());
        } catch (_) { /* silencieux */ }
      }
      // Autres erreurs : silencieux.
    } catch (_) { /* silencieux */ }
  }

  Future<void> _save() async {
    if (_saving) return;
    if (_nameCtrl.text.trim().isEmpty) {
      _toast('Le nom de l\'entreprise est obligatoire.');
      return;
    }
    setState(() => _saving = true);
    final company = _buildCompany();
    // MAJ locale immédiate (l'aperçu/PDF reflètent les changements tout de suite).
    ref.read(currentCompanyProvider.notifier).update(company);
    try {
      // PUT met à jour ; si aucune entreprise n'existe encore, on bascule en POST.
      try {
        await ref.read(apiClientProvider).put('/api/company', body: company.toJson());
      } on ApiException catch (e) {
        if (e.statusCode == 404) {
          await ref.read(apiClientProvider).post('/api/company', body: company.toJson());
        } else {
          rethrow;
        }
      }
      _toast('Réglages enregistrés.');
    } on ApiException catch (e) {
      _toast(e.message);
    } catch (_) {
      _toast('Enregistré localement (backend indisponible).');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Réglages'),
        actions: [
          TextButton(
            key: const Key('settings_save'),
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Enregistrer',
                    style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _section('Identité'),
                _logoUploader(),
                const SizedBox(height: 16),
                DatoTextField(
                  key: const Key('settings_name'),
                  controller: _nameCtrl,
                  label: 'Nom de l\'entreprise',
                  hint: 'MILLENAIRE DECOR',
                ),
                const SizedBox(height: 14),
                DatoTextField(
                  key: const Key('settings_activity'),
                  controller: _activityCtrl,
                  label: 'Activité',
                  hint: 'Menuiserie générale',
                ),
                const SizedBox(height: 26),
                _section('Coordonnées'),
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
                const SizedBox(height: 14),
                _currencyPicker(),
                const SizedBox(height: 26),
                _section('Document'),
                const _Hint(
                    'Image de couverture affichée en haut de chaque devis.'),
                const SizedBox(height: 10),
                _bannerUploader(
                  target: 'header',
                  label: 'Image de couverture (en-tête)',
                  url: _headerImageUrl,
                ),
                const SizedBox(height: 18),
                const _Hint(
                    'Bannière de pied de page. Uploadez une image, ou laissez '
                    'vide et renseignez la localisation ci-dessous pour un '
                    'bandeau généré automatiquement.'),
                const SizedBox(height: 10),
                _bannerUploader(
                  target: 'footer',
                  label: 'Bannière de pied de page',
                  url: _footerImageUrl,
                ),
                const SizedBox(height: 14),
                DatoTextField(
                  key: const Key('settings_location'),
                  controller: _locationCtrl,
                  label: 'Localisation (pied de page)',
                  hint: 'Situé à NKOLFOULOU (carrefour ENIET de SOA)',
                ),
              ],
            ),
    );
  }

  Widget _section(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
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
    final uploading = _uploadingTarget == 'logo';
    return Row(
      children: [
        GestureDetector(
          onTap: uploading ? null : () => _pickAndUpload('logo'),
          child: Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.borderStrong, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: uploading
                ? const CircularProgressIndicator(strokeWidth: 2)
                : _logoUrl.isNotEmpty
                    ? Image.network(_logoUrl,
                        width: 84, height: 84, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.broken_image_outlined,
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
              const Text('Logo de l\'entreprise',
                  style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(
                _logoUrl.isEmpty
                    ? 'Optionnel — sans logo, l\'en-tête n\'en affiche aucun.'
                    : 'Logo défini.',
                style: const TextStyle(fontSize: 12.5, color: AppColors.textMuted),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  TextButton(
                    key: const Key('settings_logo_pick'),
                    onPressed: uploading ? null : () => _pickAndUpload('logo'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(_logoUrl.isEmpty ? 'Ajouter' : 'Changer'),
                  ),
                  if (_logoUrl.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: () => _clearImage('logo'),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.danger,
                      ),
                      child: const Text('Retirer'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bannerUploader({
    required String target,
    required String label,
    required String url,
  }) {
    final uploading = _uploadingTarget == target;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: uploading ? null : () => _pickAndUpload(target),
          child: Container(
            height: 84,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(color: AppColors.borderStrong, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            child: uploading
                ? const CircularProgressIndicator(strokeWidth: 2)
                : url.isNotEmpty
                    ? Image.network(url,
                        width: double.infinity,
                        height: 84,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.textMuted))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_photo_alternate_outlined,
                              color: AppColors.textMuted),
                          const SizedBox(height: 4),
                          Text(label,
                              style: const TextStyle(
                                  fontSize: 12.5, color: AppColors.textMuted)),
                        ],
                      ),
          ),
        ),
        if (url.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _clearImage(target),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.danger,
              ),
              child: const Text('Retirer'),
            ),
          ),
      ],
    );
  }
}

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
