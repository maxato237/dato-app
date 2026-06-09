/* ============================================================
   DATO — Lot 6b : Modals, états pleins écrans, host galerie
   ============================================================ */
const { useState: uS } = React;
const APP = encodeURI('Application DATO.html');
const EDIT = encodeURI('Éditeur de devis.html');

function PhoneL6({ children }) {
  return (
    <div style={{ width: 402, height: 858, borderRadius: 44, background: '#0c1116', padding: 9, boxShadow: '0 40px 90px rgba(16,24,40,.34)', flex: 'none' }}>
      <div style={{ width: '100%', height: '100%', borderRadius: 36, overflow: 'hidden', background: '#fff', display: 'flex', flexDirection: 'column', position: 'relative' }}>
        <AndroidStatusBar />
        <div style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>{children}</div>
        <div style={{ height: 22, display: 'grid', placeItems: 'center', background: '#fff' }}><div style={{ width: 120, height: 4, borderRadius: 2, background: '#101828', opacity: .35 }} /></div>
      </div>
    </div>
  );
}

/* Fond d'app flouté derrière les modals */
function AppBackdrop() {
  return (
    <div style={{ position: 'absolute', inset: 0, padding: 16, background: 'var(--bg)' }}>
      <div className="sk" style={{ height: 22, width: '55%', marginBottom: 16 }}></div>
      {[0, 1, 2].map((i) => (
        <div className="sk-card" key={i}>
          <div className="sk" style={{ height: 14, width: '80%', marginBottom: 9 }}></div>
          <div className="sk" style={{ height: 12, width: '50%' }}></div>
          <div className="sk" style={{ height: 16, width: '40%', marginTop: 14, marginLeft: 'auto' }}></div>
        </div>
      ))}
    </div>
  );
}

/* ---------- MODALS ---------- */
function ModalShell({ children, onClose, narrow }) {
  return (
    <div className="overlay">
      <div className="scrim" onClick={onClose}></div>
      <div className="modal" style={narrow ? { maxWidth: 320 } : null}>{children}</div>
    </div>
  );
}

function NewQuoteModal({ close }) {
  return (
    <ModalShell onClose={close}>
      <div className="modal-h"><h3>Nouveau devis</h3><span className="x" onClick={close}><Ic name="x" size={20} /></span></div>
      <p className="sub">Comment voulez-vous démarrer ?</p>
      <div className="choice" onClick={() => location.href = EDIT}><div className="ci"><Ic name="file" size={20} /></div><div className="ct"><div className="t">Devis vierge</div><div className="d">Partir de zéro</div></div><span style={{ color: 'var(--text-3)' }}><Ic name="chevron-r" size={18} /></span></div>
      <div className="choice" onClick={() => location.href = EDIT}><div className="ci"><Ic name="copy" size={20} /></div><div className="ct"><div className="t">Dupliquer un devis</div><div className="d">Repartir d'un devis existant</div></div><span style={{ color: 'var(--text-3)' }}><Ic name="chevron-r" size={18} /></span></div>
      <div className="choice amber" onClick={() => location.href = EDIT}><div className="ci"><Ic name="layers" size={20} /></div><div className="ct"><div className="t">À partir d'un modèle</div><div className="d">Menuiserie, BTP, électricité…</div></div><span style={{ color: 'var(--text-3)' }}><Ic name="chevron-r" size={18} /></span></div>
    </ModalShell>
  );
}

function DuplicateModal({ close }) {
  return (
    <ModalShell onClose={close} narrow>
      <div className="modal-h"><h3>Dupliquer le devis</h3><span className="x" onClick={close}><Ic name="x" size={20} /></span></div>
      <p className="sub">Une copie modifiable sera créée. Donnez-lui un nouvel objet.</p>
      <div className="modal-field"><label>Objet du nouveau devis</label><input defaultValue="Fabrication de 40 chaises (copie)" /></div>
      <div className="modal-field"><label>Client</label><input defaultValue="Lycée Bilingue de Yaoundé" /></div>
      <div className="modal-actions"><button className="btn btn-secondary" onClick={close}>Annuler</button><button className="btn btn-primary" onClick={() => location.href = EDIT}>Dupliquer</button></div>
    </ModalShell>
  );
}

function DeleteModal({ close }) {
  return (
    <ModalShell onClose={close} narrow>
      <div className="modal-ic danger"><Ic name="trash" size={24} /></div>
      <h3 style={{ fontFamily: 'var(--font-head)', fontWeight: 700, fontSize: 18, marginBottom: 6 }}>Supprimer ce devis ?</h3>
      <p className="sub">Cette action est définitive. Le devis « Fabrication de 40 chaises » et son lien partagé seront supprimés.</p>
      <div className="modal-actions"><button className="btn btn-secondary" onClick={close}>Annuler</button><button className="btn" style={{ background: 'var(--danger)', color: '#fff', flex: 1 }} onClick={close}>Supprimer</button></div>
    </ModalShell>
  );
}

function StatusModal({ close }) {
  const [sel, setSel] = uS('sent');
  const opts = [['draft', 'Brouillon'], ['sent', 'Envoyé'], ['accepted', 'Accepté'], ['refused', 'Refusé']];
  return (
    <ModalShell onClose={close} narrow>
      <div className="modal-h"><h3>Changer le statut</h3><span className="x" onClick={close}><Ic name="x" size={20} /></span></div>
      <p className="sub">Suivez l'avancement de votre devis.</p>
      <div style={{ marginBottom: 8 }}>
        {opts.map(([k, l]) => (
          <div key={k} className={'status-opt' + (sel === k ? ' on' : '')} onClick={() => setSel(k)}>
            <span className={'badge ' + window.DATO_STATUS[k].cls}><span className="dot"></span>{l}</span>
            <span className="check"><Ic name="check" size={20} /></span>
          </div>
        ))}
      </div>
      <button className="btn btn-primary" style={{ width: '100%' }} onClick={close}>Confirmer</button>
    </ModalShell>
  );
}

function ArticleModal({ close }) {
  return (
    <ModalShell onClose={close} narrow>
      <div className="modal-h"><h3>Nouvel article</h3><span className="x" onClick={close}><Ic name="x" size={20} /></span></div>
      <p className="sub">Mémorisez un article pour le réutiliser.</p>
      <div className="modal-field"><label>Désignation</label><input placeholder="Ex. Planches" /></div>
      <div className="modal-field"><label>Prix unitaire (FCFA)</label><input placeholder="6 000" inputMode="numeric" style={{ textAlign: 'right', fontVariantNumeric: 'tabular-nums' }} /></div>
      <div className="modal-actions"><button className="btn btn-secondary" onClick={close}>Annuler</button><button className="btn btn-primary" onClick={close}>Enregistrer</button></div>
    </ModalShell>
  );
}

function LogoModal({ close }) {
  const [zoom, setZoom] = uS(50);
  return (
    <ModalShell onClose={close} narrow>
      <div className="modal-h"><h3>Recadrer le logo</h3><span className="x" onClick={close}><Ic name="x" size={20} /></span></div>
      <div className="crop-area"><div className="crop-circle" style={{ transform: `scale(${0.8 + zoom / 120})` }}>M</div></div>
      <div className="crop-slider"><Ic name="search" size={16} style={{ color: 'var(--text-3)' }} /><input type="range" min="0" max="100" value={zoom} onChange={(e) => setZoom(+e.target.value)} /></div>
      <div className="modal-actions" style={{ marginTop: 14 }}><button className="btn btn-secondary" onClick={close}>Annuler</button><button className="btn btn-primary" onClick={close}>Appliquer</button></div>
    </ModalShell>
  );
}

function SessionModal({ close }) {
  return (
    <ModalShell onClose={close} narrow>
      <div className="modal-ic warn"><Ic name="clock" size={24} /></div>
      <h3 style={{ fontFamily: 'var(--font-head)', fontWeight: 700, fontSize: 18, marginBottom: 6 }}>Session expirée</h3>
      <p className="sub">Pour votre sécurité, vous avez été déconnecté. Reconnectez-vous pour continuer.</p>
      <button className="btn btn-primary" style={{ width: '100%' }} onClick={() => location.href = encodeURI('Auth & Onboarding.html')}>Se reconnecter</button>
    </ModalShell>
  );
}

/* ---------- BOTTOM SHEET PARTAGE ---------- */
function ShareBottom({ close }) {
  return (
    <div className="overlay" style={{ alignItems: 'flex-end', padding: 0 }}>
      <div className="scrim" onClick={close}></div>
      <div style={{ position: 'relative', zIndex: 1, background: '#fff', borderRadius: '20px 20px 0 0', width: '100%', padding: '8px 16px 24px', boxShadow: '0 -10px 40px rgba(0,0,0,.2)' }}>
        <div style={{ width: 42, height: 5, borderRadius: 3, background: 'var(--border-strong)', margin: '6px auto 14px' }}></div>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 14 }}><h3 style={{ fontFamily: 'var(--font-head)', fontSize: 18 }}>Partager le devis</h3><span className="x" onClick={close} style={{ color: 'var(--text-3)', cursor: 'pointer' }}><Ic name="x" size={20} /></span></div>
        <button className="btn" style={{ width: '100%', background: 'var(--whatsapp)', color: '#fff', marginBottom: 10 }}><Ic name="whatsapp" size={20} /> Partager sur WhatsApp</button>
        <button className="btn btn-secondary" style={{ width: '100%', marginBottom: 10 }}><Ic name="copy" size={19} /> Copier le lien</button>
        <button className="btn btn-secondary" style={{ width: '100%', marginBottom: 10 }}><Ic name="download" size={19} /> Télécharger le PDF</button>
        <button className="btn" style={{ width: '100%', background: 'transparent', color: 'var(--text-2)' }}><Ic name="send" size={18} /> Envoyer par e-mail</button>
      </div>
    </div>
  );
}

/* ---------- ÉTATS PLEIN ÉCRAN ---------- */
function NotFound() {
  return (<div className="fullstate"><div className="code">404</div><h2>Page introuvable</h2><p>Le devis ou la page que vous cherchez n'existe pas ou a été supprimé.</p><button className="btn btn-primary" style={{ width: 'auto', display: 'inline-flex' }} onClick={() => location.href = APP}><Ic name="home" size={18} /> Retour à l'accueil</button></div>);
}
function NetError() {
  return (<div className="fullstate"><div className="big-ic err"><Ic name="wifi-off" size={44} /></div><h2>Connexion perdue</h2><p>Impossible de joindre le serveur. Vérifiez votre connexion internet et réessayez.</p><button className="btn btn-primary" style={{ width: 'auto', display: 'inline-flex' }}><Ic name="download" size={18} /> Réessayer</button></div>);
}
function ServerError() {
  return (<div className="fullstate"><div className="big-ic err"><Ic name="alert" size={44} /></div><h2>Une erreur est survenue</h2><p>Nos serveurs rencontrent un problème (erreur 500). Réessayez dans quelques instants.</p><button className="btn btn-primary" style={{ width: 'auto', display: 'inline-flex' }}><Ic name="download" size={18} /> Réessayer</button></div>);
}

/* ---------- ÉCRANS (états) ---------- */
function LoadingList() {
  return (
    <div className="scr"><div className="scr-h"><h1>Mes devis</h1></div><div className="scr-c" style={{ padding: 16 }}>
      {[0, 1, 2, 3].map((i) => (<div className="sk-card" key={i}><div style={{ display: 'flex', justifyContent: 'space-between' }}><div style={{ flex: 1 }}><div className="sk" style={{ height: 15, width: '85%', marginBottom: 9 }}></div><div className="sk" style={{ height: 12, width: '55%' }}></div></div><div className="sk" style={{ height: 22, width: 64, borderRadius: 999 }}></div></div><div style={{ display: 'flex', justifyContent: 'space-between', marginTop: 16, paddingTop: 12, borderTop: '1px solid var(--border)' }}><div className="sk" style={{ height: 12, width: 90 }}></div><div className="sk" style={{ height: 16, width: 110 }}></div></div></div>))}
    </div></div>
  );
}
function EmptyQuotes() {
  return (<div className="scr"><div className="scr-h"><h1>Mes devis</h1></div><div className="scr-c"><div className="empty" style={{ paddingTop: 80 }}><div className="ill"><Ic name="file" size={36} /></div><h3>Aucun devis pour l'instant</h3><p>Créez votre premier devis professionnel en quelques minutes et partagez-le sur WhatsApp.</p><button className="btn btn-primary" style={{ width: 'auto', display: 'inline-flex' }} onClick={() => location.href = EDIT}><Ic name="plus" size={18} /> Nouveau devis</button></div></div></div>);
}
function Alerts() {
  return (<div className="scr"><div className="scr-h"><h1>Bandeaux d'alerte</h1></div><div className="scr-c" style={{ padding: 16 }}>
    <div className="alert warn"><span className="ai"><Ic name="alert" size={18} /></span><div>Il vous reste <b>1 devis gratuit</b> ce mois-ci. <span className="cta">Passer Pro</span></div></div>
    <div className="alert danger"><span className="ai"><Ic name="alert" size={18} /></span><div>Votre abonnement <b>a expiré le 1ᵉʳ juin</b>. Renouvelez pour continuer. <span className="cta">Renouveler</span></div></div>
    <div className="alert info"><span className="ai"><Ic name="info" size={18} /></span><div>Votre abonnement Pro expire dans <b>3 jours</b>.</div></div>
    <div className="alert warn"><span className="ai"><Ic name="wifi-off" size={18} /></span><div><b>Mode hors ligne</b> — vos modifications sont sauvegardées localement.</div></div>
  </div></div>);
}
function Legal() {
  return (<div className="scr"><div className="scr-h"><button className="iconbtn" onClick={() => history.length > 1 ? null : null}><Ic name="chevron-l" size={22} /></button><h1>Confidentialité</h1></div><div className="scr-c"><div className="legal">
    <div className="upd">Dernière mise à jour : 1ᵉʳ juin 2026</div>
    <h2>1. Données collectées</h2><p>DATO collecte les informations que vous fournissez pour créer vos devis : nom de l'entreprise, coordonnées, et le contenu des devis que vous rédigez. Ces données vous appartiennent.</p>
    <h2>2. Utilisation</h2><p>Vos données servent uniquement à générer, enregistrer et partager vos devis. Nous ne revendons jamais vos informations à des tiers.</p>
    <h2>3. Partage des devis</h2><p>Lorsque vous partagez un devis via un lien, seules les personnes disposant de ce lien peuvent le consulter. Vous pouvez désactiver un lien à tout moment.</p>
    <h2>4. Paiements</h2><p>Les paiements Mobile Money sont traités par nos partenaires opérateurs (MTN, Orange). DATO ne stocke pas votre code secret.</p>
    <h2>5. Contact</h2><p>Pour toute question relative à vos données, contactez-nous à privacy@dato.app.</p>
  </div></div></div>);
}

/* ---------- HOST GALERIE ---------- */
function Lot6() {
  const [bg, setBg] = uS('list'); // backdrop screen for modals
  const [view, setView] = uS('biblio');

  const modalMap = {
    'm-new': NewQuoteModal, 'm-dup': DuplicateModal, 'm-del': DeleteModal, 'm-status': StatusModal,
    'm-article': ArticleModal, 'm-logo': LogoModal, 'm-session': SessionModal, 'm-share': ShareBottom,
  };
  const isModal = view.startsWith('m-');
  const ModalComp = modalMap[view];

  let content;
  if (view === 'biblio') content = <Bibliotheque onAdd={() => setView('m-article')} onEdit={() => setView('m-article')} />;
  else if (view === 'biblio-empty') content = <Bibliotheque empty onAdd={() => setView('m-article')} onEdit={() => {}} />;
  else if (view === 'settings') content = <Parametres onLogout={() => setView('m-session')} />;
  else if (view === 'loading') content = <LoadingList />;
  else if (view === 'empty') content = <EmptyQuotes />;
  else if (view === 'alerts') content = <Alerts />;
  else if (view === 'legal') content = <Legal />;
  else if (view === '404') content = <NotFound />;
  else if (view === 'net') content = <NetError />;
  else if (view === '500') content = <ServerError />;
  else content = <AppBackdrop />; // behind modals

  const cats = [
    ['Écrans', [['biblio', 'Bibliothèque'], ['biblio-empty', 'Biblio. vide'], ['settings', 'Paramètres']]],
    ['Modals', [['m-new', 'Nouveau devis'], ['m-dup', 'Dupliquer'], ['m-status', 'Changer statut'], ['m-article', 'Article'], ['m-logo', 'Logo'], ['m-del', 'Supprimer'], ['m-session', 'Session'], ['m-share', 'Partager']]],
    ['États', [['loading', 'Chargement'], ['empty', 'Vide'], ['alerts', 'Bandeaux'], ['404', '404'], ['net', 'Hors réseau'], ['500', 'Erreur 500'], ['legal', 'Légal']]],
  ];

  return (
    <div style={{ minHeight: '100vh', background: 'radial-gradient(120% 80% at 50% 0%, #eef1f5 0%, #e6eaef 60%, #dfe4ea 100%)', display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '20px 16px 60px' }}>
      <div className="gallery">
        {cats.map(([label, items]) => (
          <React.Fragment key={label}>
            <div className="gcat">{label}</div>
            {items.map(([k, l]) => <button key={k} className={view === k ? 'on' : ''} onClick={() => setView(k)}>{l}</button>)}
          </React.Fragment>
        ))}
      </div>
      <PhoneL6>
        {isModal ? <><AppBackdrop /><ModalComp close={() => setView('biblio')} /></> : content}
      </PhoneL6>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<><IconSprite /><Lot6 /></>);
