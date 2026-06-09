/* DATO — Jeu de devis pour le tableau de bord & la liste */
(function () {
  window.DATO_QUOTES = [
    { id: 'q14', number: 'DV-2026-014', object: 'Fabrication de 40 chaises — salle de réunion', client: 'Lycée Bilingue de Yaoundé', date: '2026-05-12', status: 'sent', total: 1025500 },
    { id: 'q13', number: 'DV-2026-013', object: 'Fourniture de madriers et planches Talli/Azobé', client: 'Coopérative La Longue Caniche', date: '2026-05-11', status: 'accepted', total: 18630000 },
    { id: 'q12', number: 'DV-2026-012', object: 'Achat parquet & pose — Hôtel de l\u2019Œil d\u2019Aigle', client: 'Œil d\u2019Aigle Village Africain', date: '2026-05-04', status: 'accepted', total: 1805000 },
    { id: 'q11', number: 'DV-2026-011', object: 'Rénovation du comptoir de bar', client: 'Restaurant Le Palmier', date: '2026-04-28', status: 'refused', total: 640000 },
    { id: 'q10', number: 'DV-2026-010', object: 'Placards de chambre sur mesure', client: 'Mme Atangana', date: '2026-04-25', status: 'draft', total: 480000 },
    { id: 'q09', number: 'DV-2026-009', object: 'Portes intérieures en bois massif (×6)', client: 'Villa Bastos', date: '2026-04-20', status: 'sent', total: 1350000 },
  ];
  window.DATO_STATUS = {
    draft: { label: 'Brouillon', cls: 'b-draft' },
    sent: { label: 'Envoyé', cls: 'b-sent' },
    accepted: { label: 'Accepté', cls: 'b-accepted' },
    refused: { label: 'Refusé', cls: 'b-refused' },
  };
})();
