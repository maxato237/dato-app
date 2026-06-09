/* ============================================================
   DATO — Lot 6a : Bibliothèque d'articles & Paramètres
   ============================================================ */
const { useState } = React;

function LibIcon() { return <Ic name="book" size={19} />; }

/* ---- Bibliothèque d'articles ---- */
function Bibliotheque({ onAdd, onEdit, empty }) {
  const [q, setQ] = useState('');
  const arts = empty ? [] : window.DATO_DATA.library;
  const filtered = arts.filter((a) => a.name.toLowerCase().includes(q.toLowerCase()));
  return (
    <div className="scr">
      <div className="scr-h"><h1>Bibliothèque</h1><button className="iconbtn bordered" onClick={onAdd}><Ic name="plus" size={20} /></button></div>
      {arts.length === 0 ? (
        <div className="scr-c"><div className="empty"><div className="ill"><Ic name="book" size={36} /></div><h3>Bibliothèque vide</h3><p>Enregistrez vos articles fréquents (désignation + prix) pour les réutiliser en un tap dans vos devis.</p><button className="btn btn-primary" style={{ width: 'auto', display: 'inline-flex' }} onClick={onAdd}><Ic name="plus" size={18} /> Ajouter un article</button></div></div>
      ) : (<>
        <div className="lib-search"><span className="si"><Ic name="search" size={18} /></span><input placeholder="Rechercher un article…" value={q} onChange={(e) => setQ(e.target.value)} /></div>
        <div className="scr-c">
          <div className="art-list">
            {filtered.map((a) => (
              <div className="art" key={a.name}>
                <div className="ai"><Ic name="hash" size={17} /></div>
                <div className="an">{a.name}</div>
                <div className="ap">{window.DATO.formatMoney(a.pu)}</div>
                <span className="edit" onClick={() => onEdit(a)}><Ic name="edit" size={17} /></span>
              </div>
            ))}
            {filtered.length === 0 && <div className="empty" style={{ padding: '40px 20px' }}><div className="ill"><Ic name="search" size={32} /></div><h3>Aucun résultat</h3></div>}
          </div>
        </div>
      </>)}
    </div>
  );
}

/* ---- Paramètres ---- */
function Parametres({ onLogout }) {
  const [tab, setTab] = useState('header');
  const tabs = [['header', 'Entreprise'], ['sign', 'Signatures'], ['account', 'Compte'], ['num', 'Numérotation'], ['pref', 'Préférences']];
  return (
    <div className="scr">
      <div className="scr-h"><h1>Réglages</h1></div>
      <div className="settings-tabs">{tabs.map(([k, l]) => <button key={k} className={tab === k ? 'on' : ''} onClick={() => setTab(k)}>{l}</button>)}</div>
      <div className="scr-c">
        <div className="settings-body">
          {tab === 'header' && (<>
            <div className="s-section-label">En-tête de l'entreprise</div>
            <div className="s-group">
              <div className="s-row"><div className="ic" style={{ background: 'var(--ink)', color: '#fff', fontFamily: 'var(--font-head)', fontWeight: 800 }}>M</div><div className="tx"><div className="k">Logo</div><div className="v">Affiché en haut des devis</div></div><span className="chev"><Ic name="chevron-r" size={18} /></span></div>
            </div>
            <div className="s-group">
              <div className="s-field"><label>Nom de l'entreprise</label><input defaultValue="MILLENAIRE DECOR" /></div>
              <div className="s-field"><label>Activité</label><input defaultValue="Menuiserie générale" /></div>
              <div className="s-field"><label>Ville</label><input defaultValue="Yaoundé" /></div>
              <div className="s-field"><label>Téléphone(s)</label><input defaultValue="674 70 20 37 / 695 42 93 71" /></div>
              <div className="s-field"><label>Adresse / BP</label><input defaultValue="BP : 705 YDE" /></div>
            </div>
            <button className="btn btn-primary" style={{ width: '100%' }}><Ic name="check" size={18} /> Enregistrer</button>
          </>)}

          {tab === 'sign' && (<>
            <div className="s-section-label">Blocs de signature par défaut</div>
            <div className="s-group">
              <div className="s-row"><div className="ic"><Ic name="pen" size={17} /></div><div className="tx"><div className="k">Le Technicien</div></div><span className="edit" style={{ color: 'var(--text-3)', cursor: 'pointer' }}><Ic name="edit" size={17} /></span></div>
              <div className="s-row"><div className="ic"><Ic name="pen" size={17} /></div><div className="tx"><div className="k">Le Client</div></div><span className="edit" style={{ color: 'var(--text-3)', cursor: 'pointer' }}><Ic name="edit" size={17} /></span></div>
            </div>
            <button className="btn btn-secondary" style={{ width: '100%' }}><Ic name="plus" size={18} /> Ajouter un bloc</button>
          </>)}

          {tab === 'account' && (<>
            <div className="s-section-label">Compte utilisateur</div>
            <div className="s-group">
              <div className="s-field"><label>Nom complet</label><input defaultValue="Jean-Pierre Mballa" /></div>
              <div className="s-field"><label>Téléphone</label><input defaultValue="+237 674 70 20 37" /></div>
              <div className="s-field"><label>E-mail</label><input defaultValue="jp.mballa@exemple.com" /></div>
            </div>
            <div className="s-group">
              <div className="s-row"><div className="ic"><Ic name="settings" size={17} /></div><div className="tx"><div className="k">Changer le mot de passe</div><div className="v">Dernière modification il y a 2 mois</div></div><span className="chev"><Ic name="chevron-r" size={18} /></span></div>
            </div>
            <button className="logout" onClick={onLogout}><Ic name="x" size={18} /> Se déconnecter</button>
          </>)}

          {tab === 'num' && (<>
            <div className="s-section-label">Numérotation des devis</div>
            <div className="s-group">
              <div className="s-field"><label>Format</label><input defaultValue="DV-{année}-{séquence}" /><div className="s-help">Variables : {'{année}'}, {'{mois}'}, {'{séquence}'}</div></div>
              <div className="s-field"><label>Prochain numéro de séquence</label><input defaultValue="015" inputMode="numeric" /></div>
            </div>
            <div style={{ padding: '0 4px' }}><span className="s-help">Aperçu du prochain numéro :</span><br /><span className="num-preview"><Ic name="hash" size={15} /> DV-2026-015</span></div>
          </>)}

          {tab === 'pref' && (<>
            <div className="s-section-label">Préférences</div>
            <div className="s-group">
              <div className="s-field"><label>Langue de l'interface</label><select defaultValue="fr"><option value="fr">Français</option><option value="en">English</option></select></div>
              <div className="s-field"><label>Devise par défaut</label><select defaultValue="FCFA"><option>FCFA</option><option>EUR (€)</option><option>USD ($)</option></select></div>
            </div>
            <div className="s-group">
              <div className="s-row"><div className="ic"><Ic name="info" size={17} /></div><div className="tx"><div className="k">À propos de DATO</div><div className="v">Version 1.0.0</div></div><span className="chev"><Ic name="chevron-r" size={18} /></span></div>
              <div className="s-row"><div className="ic"><Ic name="file" size={17} /></div><div className="tx"><div className="k">Conditions & confidentialité</div></div><span className="chev"><Ic name="chevron-r" size={18} /></span></div>
            </div>
          </>)}
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { Bibliotheque, Parametres });
