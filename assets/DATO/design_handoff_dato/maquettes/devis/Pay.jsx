/* ============================================================
   DATO — Lot 5 : flux Paiement (interactif)
   ============================================================ */
const { useState, useEffect } = React;
const APP_URL = encodeURI('Application DATO.html');
const fM = (n) => window.DATO.formatMoney(n);

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
function Head({ title, onBack }) {
  return (
    <div className="pay-head">
      {onBack && <button className="iconbtn" onClick={onBack}><Ic name="chevron-l" size={23} /></button>}
      <h1>{title}</h1>
    </div>
  );
}

const PLANS = {
  monthly: { amt: 2500, per: '/ mois', sub: 'Facturé chaque mois', total: 2500, label: 'Pro Mensuel' },
  yearly: { amt: 2000, per: '/ mois', sub: '24 000 FCFA facturés une fois par an', total: 24000, label: 'Pro Annuel' },
};

/* ---- 1. Paywall ---- */
function Paywall({ go }) {
  return (
    <div className="pay-screen">
      <Head title="" onBack={() => window.location.href = APP_URL} />
      <div className="paywall">
        <div className="lock"><Ic name="info" size={40} /></div>
        <h2>Vous avez utilisé vos 3 devis gratuits</h2>
        <div className="lead">Passez à DATO Pro pour créer des devis en illimité et débloquer toutes les fonctionnalités.</div>
        <div className="benefits">
          {[
            ['Devis illimités', 'Créez autant de devis que nécessaire'],
            ['Suppression du filigrane', 'Vos PDF 100 % à votre image'],
            ['Bibliothèque d\u2019articles illimitée', 'Réutilisez vos prix en un tap'],
            ['Support prioritaire WhatsApp', 'Une question ? Réponse rapide'],
          ].map(([t, s]) => (
            <div className="benefit" key={t}>
              <span className="ic"><Ic name="check" size={15} /></span>
              <span className="t">{t}<span>{s}</span></span>
            </div>
          ))}
        </div>
        <button className="btn btn-amber" onClick={() => go('plans')}><Ic name="check-circle" size={19} /> Passer à DATO Pro</button>
        <button className="btn btn-ghost" style={{ marginTop: 8 }} onClick={() => window.location.href = APP_URL}>Plus tard</button>
      </div>
    </div>
  );
}

/* ---- 2. Choix du plan ---- */
function Plans({ go, billing, setBilling }) {
  const p = PLANS[billing];
  return (
    <div className="pay-screen">
      <Head title="Choisir un plan" onBack={() => go('paywall')} />
      <div className="plans">
        <div className="bill-toggle">
          <button className={billing === 'monthly' ? 'on' : ''} onClick={() => setBilling('monthly')}>Mensuel</button>
          <button className={billing === 'yearly' ? 'on' : ''} onClick={() => setBilling('yearly')}>Annuel <span className="save">−20%</span></button>
        </div>

        <div className="plan-card">
          <div className="pname">Gratuit</div>
          <div className="price"><span className="amt">0</span><span className="per">FCFA</span></div>
          <div className="sub">Votre forfait actuel</div>
          <ul className="plan-feats">
            <li><span className="c"><Ic name="check" size={16} /></span> 3 devis par mois</li>
            <li><span className="c"><Ic name="check" size={16} /></span> Partage WhatsApp & PDF</li>
            <li className="off"><span className="c"><Ic name="x" size={16} /></span> Filigrane DATO sur les PDF</li>
            <li className="off"><span className="c"><Ic name="x" size={16} /></span> Bibliothèque limitée</li>
          </ul>
        </div>

        <div className="plan-card pro">
          <span className="ribbon">RECOMMANDÉ</span>
          <div className="pname">DATO Pro</div>
          <div className="price"><span className="amt">{fM(p.amt)}</span><span className="per">FCFA {p.per}</span></div>
          <div className="sub">{p.sub}</div>
          <ul className="plan-feats">
            <li><span className="c"><Ic name="check" size={16} /></span> <b>Devis illimités</b></li>
            <li><span className="c"><Ic name="check" size={16} /></span> Aucun filigrane</li>
            <li><span className="c"><Ic name="check" size={16} /></span> Bibliothèque d'articles illimitée</li>
            <li><span className="c"><Ic name="check" size={16} /></span> Support prioritaire WhatsApp</li>
          </ul>
        </div>
      </div>
      <div className="pay-foot">
        <button className="btn btn-primary" onClick={() => go('operator')}>Continuer · {fM(p.total)} FCFA</button>
        <div className="secure-note"><Ic name="info" size={13} /> Paiement sécurisé par Mobile Money</div>
      </div>
    </div>
  );
}

/* ---- 3. Opérateur + numéro ---- */
function Operator({ go, billing }) {
  const p = PLANS[billing];
  const [op, setOp] = useState('mtn');
  const [num, setNum] = useState('674 70 20 37');
  return (
    <div className="pay-screen">
      <Head title="Paiement" onBack={() => go('plans')} />
      <div className="pay-body">
        <div className="recap">
          <div className="row"><span>{p.label}</span><span className="v">{fM(p.amt)} FCFA{billing === 'monthly' ? '/mois' : ''}</span></div>
          {billing === 'yearly' && <div className="row" style={{ color: 'var(--green-700)' }}><span>Économie annuelle</span><span className="v">−6 000 FCFA</span></div>}
          <div className="row tot"><span>Total à payer</span><span className="v">{fM(p.total)} FCFA</span></div>
        </div>

        <div className="op-label">Opérateur Mobile Money</div>
        <div className="ops">
          <div className={'op' + (op === 'mtn' ? ' on' : '')} onClick={() => setOp('mtn')}>
            <div className="badge-op mtn">MTN<br/>MoMo</div>
            <div className="nm">MTN Mobile Money<span>Numéros 67x, 650–654, 680–684</span></div>
            <div className="radio"></div>
          </div>
          <div className={'op' + (op === 'orange' ? ' on' : '')} onClick={() => setOp('orange')}>
            <div className="badge-op orange">Orange<br/>Money</div>
            <div className="nm">Orange Money<span>Numéros 69x, 655–659, 685–689</span></div>
            <div className="radio"></div>
          </div>
        </div>

        <label className="f"><span className="field-lbl" style={{ fontWeight: 600, fontSize: 13.5, marginBottom: 7, display: 'block' }}>Numéro {op === 'mtn' ? 'MTN' : 'Orange'}</span>
          <div className="with-prefix" style={{ display: 'flex', alignItems: 'center', border: '1.5px solid var(--border-strong)', borderRadius: 'var(--r-md)', background: '#fff', overflow: 'hidden' }}>
            <span className="px" style={{ padding: '0 12px', color: 'var(--text-2)', fontWeight: 600, fontSize: 16, borderRight: '1.5px solid var(--border)', alignSelf: 'stretch', display: 'flex', alignItems: 'center', background: 'var(--bg)' }}>+237</span>
            <input inputMode="tel" value={num} onChange={(e) => setNum(e.target.value)} style={{ flex: 1, border: 0, minHeight: 52, padding: '0 14px', fontSize: 16, background: 'transparent', outline: 'none' }} />
          </div>
        </label>
      </div>
      <div className="pay-foot">
        <button className="btn btn-primary" onClick={() => go('waiting')}><Ic name="phone" size={18} /> Payer {fM(p.total)} FCFA</button>
        <div className="secure-note"><Ic name="info" size={13} /> Vous validerez la demande sur votre téléphone</div>
      </div>
    </div>
  );
}

/* ---- 4. En attente de validation ---- */
function Waiting({ go }) {
  useEffect(() => { const id = setTimeout(() => go('success'), 4200); return () => clearTimeout(id); }, []);
  return (
    <div className="pay-screen">
      <Head title="Validation en cours" />
      <div className="pay-wait">
        <div className="pulse-phone"><Ic name="phone" size={42} /></div>
        <h2>Validez sur votre téléphone</h2>
        <div className="lead">Une demande de paiement a été envoyée. Confirmez-la avec votre code secret Mobile Money.</div>
        <div className="ussd">#150# · Saisir le code PIN</div>
        <div className="wait-steps">
          <div className="ws"><span className="n">1</span><span>Une fenêtre s'ouvre sur votre téléphone (ou composez <b>*126#</b>)</span></div>
          <div className="ws"><span className="n">2</span><span>Saisissez votre <b>code secret</b> Mobile Money</span></div>
          <div className="ws"><span className="n">3</span><span>Patientez, la confirmation est automatique</span></div>
        </div>
        <div style={{ marginTop: 30 }}><div className="wait-spinner"></div><div style={{ textAlign: 'center', fontSize: 12.5, color: 'var(--text-3)', marginTop: 10 }}>En attente de confirmation…</div></div>
        <button className="btn btn-ghost" style={{ marginTop: 18, width: '100%' }} onClick={() => go('failed')}>Annuler</button>
      </div>
    </div>
  );
}

/* ---- 5a. Succès ---- */
function Success({ billing }) {
  const p = PLANS[billing];
  const today = new Date();
  const exp = new Date(today); if (billing === 'yearly') exp.setFullYear(exp.getFullYear() + 1); else exp.setMonth(exp.getMonth() + 1);
  const FRM = ['janv.','févr.','mars','avr.','mai','juin','juil.','août','sept.','oct.','nov.','déc.'];
  const fd = (d) => `${d.getDate()} ${FRM[d.getMonth()]} ${d.getFullYear()}`;
  return (
    <div className="pay-screen">
      <div className="pay-result">
        <div className="result-burst ok"><Ic name="check" size={50} /></div>
        <h2>Paiement réussi&nbsp;!</h2>
        <div className="lead">Bienvenue dans <b>DATO Pro</b>. Vos devis sont désormais illimités.</div>
        <div className="receipt">
          <div className="row"><span className="k">Plan</span><span className="v">{p.label}</span></div>
          <div className="row"><span className="k">Montant</span><span className="v">{fM(p.total)} FCFA</span></div>
          <div className="row"><span className="k">Méthode</span><span className="v">MTN Mobile Money</span></div>
          <div className="row"><span className="k">Référence</span><span className="v">MP260604.1847</span></div>
          <div className="row"><span className="k">Valable jusqu'au</span><span className="v">{fd(exp)}</span></div>
        </div>
        <button className="btn btn-primary" onClick={() => window.location.href = APP_URL}><Ic name="check-circle" size={19} /> Commencer</button>
      </div>
    </div>
  );
}

/* ---- 5b. Échec ---- */
function Failed({ go }) {
  return (
    <div className="pay-screen">
      <div className="pay-result">
        <div className="result-burst fail"><Ic name="x" size={50} /></div>
        <h2>Paiement non abouti</h2>
        <div className="lead">La transaction a été annulée ou a expiré. Aucun montant n'a été débité.</div>
        <button className="btn btn-primary" onClick={() => go('operator')}>Réessayer</button>
        <button className="btn btn-ghost" style={{ marginTop: 8 }} onClick={() => window.location.href = APP_URL}>Retour à l'accueil</button>
      </div>
    </div>
  );
}

/* ---- 6. Abonnement & facturation ---- */
function Subscription({ go }) {
  const history = [
    { d: '4 mai 2026', m: 'MTN MoMo', op: 'mtn', amt: 2500, plan: 'Pro Mensuel' },
    { d: '4 avr. 2026', m: 'MTN MoMo', op: 'mtn', amt: 2500, plan: 'Pro Mensuel' },
    { d: '4 mars 2026', m: 'Orange Money', op: 'orange', amt: 2500, plan: 'Pro Mensuel' },
  ];
  return (
    <div className="pay-screen">
      <Head title="Abonnement" onBack={() => window.location.href = APP_URL} />
      <div className="sub-screen">
        <div className="cur-plan">
          <span className="tag"><Ic name="check-circle" size={13} /> DATO Pro · Actif</span>
          <h2>Pro Mensuel</h2>
          <div className="exp">Se renouvelle le <b>4 juin 2026</b> · 2 500 FCFA/mois</div>
          <button className="renew" onClick={() => go('plans')}>Gérer / changer de plan</button>
        </div>
        <div className="hist-title">Historique des paiements</div>
        {history.map((h, i) => (
          <div className="pay-row" key={i}>
            <div className={'pm ' + h.op}>{h.op === 'mtn' ? 'MTN' : 'OM'}</div>
            <div className="info"><div className="d">{h.plan}</div><div className="m">{h.d} · {h.m}</div></div>
            <div><div className="amt">{fM(h.amt)} FCFA</div><div className="ok"><Ic name="check" size={11} /> Payé</div></div>
          </div>
        ))}
      </div>
    </div>
  );
}

/* ---- Flow host ---- */
function PayFlow() {
  const [view, setView] = useState('paywall');
  const [billing, setBilling] = useState('yearly');
  const go = (v) => setView(v);
  const map = {
    paywall: <Paywall go={go} />,
    plans: <Plans go={go} billing={billing} setBilling={setBilling} />,
    operator: <Operator go={go} billing={billing} />,
    waiting: <Waiting go={go} />,
    success: <Success billing={billing} />,
    failed: <Failed go={go} />,
    subscription: <Subscription go={go} />,
  };
  const tabs = [['paywall', 'Paywall'], ['plans', 'Plans'], ['operator', 'Opérateur'], ['waiting', 'En attente'], ['success', 'Succès'], ['failed', 'Échec'], ['subscription', 'Abonnement']];
  return (
    <div style={{ minHeight: '100vh', background: 'radial-gradient(120% 80% at 50% 0%, #eef1f5 0%, #e6eaef 60%, #dfe4ea 100%)', display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '24px 16px 60px' }}>
      <div className="demo-bar">{tabs.map(([k, l]) => <button key={k} className={view === k ? 'on' : ''} onClick={() => go(k)}>{l}</button>)}</div>
      <Phone>{map[view]}</Phone>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<><IconSprite /><PayFlow /></>);
