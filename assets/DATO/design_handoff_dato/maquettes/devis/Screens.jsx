/* ============================================================
   DATO — Écrans Aperçu, Vue publique, Bottom sheet Partager
   ============================================================ */

/* ---- Aperçu (prévisualisation avant envoi) ---- */
function Preview({ company, quote, onBack, onShare, onToast }) {
  return (
    <div className="app-scroll" style={{ background: '#eceff3' }}>
      <div className="ed-header">
        <button className="iconbtn" onClick={onBack} aria-label="Retour"><Ic name="chevron-l" size={24} /></button>
        <div className="ed-title"><div className="t">Aperçu du devis</div><div className="ed-save">Rendu final avant envoi</div></div>
        <button className="iconbtn bordered" onClick={onShare} aria-label="Partager"><Ic name="share" size={19} /></button>
      </div>
      <div style={{ padding: '16px 12px 120px' }}>
        <div style={{ borderRadius: 12, overflow: 'hidden', boxShadow: 'var(--sh-4)', border: '1px solid #d7dde4' }}>
          <DevisDocument company={company} quote={quote} compact />
        </div>
        <div style={{ textAlign: 'center', color: 'var(--text-3)', fontSize: 12, marginTop: 12 }}>Page 1 / 1 · Format A4</div>
      </div>
      <div className="actionbar">
        <button className="btn btn-secondary btn-grow" onClick={() => onToast('Téléchargement du PDF…', 'download')}><Ic name="download" size={19} /> PDF</button>
        <button className="btn btn-wa btn-grow" onClick={onShare}><Ic name="whatsapp" size={19} /> Partager</button>
      </div>
    </div>
  );
}

/* ---- Vue publique (lien WhatsApp, SANS connexion — vitrine de l'artisan) ---- */
function PublicView({ company, quote, onToast }) {
  const D = window.DATO;
  return (
    <div className="app-scroll" style={{ background: '#eceff3' }}>
      {/* Bandeau public léger */}
      <div style={{ background: 'var(--ink)', color: '#fff', padding: '12px 16px', display: 'flex', alignItems: 'center', gap: 10 }}>
        <div style={{ width: 30, height: 30, borderRadius: 8, background: 'rgba(255,255,255,.16)', display: 'grid', placeItems: 'center', fontFamily: 'var(--font-head)', fontWeight: 800, fontSize: 15 }}>D</div>
        <div style={{ flex: 1 }}>
          <div style={{ fontFamily: 'var(--font-head)', fontWeight: 700, fontSize: 14 }}>Devis de {company.name}</div>
          <div style={{ fontSize: 11.5, opacity: .8 }}>Document partagé · sécurisé</div>
        </div>
        <span style={{ display: 'inline-flex', alignItems: 'center', gap: 5, fontSize: 11, background: 'rgba(43,168,74,.25)', color: '#bff0c9', padding: '4px 9px', borderRadius: 999 }}><Ic name="check-circle" size={13} /> Officiel</span>
      </div>

      <div style={{ padding: '14px 12px 130px' }}>
        <div style={{ background: '#fff', borderRadius: 12, padding: '14px 16px', boxShadow: 'var(--sh-2)', marginBottom: 12 }}>
          <div style={{ fontSize: 13, color: 'var(--text-2)' }}>Bonjour, voici votre devis pour&nbsp;:</div>
          <div style={{ fontFamily: 'var(--font-head)', fontWeight: 700, fontSize: 16, color: 'var(--text)', marginTop: 3, lineHeight: 1.25 }}>{quote.object}</div>
          <div style={{ display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginTop: 12, paddingTop: 12, borderTop: '1px solid var(--border)' }}>
            <span style={{ fontSize: 12.5, color: 'var(--text-3)' }}>Montant total</span>
            <span style={{ fontFamily: 'var(--font-head)', fontWeight: 800, fontSize: 22, color: 'var(--ink)', fontVariantNumeric: 'tabular-nums' }}>{D.formatFCFA(D.grandTotal(quote))}</span>
          </div>
        </div>
        <div style={{ borderRadius: 12, overflow: 'hidden', boxShadow: 'var(--sh-4)', border: '1px solid #d7dde4' }}>
          <DevisDocument company={company} quote={quote} compact />
        </div>
        <div style={{ textAlign: 'center', color: 'var(--text-3)', fontSize: 11.5, marginTop: 16, lineHeight: 1.6 }}>
          Devis généré avec <b style={{ color: 'var(--ink)' }}>DATO</b><br />Créez vos devis professionnels en quelques minutes.
        </div>
      </div>

      <div className="actionbar">
        <button className="btn btn-primary btn-block" onClick={() => onToast('Téléchargement du PDF…', 'download')}><Ic name="download" size={20} /> Télécharger le PDF</button>
      </div>
    </div>
  );
}

/* ---- Bottom sheet « Partager » ---- */
function ShareSheet({ open, onClose, onToast, quote }) {
  return (
    <div style={{ position: 'absolute', inset: 0, zIndex: 80, pointerEvents: open ? 'auto' : 'none' }}>
      <div onClick={onClose} style={{ position: 'absolute', inset: 0, background: 'rgba(16,24,40,.45)', opacity: open ? 1 : 0, transition: 'opacity .25s' }} />
      <div style={{
        position: 'absolute', left: 0, right: 0, bottom: 0, background: '#fff',
        borderRadius: '20px 20px 0 0', boxShadow: '0 -10px 40px rgba(0,0,0,.2)', padding: '8px 16px 24px',
        transform: open ? 'translateY(0)' : 'translateY(110%)', transition: 'transform .3s cubic-bezier(.22,1,.36,1)',
      }}>
        <div style={{ width: 42, height: 5, borderRadius: 3, background: 'var(--border-strong)', margin: '6px auto 14px' }} />
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 4 }}>
          <h3 style={{ fontFamily: 'var(--font-head)', fontSize: 18 }}>Partager le devis</h3>
          <button className="iconbtn" onClick={onClose}><Ic name="x" size={20} /></button>
        </div>
        <p style={{ color: 'var(--text-2)', fontSize: 13, margin: '0 0 16px' }}>{quote.object}</p>
        <button className="btn btn-wa btn-block" style={{ marginBottom: 10 }} onClick={() => { onClose(); onToast('Ouverture de WhatsApp…', 'wa'); }}><Ic name="whatsapp" size={20} /> Partager sur WhatsApp</button>
        <button className="btn btn-secondary btn-block" style={{ marginBottom: 10 }} onClick={() => { onClose(); onToast('Lien copié dans le presse-papier', 'copy'); }}><Ic name="copy" size={19} /> Copier le lien</button>
        <button className="btn btn-secondary btn-block" style={{ marginBottom: 10 }} onClick={() => { onClose(); onToast('Téléchargement du PDF…', 'download'); }}><Ic name="download" size={19} /> Télécharger le PDF</button>
        <button className="btn btn-block" style={{ background: 'transparent', color: 'var(--text-2)' }} onClick={() => { onClose(); onToast('E-mail prêt à envoyer', 'mail'); }}><Ic name="send" size={18} /> Envoyer par e-mail</button>
      </div>
    </div>
  );
}

/* ---- Toast ---- */
function Toast({ toast }) {
  if (!toast) return null;
  const iconMap = { wa: 'whatsapp', copy: 'check-circle', download: 'download', mail: 'send', save: 'check-circle' };
  return (
    <div style={{ position: 'absolute', left: 16, right: 16, bottom: 86, zIndex: 90, display: 'flex', justifyContent: 'center', pointerEvents: 'none' }}>
      <div style={{ display: 'inline-flex', alignItems: 'center', gap: 10, background: '#101828', color: '#fff', padding: '12px 16px', borderRadius: 12, boxShadow: 'var(--sh-4)', fontSize: 13.5, fontWeight: 500, animation: 'dato-toast .3s ease' }}>
        <Ic name={iconMap[toast.kind] || 'check-circle'} size={18} style={{ color: toast.kind === 'wa' ? '#25D366' : '#5fd07a' }} />
        {toast.msg}
      </div>
    </div>
  );
}
Object.assign(window, { Preview, PublicView, ShareSheet, Toast });
