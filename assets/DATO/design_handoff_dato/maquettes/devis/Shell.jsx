/* ============================================================
   DATO — Shell applicatif : tab bar + Dashboard + Liste
   ============================================================ */
const { useState, useRef, useEffect } = React;
const EDITOR_URL = encodeURI('Éditeur de devis.html');
const fmt = (n) => window.DATO.formatMoney(n);
const FRM = ['janv.', 'févr.', 'mars', 'avr.', 'mai', 'juin', 'juil.', 'août', 'sept.', 'oct.', 'nov.', 'déc.'];
function dShort(iso) { const d = new Date(iso + 'T00:00:00'); return `${d.getDate()} ${FRM[d.getMonth()]} ${d.getFullYear()}`; }

function Phone({ children }) {
  return (
    <div style={{ width: 402, height: 858, borderRadius: 44, background: '#0c1116', padding: 9, boxShadow: '0 40px 90px rgba(16,24,40,.34)', flex: 'none' }}>
      <div style={{ width: '100%', height: '100%', borderRadius: 36, overflow: 'hidden', background: '#fff', display: 'flex', flexDirection: 'column', position: 'relative' }}>
        <AndroidStatusBar />
        <div style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>{children}</div>
        <div style={{ height: 22, display: 'grid', placeItems: 'center', background: '#fff' }}>
          <div style={{ width: 120, height: 4, borderRadius: 2, background: '#101828', opacity: .35 }} />
        </div>
      </div>
    </div>
  );
}

function StatusBadge({ status }) {
  const s = window.DATO_STATUS[status];
  return <span className={'badge ' + s.cls}><span className="dot"></span>{s.label}</span>;
}

function QuoteCard({ q, onOpen, onMenu }) {
  return (
    <div className="qcard" onClick={onOpen}>
      <div className="top">
        <div style={{ flex: 1, minWidth: 0 }}>
          <div className="obj">{q.object}</div>
          <div className="client"><Ic name="user" size={13} /> {q.client}</div>
        </div>
        <StatusBadge status={q.status} />
      </div>
      <div className="r2">
        <div className="meta">{q.number} · {dShort(q.date)}</div>
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <div className="amount">{fmt(q.total)}</div>
          <button className="iconbtn" style={{ width: 32, height: 32 }} onClick={(e) => { e.stopPropagation(); onMenu(e, q); }}><Ic name="dots" size={18} /></button>
        </div>
      </div>
    </div>
  );
}

/* ---- Tableau de bord ---- */
function Dashboard({ quotes, onOpen, onMenu, onNew, onTab, onToast }) {
  const monthTotal = quotes.filter((q) => q.date >= '2026-05-01').reduce((s, q) => s + q.total, 0);
  const monthCount = quotes.filter((q) => q.date >= '2026-05-01').length;
  return (
    <div className="scr-scroll">
      <div className="dash-top">
        <div className="avatar">JM</div>
        <div className="hi"><div className="s">Bonjour,</div><div className="n">Jean-Pierre Mballa</div></div>
        <button className="iconbtn bordered" onClick={() => onTab('settings')}><Ic name="settings" size={20} /></button>
      </div>
      <div className="dash-body">
        {/* Quota */}
        <div className="quota">
          <div className="row">
            <span className="plan"><Ic name="info" size={14} /> Forfait Gratuit</span>
            <span className="count">2 / 3</span>
          </div>
          <div className="bar"><i style={{ width: '66%' }}></i></div>
          <div className="hint">Il vous reste <b>1 devis gratuit</b> ce mois-ci. Renouvellement le 1ᵉʳ juin.</div>
          <button className="pro" onClick={() => onToast('Passer Pro (Lot 5)', 'save')}><Ic name="check-circle" size={17} /> Passer à DATO Pro</button>
        </div>
        {/* Stats */}
        <div className="stat-grid">
          <div className="stat"><div className="k"><Ic name="file" size={14} /> Devis ce mois</div><div className="v">{monthCount}</div></div>
          <div className="stat"><div className="k"><Ic name="calc" size={14} /> Montant estimé</div><div className="v sm">{fmt(monthTotal)} <span className="u">FCFA</span></div></div>
        </div>
        {/* Récents */}
        <div className="sec-title"><h2>Devis récents</h2><a onClick={() => onTab('list')}>Tout voir <Ic name="chevron-r" size={14} /></a></div>
        <div className="qlist">
          {quotes.slice(0, 3).map((q) => <QuoteCard key={q.id} q={q} onOpen={() => onOpen(q)} onMenu={onMenu} />)}
        </div>
        <button className="btn btn-primary btn-block" style={{ marginTop: 4 }} onClick={onNew}><Ic name="plus" size={20} /> Nouveau devis</button>
      </div>
    </div>
  );
}

/* ---- Liste des devis ---- */
function ListeDevis({ quotes, onOpen, onMenu }) {
  const [search, setSearch] = useState('');
  const [filter, setFilter] = useState('all');
  const filtered = quotes.filter((q) => {
    if (filter !== 'all' && q.status !== filter) return false;
    const t = search.toLowerCase();
    return !t || q.object.toLowerCase().includes(t) || q.client.toLowerCase().includes(t);
  });
  const chips = [['all', 'Tous'], ['draft', 'Brouillon'], ['sent', 'Envoyé'], ['accepted', 'Accepté'], ['refused', 'Refusé']];
  return (
    <div className="scr-scroll">
      <div className="searchbar"><span className="si"><Ic name="search" size={19} /></span><input placeholder="Rechercher un devis, un client…" value={search} onChange={(e) => setSearch(e.target.value)} /></div>
      <div className="filters">{chips.map(([k, l]) => <button key={k} className={'chip' + (filter === k ? ' on' : '')} onClick={() => setFilter(k)}>{l}</button>)}</div>
      <div className="qlist" style={{ padding: '8px 16px 0' }}>
        {filtered.length === 0 ? (
          <div className="placeholder"><div className="ill"><Ic name="search" size={32} /></div><h3>Aucun résultat</h3><p>Essayez un autre mot-clé ou filtre.</p></div>
        ) : filtered.map((q) => <QuoteCard key={q.id} q={q} onOpen={() => onOpen(q)} onMenu={onMenu} />)}
      </div>
    </div>
  );
}

/* ---- Placeholders Articles / Réglages (lots suivants) ---- */
function Placeholder({ icon, title, text }) {
  return <div className="scr-scroll"><div className="placeholder" style={{ paddingTop: 120 }}><div className="ill"><Ic name={icon} size={34} /></div><h3>{title}</h3><p>{text}</p></div></div>;
}

/* ---- App shell ---- */
function Shell() {
  const quotes = window.DATO_QUOTES;
  const [tab, setTab] = useState('home');
  const [menu, setMenu] = useState(null); // {q, x, y}
  const [toast, setToast] = useState(null);
  const tRef = useRef(null);
  function showToast(msg, kind) { setToast({ msg, kind }); clearTimeout(tRef.current); tRef.current = setTimeout(() => setToast(null), 2200); }
  function openEditor() { window.location.href = EDITOR_URL; }
  function openMenu(e, q) { const r = e.currentTarget.getBoundingClientRect(); const host = e.currentTarget.closest('[data-phone]').getBoundingClientRect(); setMenu({ q, x: r.right - host.left - 184, y: r.bottom - host.top + 6 }); }

  const titles = { home: null, list: 'Mes devis', library: 'Bibliothèque', settings: 'Réglages' };
  const screen =
    tab === 'list' ? <ListeDevis quotes={quotes} onOpen={openEditor} onMenu={openMenu} />
    : tab === 'library' ? <Placeholder icon="book" title="Bibliothèque d'articles" text="Vos articles réutilisables (désignation + prix mémorisé). À venir au Lot 6." />
    : tab === 'settings' ? <Placeholder icon="settings" title="Réglages" text="En-tête entreprise, signatures, numérotation, compte. À venir au Lot 4." />
    : <Dashboard quotes={quotes} onOpen={openEditor} onMenu={openMenu} onNew={openEditor} onTab={setTab} onToast={showToast} />;

  return (
    <div style={{ minHeight: '100vh', background: 'radial-gradient(120% 80% at 50% 0%, #eef1f5 0%, #e6eaef 60%, #dfe4ea 100%)', display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '26px 16px 60px' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 9, marginBottom: 20 }}>
        <div style={{ width: 34, height: 34, borderRadius: 9, background: 'var(--ink)', color: '#fff', display: 'grid', placeItems: 'center', fontFamily: 'var(--font-head)', fontWeight: 800 }}>D</div>
        <div><div style={{ fontFamily: 'var(--font-head)', fontWeight: 700, fontSize: 15, color: 'var(--text)' }}>DATO — Application</div><div style={{ fontSize: 12, color: 'var(--text-2)' }}>Lot 3/8 · accueil, liste, navigation</div></div>
      </div>

      <Phone>
        <div data-phone style={{ position: 'absolute', inset: 0 }}>
          {titles[tab] && <div className="scr-head"><h1>{titles[tab]}</h1></div>}
          {screen}

          {/* Popover menu d'actions */}
          {menu && (<>
            <div style={{ position: 'absolute', inset: 0, zIndex: 65 }} onClick={() => setMenu(null)} />
            <div className="popover" style={{ left: Math.max(8, menu.x), top: menu.y }}>
              <button onClick={() => { setMenu(null); openEditor(); }}><Ic name="eye" size={18} /> Voir / Éditer</button>
              <button onClick={() => { setMenu(null); showToast('Devis dupliqué', 'copy'); }}><Ic name="copy" size={18} /> Dupliquer</button>
              <button onClick={() => { setMenu(null); showToast('Ouverture du partage…', 'wa'); }}><Ic name="share" size={18} /> Partager</button>
              <button onClick={() => { setMenu(null); showToast('Téléchargement du PDF…', 'download'); }}><Ic name="download" size={18} /> Télécharger PDF</button>
              <div className="div" />
              <button onClick={() => { setMenu(null); showToast('Changer le statut (Lot 6)', 'save'); }}><Ic name="check-circle" size={18} /> Changer le statut</button>
              <button className="danger" onClick={() => { setMenu(null); showToast('Supprimer le devis (Lot 6)', 'save'); }}><Ic name="trash" size={18} /> Supprimer</button>
            </div>
          </>)}

          {toast && (
            <div style={{ position: 'absolute', left: 16, right: 16, bottom: 96, zIndex: 90, display: 'flex', justifyContent: 'center', pointerEvents: 'none' }}>
              <div style={{ display: 'inline-flex', alignItems: 'center', gap: 10, background: '#101828', color: '#fff', padding: '12px 16px', borderRadius: 12, boxShadow: 'var(--sh-4)', fontSize: 13.5, fontWeight: 500 }}>
                <Ic name={({ wa: 'whatsapp', copy: 'check-circle', download: 'download' })[toast.kind] || 'check-circle'} size={18} style={{ color: toast.kind === 'wa' ? '#25D366' : '#5fd07a' }} /> {toast.msg}
              </div>
            </div>
          )}

          {/* Tab bar */}
          <div className="tabbar">
            <button className={'tb' + (tab === 'home' ? ' active' : '')} onClick={() => setTab('home')}><Ic name="home" size={23} /> Accueil</button>
            <button className={'tb' + (tab === 'list' ? ' active' : '')} onClick={() => setTab('list')}><Ic name="file" size={23} /> Devis</button>
            <button className="fab" onClick={openEditor} aria-label="Nouveau devis"><Ic name="plus" size={27} /></button>
            <button className={'tb' + (tab === 'library' ? ' active' : '')} onClick={() => setTab('library')}><Ic name="book" size={23} /> Articles</button>
            <button className={'tb' + (tab === 'settings' ? ' active' : '')} onClick={() => setTab('settings')}><Ic name="settings" size={23} /> Réglages</button>
          </div>
        </div>
      </Phone>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<><IconSprite /><Shell /></>);
