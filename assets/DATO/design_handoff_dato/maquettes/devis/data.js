/* DATO — Données d'exemple (devis réel MILLENAIRE DECOR) */
(function () {
  const { uid } = window.DATO;
  window.DATO_DATA = {
    company: {
      name: 'MILLENAIRE DECOR',
      activity: 'MENUISERIE GÉNÉRALE',
      address: 'BP : 705 YDE',
      phones: '674 70 20 37 / 695 42 93 71',
      city: 'Yaoundé',
    },
    quote: {
      id: uid(),
      number: 'DV-2026-014',
      date: '2026-05-12',
      object: 'Fabrication de 40 chaises pour la salle de réunion des enseignants',
      client: 'Lycée Bilingue de Yaoundé',
      status: 'draft',
      sections: [
        {
          id: uid(),
          title: 'Matériel',
          lines: [
            { id: uid(), designation: 'Planches', qty: 60, pu: 6000 },
            { id: uid(), designation: 'Litres de colle', qty: 10, pu: 3000 },
            { id: uid(), designation: 'Bandes à poncer', qty: 2, pu: 24000 },
            { id: uid(), designation: 'Litres de fond-dur', qty: 30, pu: 5000 },
            { id: uid(), designation: 'Litres de diluant', qty: 60, pu: 1500 },
            { id: uid(), designation: 'Teintes', qty: 2, pu: 12000 },
            { id: uid(), designation: 'Paquets de vis', qty: 10, pu: 8000 },
            { id: uid(), designation: 'Paquets de pointe', qty: 3, pu: 4500 },
          ],
        },
      ],
      rubriques: [
        { id: uid(), label: 'Usinage', lines: [{ id: uid(), mode: 'formula', sublabel: '1500 × 40', a: 1500, b: 40 }] },
        { id: uid(), label: 'Transport', lines: [{ id: uid(), mode: 'forfait', amount: 50000 }] },
        { id: uid(), label: "Main d'œuvre", lines: [{ id: uid(), mode: 'formula', sublabel: '3000 × 40', a: 3000, b: 40 }] },
      ],
      signatures: [
        { id: uid(), label: 'Le Technicien' },
        { id: uid(), label: 'Le Client' },
      ],
      note: '',
    },
    // Bibliothèque d'articles (auto-complétion désignation)
    library: [
      { name: 'Planches', pu: 6000 },
      { name: 'Madriers', pu: 7000 },
      { name: 'Litres de colle', pu: 3000 },
      { name: 'Litres de fond-dur', pu: 5000 },
      { name: 'Litres de diluant', pu: 1500 },
      { name: 'Bandes à poncer', pu: 24000 },
      { name: 'Teintes', pu: 12000 },
      { name: 'Paquets de vis', pu: 8000 },
      { name: 'Paquets de pointe', pu: 4500 },
      { name: 'Pot de teinture', pu: 12000 },
      { name: 'Lattes', pu: 1800 },
      { name: 'Lambris (m²)', pu: 6000 },
    ],
  };
})();
