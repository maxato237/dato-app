/* ============================================================
   DATO — Document de devis (rendu type PDF)
   Réutilisé par l'Aperçu et la Vue publique. Crédible en N&B.
   ============================================================ */
const FR_MONTHS = ['janvier','février','mars','avril','mai','juin','juillet','août','septembre','octobre','novembre','décembre'];
function dateFr(iso) {
  const d = new Date(iso + 'T00:00:00');
  return `${d.getDate()} ${FR_MONTHS[d.getMonth()]} ${d.getFullYear()}`;
}

function DevisDocument({ company, quote, compact = false }) {
  const D = window.DATO;
  const total = D.grandTotal(quote);
  const fs = compact ? 0.92 : 1;

  const cell = { padding: '7px 10px', borderRight: '1px solid #c9d2dc', fontSize: 13 * fs };
  const numCell = { ...cell, textAlign: 'right', fontVariantNumeric: 'tabular-nums', width: '22%' };
  const headCell = { ...cell, fontFamily: 'var(--font-head)', fontWeight: 700, fontSize: 12 * fs, textTransform: 'uppercase', letterSpacing: '.4px', background: '#e7eef3', color: '#1B4965', borderBottom: '1px solid #c9d2dc', textAlign: 'center' };

  return (
    <div className="doc" style={{ background: '#fff', color: '#101828', fontFamily: 'var(--font-body)', padding: compact ? '22px 20px' : '34px 30px' }}>
      {/* En-tête entreprise */}
      <div style={{ border: '2px solid #1B4965', borderRadius: 6, padding: '14px 16px', display: 'flex', gap: 14, alignItems: 'center' }}>
        <div style={{ width: 52, height: 52, borderRadius: 8, background: '#1B4965', color: '#fff', display: 'grid', placeItems: 'center', fontFamily: 'var(--font-head)', fontWeight: 800, fontSize: 22, flex: 'none' }}>
          {company.name.charAt(0)}
        </div>
        <div style={{ flex: 1, textAlign: 'center' }}>
          <div style={{ fontFamily: 'var(--font-head)', fontWeight: 800, fontSize: 22 * fs, color: '#1B4965', letterSpacing: '.5px', lineHeight: 1.1 }}>{company.name}</div>
          <div style={{ fontFamily: 'var(--font-head)', fontWeight: 600, fontSize: 13 * fs, color: '#101828', marginTop: 2 }}>{company.activity}</div>
          <div style={{ fontSize: 11 * fs, color: '#475467', marginTop: 3 }}>{company.address} — Tél : {company.phones}</div>
        </div>
      </div>

      {/* Date */}
      <div style={{ textAlign: 'right', fontSize: 13 * fs, marginTop: 18 }}>
        {company.city}, le <span style={{ textDecoration: 'underline' }}>{dateFr(quote.date)}</span>
      </div>

      {/* Objet */}
      <div style={{ textAlign: 'center', fontWeight: 700, fontFamily: 'var(--font-head)', fontSize: 14 * fs, textTransform: 'uppercase', textDecoration: 'underline', margin: '14px auto 16px', maxWidth: '88%', lineHeight: 1.35 }}>
        Devis estimatif quantitatif pour {quote.object.toLowerCase()}
      </div>

      {/* DOIT */}
      <div style={{ fontWeight: 700, fontSize: 13 * fs, marginBottom: 14 }}>
        <span style={{ textDecoration: 'underline' }}>DOIT</span> : {quote.client}
      </div>

      {/* Tableau */}
      <table style={{ width: '100%', borderCollapse: 'collapse', border: '1px solid #c9d2dc', tableLayout: 'fixed' }}>
        <thead>
          <tr>
            <th style={{ ...headCell }}>Désignation</th>
            <th style={{ ...headCell, width: '12%' }}>Qté</th>
            <th style={{ ...headCell, width: '20%' }}>P.U</th>
            <th style={{ ...headCell, width: '22%', borderRight: 0 }}>P.T</th>
          </tr>
        </thead>
        <tbody>
          {quote.sections.map((sec) => {
            const sub = D.sectionTotal(sec);
            const subLabel = /total/i.test(sec.title) ? sec.title.toUpperCase() : `Total ${sec.title}`.toUpperCase();
            return (
              <React.Fragment key={sec.id}>
                {sec.lines.map((l) => (
                  <tr key={l.id} style={{ borderBottom: '1px solid #e3e8ee' }}>
                    <td style={cell}>{l.designation}</td>
                    <td style={{ ...cell, textAlign: 'center', width: '12%', fontVariantNumeric: 'tabular-nums' }}>{l.qty}</td>
                    <td style={{ ...numCell, width: '20%' }}>{D.formatMoney(l.pu)}</td>
                    <td style={{ ...numCell, borderRight: 0 }}>{D.formatMoney((Number(l.qty) || 0) * (Number(l.pu) || 0))}</td>
                  </tr>
                ))}
                <tr style={{ background: '#eef3ee', fontWeight: 700 }}>
                  <td style={{ ...cell, borderRight: 0 }} colSpan={3}>{subLabel}</td>
                  <td style={{ ...numCell, borderRight: 0 }}>{D.formatMoney(sub)}</td>
                </tr>
              </React.Fragment>
            );
          })}

          {/* Rubriques libres */}
          {quote.rubriques.map((rub) => {
            const rt = D.rubriqueTotal(rub);
            if (rub.lines.length <= 1) {
              const l = rub.lines[0] || {};
              const label = rub.label + (l.mode === 'formula' && l.sublabel ? ` — ${l.sublabel}` : '');
              return (
                <tr key={rub.id} style={{ background: '#eef3ee', fontWeight: 700 }}>
                  <td style={{ ...cell, borderRight: 0, textTransform: 'uppercase', letterSpacing: '.3px' }} colSpan={3}>{label}</td>
                  <td style={{ ...numCell, borderRight: 0 }}>{D.formatMoney(rt)}</td>
                </tr>
              );
            }
            return (
              <React.Fragment key={rub.id}>
                {rub.lines.map((l, i) => (
                  <tr key={l.id} style={{ background: '#eef3ee', fontWeight: 700 }}>
                    {i === 0 && (
                      <td style={{ ...cell, textTransform: 'uppercase', letterSpacing: '.3px', verticalAlign: 'middle' }} rowSpan={rub.lines.length}>{rub.label}</td>
                    )}
                    <td style={{ ...cell, borderRight: 0 }} colSpan={2}>{l.sublabel || (l.mode === 'forfait' ? 'Forfait' : `${l.a} × ${l.b}`)}</td>
                    <td style={{ ...numCell, borderRight: 0 }}>{D.formatMoney(D.rubriqueLineTotal(l))}</td>
                  </tr>
                ))}
              </React.Fragment>
            );
          })}

          {/* Total général */}
          <tr style={{ background: '#1B4965', color: '#fff', fontWeight: 800 }}>
            <td style={{ ...cell, borderRight: 0, fontFamily: 'var(--font-head)', textTransform: 'uppercase', letterSpacing: '.5px' }} colSpan={3}>Total général</td>
            <td style={{ ...numCell, borderRight: 0, fontFamily: 'var(--font-head)', fontSize: 14 * fs }}>{D.formatMoney(total)}</td>
          </tr>
        </tbody>
      </table>

      {/* Montant en lettres */}
      <div style={{ fontStyle: 'italic', fontSize: 13 * fs, marginTop: 16, lineHeight: 1.5 }}>
        Arrêté le présent devis à la somme de <b>{D.montantEnLettres(total)}</b>.
      </div>

      {quote.note ? (
        <div style={{ fontSize: 12 * fs, marginTop: 12, color: '#475467' }}><b>NB :</b> {quote.note}</div>
      ) : null}

      {/* Signatures */}
      <div style={{ display: 'flex', justifyContent: 'space-around', gap: 16, marginTop: 34 }}>
        {quote.signatures.map((s) => (
          <div key={s.id} style={{ textAlign: 'center', flex: 1 }}>
            <div style={{ fontWeight: 600, fontSize: 13 * fs, marginBottom: 40 }}>{s.label}</div>
            <div style={{ borderTop: '1px dotted #98a2b3', paddingTop: 4, fontSize: 10 * fs, color: '#98a2b3' }}>Signature</div>
          </div>
        ))}
      </div>
    </div>
  );
}
window.DevisDocument = DevisDocument;
window.dateFr = dateFr;
