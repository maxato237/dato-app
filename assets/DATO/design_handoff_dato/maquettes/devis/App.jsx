/* ============================================================
   DATO — Host : cadre téléphone, navigation, auto-save, overlays
   ============================================================ */

function Phone({ children }) {
  return (
    <div style={{
      width: 402, height: 858, borderRadius: 44, background: '#0c1116',
      padding: 9, boxShadow: '0 40px 90px rgba(16,24,40,.34)', flex: 'none',
    }}>
      <div style={{ width: '100%', height: '100%', borderRadius: 36, overflow: 'hidden', background: '#fff', display: 'flex', flexDirection: 'column', position: 'relative' }}>
        <AndroidStatusBar />
        <div style={{ flex: 1, position: 'relative', overflow: 'hidden' }}>
          {children}
        </div>
        <div style={{ height: 22, display: 'grid', placeItems: 'center', background: '#fff' }}>
          <div style={{ width: 120, height: 4, borderRadius: 2, background: '#101828', opacity: .35 }} />
        </div>
      </div>
    </div>
  );
}

function App() {
  const DATA = window.DATO_DATA;
  const STORE = 'dato_quote_v1';
  const [quote, setQuote] = useState(() => {
    try { const s = localStorage.getItem(STORE); if (s) return JSON.parse(s); } catch (e) {}
    return DATA.quote;
  });
  const [view, setView] = useState('editor'); // editor | preview | public
  const [saveStatus, setSaveStatus] = useState('saved');
  const [shareOpen, setShareOpen] = useState(false);
  const [offline, setOffline] = useState(false);
  const [coach, setCoach] = useState(() => { try { return !localStorage.getItem('dato_coach'); } catch (e) { return true; } });
  const [toast, setToast] = useState(null);
  const first = useRef(true);
  const tTimer = useRef(null);

  // Auto-enregistrement
  useEffect(() => {
    try { localStorage.setItem(STORE, JSON.stringify(quote)); } catch (e) {}
    if (first.current) { first.current = false; return; }
    setSaveStatus('saving');
    const t = setTimeout(() => setSaveStatus('saved'), 850);
    return () => clearTimeout(t);
  }, [quote]);

  function showToast(msg, kind) {
    setToast({ msg, kind });
    clearTimeout(tTimer.current);
    tTimer.current = setTimeout(() => setToast(null), 2400);
  }
  function dismissCoach() { setCoach(false); try { localStorage.setItem('dato_coach', '1'); } catch (e) {} }

  const screen =
    view === 'preview' ? <Preview company={DATA.company} quote={quote} onBack={() => setView('editor')} onShare={() => setShareOpen(true)} onToast={showToast} />
    : view === 'public' ? <PublicView company={DATA.company} quote={quote} onToast={showToast} />
    : <Editor company={DATA.company} quote={quote} setQuote={setQuote} library={DATA.library}
        onPreview={() => setView('preview')} onShare={() => setShareOpen(true)} onBack={() => showToast('Retour au tableau de bord (Lot 3)', 'save')}
        saveStatus={saveStatus} offline={offline} showCoach={coach && view === 'editor'} onCoachDone={dismissCoach} />;

  return (
    <div style={{ minHeight: '100vh', background: 'radial-gradient(120% 80% at 50% 0%, #eef1f5 0%, #e6eaef 60%, #dfe4ea 100%)', display: 'flex', flexDirection: 'column', alignItems: 'center', padding: '26px 16px 60px' }}>
      {/* Bandeau démo */}
      <div style={{ display: 'flex', alignItems: 'center', gap: 14, marginBottom: 22, flexWrap: 'wrap', justifyContent: 'center' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 9 }}>
          <div style={{ width: 34, height: 34, borderRadius: 9, background: 'var(--ink)', color: '#fff', display: 'grid', placeItems: 'center', fontFamily: 'var(--font-head)', fontWeight: 800 }}>D</div>
          <div>
            <div style={{ fontFamily: 'var(--font-head)', fontWeight: 700, fontSize: 15, color: 'var(--text)' }}>DATO — Éditeur de devis</div>
            <div style={{ fontSize: 12, color: 'var(--text-2)' }}>Lot 2/8 · prototype interactif (mobile)</div>
          </div>
        </div>
        <div style={{ display: 'flex', gap: 6, background: '#fff', border: '1px solid var(--border)', borderRadius: 10, padding: 4, boxShadow: 'var(--sh-1)' }}>
          {[['editor', 'Éditeur'], ['preview', 'Aperçu'], ['public', 'Vue publique']].map(([k, l]) => (
            <button key={k} onClick={() => setView(k)} style={{
              border: 0, background: view === k ? 'var(--ink)' : 'transparent', color: view === k ? '#fff' : 'var(--text-2)',
              fontFamily: 'var(--font-head)', fontWeight: 600, fontSize: 13, padding: '8px 13px', borderRadius: 7, cursor: 'pointer',
            }}>{l}</button>
          ))}
        </div>
        <button onClick={() => setOffline((o) => !o)} style={{
          border: '1px solid var(--border)', background: offline ? 'var(--amber-100)' : '#fff', color: offline ? 'var(--amber-700)' : 'var(--text-2)',
          fontFamily: 'var(--font-head)', fontWeight: 600, fontSize: 12.5, padding: '9px 13px', borderRadius: 9, cursor: 'pointer', boxShadow: 'var(--sh-1)',
        }}>{offline ? '● Hors ligne' : '○ Hors ligne'}</button>
      </div>

      <Phone>
        <div style={{ position: 'absolute', inset: 0, overflowY: 'auto', WebkitOverflowScrolling: 'touch' }}>
          {screen}
        </div>
        <ShareSheet open={shareOpen} onClose={() => setShareOpen(false)} onToast={showToast} quote={quote} />
        <Toast toast={toast} />
      </Phone>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<><IconSprite /><App /></>);
