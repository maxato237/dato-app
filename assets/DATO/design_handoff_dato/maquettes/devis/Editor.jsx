/* ============================================================
   DATO — Éditeur de devis (écran central)
   Drag & drop, calculs en direct, montant en lettres, auto-save.
   ============================================================ */
const { useState, useRef, useEffect } = React;

/* ---- Saisie d'un montant (séparateur d'espace en direct) ---- */
function MoneyInput({ value, onChange, className, placeholder, ...rest }) {
  return (
    <input
      type="text" inputMode="numeric" className={className} placeholder={placeholder}
      value={value ? window.DATO.formatMoney(value) : ''}
      onChange={(e) => { const d = e.target.value.replace(/[^\d]/g, ''); onChange(d ? parseInt(d, 10) : 0); }}
      {...rest}
    />
  );
}
function IntInput({ value, onChange, className, ...rest }) {
  return (
    <input
      type="text" inputMode="numeric" className={className}
      value={value || ''}
      onChange={(e) => { const d = e.target.value.replace(/[^\d]/g, ''); onChange(d ? parseInt(d, 10) : 0); }}
      {...rest}
    />
  );
}

/* ---- Désignation avec auto-complétion bibliothèque ---- */
function DesignationInput({ value, onChange, onPick, library }) {
  const [open, setOpen] = useState(false);
  const wrap = useRef(null);
  const q = (value || '').toLowerCase().trim();
  const matches = q.length >= 1
    ? library.filter((a) => a.name.toLowerCase().includes(q) && a.name.toLowerCase() !== q).slice(0, 5)
    : [];
  useEffect(() => {
    function out(e) { if (wrap.current && !wrap.current.contains(e.target)) setOpen(false); }
    document.addEventListener('pointerdown', out);
    return () => document.removeEventListener('pointerdown', out);
  }, []);
  return (
    <div className="ac-wrap" ref={wrap}>
      <input
        className="line-des" placeholder="Désignation…" value={value}
        onChange={(e) => { onChange(e.target.value); setOpen(true); }}
        onFocus={() => setOpen(true)}
      />
      {open && matches.length > 0 && (
        <div className="ac-list">
          {matches.map((a) => (
            <div key={a.name} className="ac-item" onPointerDown={(e) => { e.preventDefault(); onPick(a); setOpen(false); }}>
              <span>{a.name}</span><span className="p">{window.DATO.formatMoney(a.pu)}</span>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

/* ---- Une ligne de section (matériel) ---- */
function LineRow({ line, library, onChange, onPick, onDelete }) {
  const pt = (Number(line.qty) || 0) * (Number(line.pu) || 0);
  return (
    <div className="line">
      <div className="lh" data-handle="line"><Ic name="grip" size={18} /></div>
      <div className="line-main">
        <DesignationInput
          value={line.designation} library={library}
          onChange={(v) => onChange({ designation: v })}
          onPick={(a) => onPick(a)}
        />
        <div className="line-nums">
          <div className="mini"><label>Qté</label><IntInput className="mini-inp" value={line.qty} onChange={(v) => onChange({ qty: v })} /></div>
          <span style={{ color: 'var(--text-3)', marginTop: 14 }}>×</span>
          <div className="mini"><label>P.U</label><MoneyInput className="mini-inp wide" value={line.pu} onChange={(v) => onChange({ pu: v })} /></div>
          <div className="mini" style={{ flex: 1 }}><label>P.T</label><div className="pt">{window.DATO.formatMoney(pt)}</div></div>
        </div>
      </div>
      <button className="line-del" onClick={onDelete} aria-label="Supprimer"><Ic name="trash" size={17} /></button>
    </div>
  );
}

/* ---- Carte Section ---- */
function SectionCard({ section, library, onTitle, onLines, onAddLine, onDelete }) {
  const sub = window.DATO.sectionTotal(section);
  return (
    <div className="sec">
      <div className="sec-head">
        <div className="handle" data-handle="section"><Ic name="grip" size={19} /></div>
        <input className="sec-title-inp" value={section.title} onChange={(e) => onTitle(e.target.value)} placeholder="Titre de la section" />
        <button className="iconbtn" onClick={onDelete} aria-label="Supprimer la section"><Ic name="trash" size={18} /></button>
      </div>
      <Sortable
        items={section.lines} getKey={(l) => l.id} handle='[data-handle="line"]'
        onChange={(lines) => onLines(lines)}
        renderItem={(l) => (
          <LineRow
            line={l} library={library}
            onChange={(p) => onLines(section.lines.map((x) => x.id === l.id ? { ...x, ...p } : x))}
            onPick={(a) => onLines(section.lines.map((x) => x.id === l.id ? { ...x, designation: a.name, pu: a.pu } : x))}
            onDelete={() => onLines(section.lines.filter((x) => x.id !== l.id))}
          />
        )}
      />
      <button className="addline" onClick={onAddLine}><Ic name="plus" size={17} /> Ajouter une ligne</button>
      <div className="sub-row"><span>Total {section.title || 'section'}</span><span className="v">{window.DATO.formatFCFA(sub)}</span></div>
    </div>
  );
}

/* ---- Carte Rubrique (forfait / formule) ---- */
function RubriqueCard({ rub, onLabel, onLines, onDelete }) {
  const D = window.DATO;
  const total = D.rubriqueTotal(rub);
  function setLine(id, p) { onLines(rub.lines.map((l) => l.id === id ? { ...l, ...p } : l)); }
  function addSub() { onLines([...rub.lines, { id: D.uid(), mode: 'formula', sublabel: '', a: 0, b: 0 }]); }
  function delSub(id) { onLines(rub.lines.filter((l) => l.id !== id)); }
  return (
    <div className="rub">
      <div className="rub-head">
        <div className="handle" data-handle="rub"><Ic name="grip" size={19} /></div>
        <input className="rub-label" value={rub.label} onChange={(e) => onLabel(e.target.value)} placeholder="Ex. Transport, Usinage, Main d'œuvre…" />
        <span className="rub-total">{D.formatMoney(total)}</span>
        <button className="iconbtn" onClick={onDelete} aria-label="Supprimer"><Ic name="trash" size={18} /></button>
      </div>
      {rub.lines.map((l) => (
        <div className="rub-line" key={l.id}>
          <div className="seg-mini">
            <button className={l.mode === 'forfait' ? 'on' : ''} onClick={() => setLine(l.id, { mode: 'forfait' })}>Forfait</button>
            <button className={l.mode === 'formula' ? 'on' : ''} onClick={() => setLine(l.id, { mode: 'formula' })}>A × B</button>
          </div>
          {l.mode === 'forfait' ? (
            <div className="formula" style={{ justifyContent: 'flex-end' }}>
              <MoneyInput className="f-inp" style={{ width: 96 }} value={l.amount} onChange={(v) => setLine(l.id, { amount: v })} placeholder="Montant" />
            </div>
          ) : (
            <div className="formula">
              <MoneyInput className="f-inp" value={l.a} onChange={(v) => setLine(l.id, { a: v })} placeholder="A" />
              <span className="times">×</span>
              <IntInput className="f-inp" style={{ width: 46 }} value={l.b} onChange={(v) => setLine(l.id, { b: v })} placeholder="B" />
              <span className="eq">=</span>
              <span className="res">{D.formatMoney(D.rubriqueLineTotal(l))}</span>
            </div>
          )}
          {rub.lines.length > 1 && <button className="iconbtn" style={{ width: 32, height: 32 }} onClick={() => delSub(l.id)}><Ic name="x" size={16} /></button>}
        </div>
      ))}
      {rub.lines.length >= 1 && rub.lines.some((l) => l.mode === 'formula') && (
        <button className="addline" style={{ fontSize: 12.5, padding: '9px 14px' }} onClick={addSub}><Ic name="plus" size={15} /> Sous-ligne (ex. Planches, Madriers…)</button>
      )}
    </div>
  );
}

/* ============================================================
   ÉCRAN ÉDITEUR
   ============================================================ */
function Editor({ company, quote, setQuote, library, onPreview, onShare, onBack, saveStatus, offline, showCoach, onCoachDone }) {
  const D = window.DATO;
  const total = D.grandTotal(quote);
  const [triedSave, setTriedSave] = useState(false);
  const clientErr = triedSave && !quote.client.trim();

  function patch(p) { setQuote((q) => ({ ...q, ...p })); }
  function setSections(fn) { setQuote((q) => ({ ...q, sections: fn(q.sections) })); }
  function setRubriques(fn) { setQuote((q) => ({ ...q, rubriques: fn(q.rubriques) })); }

  function addSection() { setSections((s) => [...s, { id: D.uid(), title: 'Nouvelle section', lines: [{ id: D.uid(), designation: '', qty: 1, pu: 0 }] }]); }
  function addRubrique() { setRubriques((r) => [...r, { id: D.uid(), label: 'Nouvelle rubrique', lines: [{ id: D.uid(), mode: 'forfait', amount: 0 }] }]); }
  function addSig() { setQuote((q) => ({ ...q, signatures: [...q.signatures, { id: D.uid(), label: 'Signature' }] })); }

  return (
    <div className="app-scroll">
      {/* En-tête */}
      <div className="ed-header">
        <button className="iconbtn" onClick={onBack} aria-label="Retour"><Ic name="chevron-l" size={24} /></button>
        <div className="ed-title">
          <div className="t">{quote.object ? quote.object : 'Nouveau devis'}</div>
          <div className={'ed-save ' + (saveStatus === 'saving' ? 'saving' : 'saved')}>
            {saveStatus === 'saving'
              ? (<><span className="spin"></span> Enregistrement…</>)
              : (<><Ic name="cloud-check" size={13} /> Enregistré</>)}
          </div>
        </div>
        <button className="iconbtn bordered" onClick={onPreview} aria-label="Aperçu"><Ic name="eye" size={20} /></button>
      </div>

      {offline && (
        <div className="banner offline"><Ic name="wifi-off" size={16} /> Mode hors ligne — vos modifications sont sauvegardées localement</div>
      )}

      <div className="ed-body">
        {/* En-tête entreprise (lecture seule) */}
        <div className="card">
          <div className="company">
            <div className="logo">{company.name.charAt(0)}</div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div className="nm">{company.name}</div>
              <div className="act">{company.activity}</div>
              <div className="lock"><Ic name="info" size={12} /> En-tête modifiable dans Réglages</div>
            </div>
          </div>
        </div>

        {/* Infos devis */}
        <div className="card pad">
          <label className="field">
            <span className="field-lbl">Objet du devis</span>
            <input className="inp" value={quote.object} onChange={(e) => patch({ object: e.target.value })} placeholder="Ex. Fabrication de 40 chaises…" />
          </label>
          <label className="field">
            <span className="field-lbl">Client <span className="req">DOIT&nbsp;·&nbsp;obligatoire</span></span>
            <input className={'inp' + (clientErr ? ' err' : '')} value={quote.client} onChange={(e) => patch({ client: e.target.value })} placeholder="Nom du client" />
            {clientErr && <span className="err-msg"><Ic name="alert" size={13} /> Le nom du client est obligatoire</span>}
          </label>
          <div className="row2" style={{ marginTop: 12 }}>
            <label className="field" style={{ marginTop: 0 }}>
              <span className="field-lbl">Date</span>
              <input type="date" className="inp" value={quote.date} onChange={(e) => patch({ date: e.target.value })} />
            </label>
            <label className="field" style={{ marginTop: 0 }}>
              <span className="field-lbl">N° (auto)</span>
              <input className="inp" value={quote.number} disabled />
            </label>
          </div>
        </div>

        {/* Sections */}
        <div className="kicker" style={{ marginTop: 4 }}>Sections & lignes</div>
        <Sortable
          items={quote.sections} getKey={(s) => s.id} gap={14} handle='[data-handle="section"]'
          onChange={(secs) => setSections(() => secs)}
          renderItem={(sec) => (
            <SectionCard
              section={sec} library={library}
              onTitle={(t) => setSections((s) => s.map((x) => x.id === sec.id ? { ...x, title: t } : x))}
              onLines={(lines) => setSections((s) => s.map((x) => x.id === sec.id ? { ...x, lines } : x))}
              onAddLine={() => setSections((s) => s.map((x) => x.id === sec.id ? { ...x, lines: [...x.lines, { id: D.uid(), designation: '', qty: 1, pu: 0 }] } : x))}
              onDelete={() => setSections((s) => s.filter((x) => x.id !== sec.id))}
            />
          )}
        />
        <button className="add-dashed" onClick={addSection}><Ic name="layers" size={18} /> Ajouter une section</button>

        {/* Rubriques */}
        <div className="kicker" style={{ marginTop: 6 }}>Rubriques (transport, usinage, main d'œuvre…)</div>
        <Sortable
          items={quote.rubriques} getKey={(r) => r.id} gap={12} handle='[data-handle="rub"]'
          onChange={(rs) => setRubriques(() => rs)}
          renderItem={(rub) => (
            <RubriqueCard
              rub={rub}
              onLabel={(t) => setRubriques((r) => r.map((x) => x.id === rub.id ? { ...x, label: t } : x))}
              onLines={(lines) => setRubriques((r) => r.map((x) => x.id === rub.id ? { ...x, lines } : x))}
              onDelete={() => setRubriques((r) => r.filter((x) => x.id !== rub.id))}
            />
          )}
        />
        <button className="add-dashed amber" onClick={addRubrique}><Ic name="plus" size={18} /> Ajouter une rubrique</button>

        {/* Total + lettres */}
        <div className="total-card">
          <div className="lab">Total général</div>
          <div className="big">{D.formatFCFA(total)}</div>
        </div>
        <div className="lettres">
          <span className="auto"><Ic name="check" size={12} /> Généré automatiquement</span><br />
          Arrêté le présent devis à la somme de <b>{D.montantEnLettres(total)}</b>.
        </div>

        {/* Signatures */}
        <div className="kicker" style={{ marginTop: 6 }}>Blocs de signature</div>
        <div className="card pad">
          <div className="sig-grid">
            {quote.signatures.map((s) => (
              <div className="sig-chip" key={s.id}>
                <Ic name="pen" size={15} style={{ color: 'var(--text-3)' }} />
                <input value={s.label} onChange={(e) => setQuote((q) => ({ ...q, signatures: q.signatures.map((x) => x.id === s.id ? { ...x, label: e.target.value } : x) }))} />
                <span className="rm" onClick={() => setQuote((q) => ({ ...q, signatures: q.signatures.filter((x) => x.id !== s.id) }))}><Ic name="x" size={15} /></span>
              </div>
            ))}
            <button className="sig-chip" style={{ cursor: 'pointer', color: 'var(--ink)', fontWeight: 600 }} onClick={addSig}><Ic name="plus" size={15} /> Ajouter</button>
          </div>
        </div>
      </div>

      {/* Coach mark drag & drop */}
      {showCoach && (
        <div className="coach" style={{ left: 14, top: 250 }}>
          <div className="arrow" style={{ left: 18, top: -6 }}></div>
          <div className="ctitle"><Ic name="grip" size={16} /> Glisser pour réorganiser</div>
          Maintenez la poignée <b>⠿</b> et glissez pour déplacer une section ou une ligne.
          <div><button onClick={onCoachDone}>J'ai compris</button></div>
        </div>
      )}

      {/* Barre d'action */}
      <div className="actionbar">
        <button className="btn btn-secondary btn-grow" onClick={onPreview}><Ic name="eye" size={19} /> Aperçu</button>
        <button className="btn btn-wa btn-grow" onClick={() => { if (!quote.client.trim()) { setTriedSave(true); return; } onShare(); }}>
          <Ic name="whatsapp" size={19} /> Partager
        </button>
      </div>
    </div>
  );
}
window.Editor = Editor;
