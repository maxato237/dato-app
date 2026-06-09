/* ============================================================
   DATO — Auth & Onboarding (flux interactif)
   ============================================================ */
const { useState, useRef, useEffect } = React;
const APP_URL = encodeURI('Application DATO.html');
const EDITOR_URL = encodeURI('Éditeur de devis.html');

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

function PwField({ value, onChange, placeholder }) {
  const [show, setShow] = useState(false);
  return (
    <div className="pwfield">
      <input className="ipt" type={show ? 'text' : 'password'} value={value} onChange={(e) => onChange(e.target.value)} placeholder={placeholder || '••••••••'} />
      <span className="eye" onClick={() => setShow((s) => !s)}><Ic name="eye" size={20} /></span>
    </div>
  );
}

function Hero({ title, sub, onBack }) {
  return (
    <div className="auth-hero">
      <div className="brand">
        {onBack
          ? <span onClick={onBack} style={{ cursor: 'pointer', marginRight: 2 }}><Ic name="chevron-l" size={24} /></span>
          : <span className="b">D</span>}
        <span className="nm">DATO</span>
      </div>
      <h1>{title}</h1>
      {sub && <p>{sub}</p>}
    </div>
  );
}

/* ---- Inscription ---- */
function Signup({ go }) {
  const [phone, setPhone] = useState('674 70 20 37');
  return (
    <div className="auth">
      <Hero title="Créez votre compte" sub="Vos premiers devis professionnels en quelques minutes. C'est gratuit." />
      <div className="auth-card">
        <div className="f"><label>Nom complet</label><input className="ipt" placeholder="Ex. Jean-Pierre Mballa" /></div>
        <div className="f"><label>Téléphone</label><div className="with-prefix"><span className="px">+237</span><input inputMode="tel" value={phone} onChange={(e) => setPhone(e.target.value)} /></div></div>
        <div className="f"><label>E-mail <span className="opt">(optionnel)</span></label><input className="ipt" inputMode="email" placeholder="vous@exemple.com" /></div>
        <div className="f"><label>Mot de passe</label><PwField value="" onChange={() => {}} /><div className="f-hint">8 caractères minimum</div></div>
        <button className="btn btn-primary" onClick={() => go('otp')}>Créer mon compte</button>
        <div className="auth-foot">Déjà un compte ? <a onClick={() => go('login')}>Se connecter</a></div>
      </div>
    </div>
  );
}

/* ---- Connexion ---- */
function Login({ go }) {
  return (
    <div className="auth">
      <Hero title="Content de vous revoir" sub="Connectez-vous pour accéder à vos devis." />
      <div className="auth-card">
        <div className="f"><label>Téléphone ou e-mail</label><input className="ipt" placeholder="+237 6 74 70 20 37" /></div>
        <div className="f"><label>Mot de passe</label><PwField value="" onChange={() => {}} /></div>
        <div className="text-link-row"><span className="link" onClick={() => go('forgot')}>Mot de passe oublié ?</span></div>
        <button className="btn btn-primary" onClick={() => window.location.href = APP_URL}>Se connecter</button>
        <div className="auth-foot">Pas encore de compte ? <a onClick={() => go('signup')}>Créer un compte</a></div>
      </div>
    </div>
  );
}

/* ---- OTP ---- */
function Otp({ go, back }) {
  const [vals, setVals] = useState(['', '', '', '', '', '']);
  const [t, setT] = useState(42);
  const refs = useRef([]);
  useEffect(() => { if (t <= 0) return; const id = setTimeout(() => setT((x) => x - 1), 1000); return () => clearTimeout(id); }, [t]);
  function set(i, v) {
    v = v.replace(/[^\d]/g, '').slice(-1);
    const nv = vals.slice(); nv[i] = v; setVals(nv);
    if (v && i < 5) refs.current[i + 1] && refs.current[i + 1].focus();
  }
  function key(i, e) { if (e.key === 'Backspace' && !vals[i] && i > 0) refs.current[i - 1] && refs.current[i - 1].focus(); }
  const complete = vals.every((v) => v);
  return (
    <div className="auth">
      <Hero title="Vérification" sub="Saisissez le code à 6 chiffres envoyé par SMS au +237 6 74 70 20 37." onBack={() => go(back || 'signup')} />
      <div className="auth-card">
        <div className="otp">
          {vals.map((v, i) => (
            <input key={i} ref={(el) => refs.current[i] = el} className={v ? 'filled' : ''} inputMode="numeric" value={v}
              onChange={(e) => set(i, e.target.value)} onKeyDown={(e) => key(i, e)} />
          ))}
        </div>
        <div className="otp-timer">
          {t > 0 ? <>Renvoyer le code dans <b>0:{String(t).padStart(2, '0')}</b></> : <span className="link" onClick={() => setT(42)}>Renvoyer le code</span>}
        </div>
        <button className="btn btn-primary" style={{ marginTop: 22, opacity: complete ? 1 : .5 }} onClick={() => complete && go('ob1')}>Vérifier</button>
      </div>
    </div>
  );
}

/* ---- Mot de passe oublié ---- */
function Forgot({ go }) {
  return (
    <div className="auth">
      <Hero title="Mot de passe oublié" sub="Indiquez votre numéro, nous vous enverrons un code de réinitialisation." onBack={() => go('login')} />
      <div className="auth-card">
        <div className="f"><label>Téléphone ou e-mail</label><div className="with-prefix"><span className="px">+237</span><input inputMode="tel" defaultValue="674 70 20 37" /></div></div>
        <button className="btn btn-primary" onClick={() => go('reset')}>Envoyer le code</button>
        <div className="auth-foot"><a onClick={() => go('login')}>Retour à la connexion</a></div>
      </div>
    </div>
  );
}

/* ---- Réinitialisation ---- */
function Reset({ go }) {
  const [a, setA] = useState(''); const [b, setB] = useState('');
  const mismatch = b && a !== b;
  return (
    <div className="auth">
      <Hero title="Nouveau mot de passe" sub="Choisissez un mot de passe sûr et facile à retenir." onBack={() => go('forgot')} />
      <div className="auth-card">
        <div className="f"><label>Nouveau mot de passe</label><PwField value={a} onChange={setA} /></div>
        <div className="f"><label>Confirmer le mot de passe</label><PwField value={b} onChange={setB} />{mismatch && <div className="f-err"><Ic name="alert" size={13} /> Les mots de passe ne correspondent pas</div>}</div>
        <button className="btn btn-primary" style={{ opacity: a && a === b ? 1 : .5 }} onClick={() => a && a === b && go('login')}>Réinitialiser</button>
      </div>
    </div>
  );
}

/* ---- Onboarding ---- */
function ObSteps({ step }) {
  return (
    <div className="ob-top">
      <div className="ob-steps">{[1, 2, 3].map((n) => <i key={n} className={step === n ? 'on' : step > n ? 'done' : ''} />)}</div>
      <div className="ob-meta"><span>Étape {step} sur 3</span><span>Configuration</span></div>
    </div>
  );
}

function Ob1({ go }) {
  const [logo, setLogo] = useState(false);
  return (
    <div className="auth" style={{ background: '#fff' }}>
      <ObSteps step={1} />
      <div className="ob-body">
        <h2>En-tête de l'entreprise</h2>
        <div className="lead">Ces informations apparaîtront en haut de chaque devis.</div>
        <div className="logo-drop">
          <div className={'logo-circle' + (logo ? ' filled' : '')} onClick={() => setLogo((l) => !l)}>
            {logo ? <span className="fam">M</span> : <Ic name="plus" size={28} />}
          </div>
          <span className="lbl">{logo ? 'Changer le logo' : 'Ajouter votre logo'}</span>
        </div>
        <div className="f"><label>Nom de l'entreprise</label><input className="ipt" defaultValue="MILLENAIRE DECOR" /></div>
        <div className="f"><label>Activité</label><input className="ipt" defaultValue="Menuiserie générale" /></div>
        <div className="f"><label>Ville</label><input className="ipt" defaultValue="Yaoundé" /></div>
        <div className="f"><label>Téléphone(s)</label><input className="ipt" defaultValue="674 70 20 37 / 695 42 93 71" /></div>
        <div className="f"><label>Devise</label>
          <select className="ipt" defaultValue="FCFA"><option>FCFA</option><option>EUR (€)</option><option>USD ($)</option></select>
        </div>
      </div>
      <div className="ob-footer">
        <button className="btn btn-ghost" style={{ width: 'auto', flex: 'none' }} onClick={() => window.location.href = APP_URL}>Passer</button>
        <button className="btn btn-primary" onClick={() => go('ob2')}>Suivant</button>
      </div>
    </div>
  );
}

function Ob2({ go }) {
  const [sigs, setSigs] = useState(['Le Technicien', 'Le Client']);
  return (
    <div className="auth" style={{ background: '#fff' }}>
      <ObSteps step={2} />
      <div className="ob-body">
        <h2>Blocs de signature</h2>
        <div className="lead">Définissez les signatures affichées en bas de vos devis. Modifiable à tout moment.</div>
        <div className="sig-list">
          {sigs.map((s, i) => (
            <div className="sig-item" key={i}>
              <Ic name="pen" size={17} style={{ color: 'var(--text-3)' }} />
              <input value={s} onChange={(e) => setSigs(sigs.map((x, j) => j === i ? e.target.value : x))} />
              {sigs.length > 1 && <span className="x" onClick={() => setSigs(sigs.filter((_, j) => j !== i))}><Ic name="x" size={17} /></span>}
            </div>
          ))}
        </div>
        <button className="btn btn-outline" onClick={() => setSigs([...sigs, 'Signature'])}><Ic name="plus" size={18} /> Ajouter un bloc</button>
      </div>
      <div className="ob-footer">
        <button className="btn btn-ghost" style={{ width: 'auto', flex: 'none' }} onClick={() => go('ob1')}>Retour</button>
        <button className="btn btn-primary" onClick={() => go('ob3')}>Suivant</button>
      </div>
    </div>
  );
}

function Ob3() {
  return (
    <div className="auth" style={{ background: '#fff' }}>
      <ObSteps step={4} />
      <div className="ob-body" style={{ textAlign: 'center', paddingTop: 40 }}>
        <div className="success-burst"><Ic name="check" size={46} /></div>
        <h2>Tout est prêt&nbsp;!</h2>
        <div className="lead" style={{ maxWidth: 280, margin: '8px auto 28px' }}>Votre entreprise est configurée. Créez dès maintenant votre premier devis professionnel.</div>
        <button className="btn btn-primary" onClick={() => window.location.href = EDITOR_URL}><Ic name="plus" size={20} /> Créer mon premier devis</button>
        <button className="btn btn-ghost" style={{ marginTop: 10 }} onClick={() => window.location.href = APP_URL}>Aller au tableau de bord</button>
      </div>
    </div>
  );
}

/* ---- Flow ---- */
function AuthFlow() {
  const [view, setView] = useState('signup');
  const go = (v) => setView(v);
  const screens = { signup: Signup, login: Login, otp: Otp, forgot: Forgot, reset: Reset, ob1: Ob1, ob2: Ob2, ob3: Ob3 };
  const Screen = screens[view];
  const tabs = [['signup', 'Inscription'], ['login', 'Connexion'], ['otp', 'OTP'], ['forgot', 'Oublié'], ['reset', 'Réinit.'], ['ob1', 'Onboard. 1'], ['ob2', 'Onboard. 2'], ['ob3', 'Onboard. 3']];
  return (
    <div style={{ minHeight: '100vh', background: 'radial-gradient(120% 80% at 50% 0%, #eef1f5 0%, #e6eaef 60%, #dfe4ea 100%)', display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '24px 16px 60px' }}>
      <div className="demo-bar">{tabs.map(([k, l]) => <button key={k} className={view === k ? 'on' : ''} onClick={() => go(k)}>{l}</button>)}</div>
      <Phone><Screen go={go} back={view === 'otp' ? 'signup' : undefined} /></Phone>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<><IconSprite /><AuthFlow /></>);
