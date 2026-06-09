/* ============================================================
   DATO — Logique métier (calculs, formatage, montant en lettres)
   Exposé sur window.DATO
   ============================================================ */
(function () {
  // ---- Formatage des montants : séparateur de milliers par espace ----
  function formatMoney(n) {
    const v = Math.round(Number(n) || 0);
    return v.toLocaleString('fr-FR').replace(/\u202f|\u00a0/g, ' ');
  }
  function formatFCFA(n) { return formatMoney(n) + ' FCFA'; }

  // ---- Nombre → lettres (français) ----
  const U = ['zéro','un','deux','trois','quatre','cinq','six','sept','huit','neuf',
    'dix','onze','douze','treize','quatorze','quinze','seize','dix-sept','dix-huit','dix-neuf'];
  const T = ['','','vingt','trente','quarante','cinquante','soixante','soixante','quatre-vingt','quatre-vingt'];

  function below100(n, noPlural) {
    if (n < 20) return U[n];
    const t = Math.floor(n / 10), u = n % 10;
    if (t === 7) {
      if (u === 0) return 'soixante-dix';
      if (u === 1) return 'soixante-et-onze';
      return 'soixante-' + U[10 + u];
    }
    if (t === 9) return 'quatre-vingt-' + U[10 + u];
    if (t === 8) {
      if (u === 0) return noPlural ? 'quatre-vingt' : 'quatre-vingts';
      return 'quatre-vingt-' + U[u];
    }
    if (u === 0) return T[t];
    if (u === 1) return T[t] + '-et-un';
    return T[t] + '-' + U[u];
  }

  function below1000(n, noPlural) {
    const c = Math.floor(n / 100), r = n % 100;
    let s = '';
    if (c > 0) {
      s = (c === 1) ? 'cent' : U[c] + ' cent';
      if (r === 0 && c > 1 && !noPlural) s += 's';
    }
    if (r > 0) s += (s ? ' ' : '') + below100(r, noPlural);
    return s;
  }

  function toWords(n) {
    n = Math.round(Number(n) || 0);
    if (n === 0) return 'zéro';
    const parts = [];
    const md = Math.floor(n / 1e9); n %= 1e9;
    const mi = Math.floor(n / 1e6); n %= 1e6;
    const ml = Math.floor(n / 1000); n %= 1000;
    const re = n;
    if (md > 0) parts.push(below1000(md) + (md > 1 ? ' milliards' : ' milliard'));
    if (mi > 0) parts.push(below1000(mi) + (mi > 1 ? ' millions' : ' million'));
    if (ml > 0) parts.push(ml === 1 ? 'mille' : below1000(ml, true) + ' mille');
    if (re > 0) parts.push(below1000(re));
    return parts.join(' ');
  }

  function montantEnLettres(n) {
    const w = toWords(n);
    return (w.charAt(0).toUpperCase() + w.slice(1)) + ' francs CFA';
  }

  // ---- Calculs de devis ----
  // Une section "table" : sous-total = Σ qté × pu
  function sectionTotal(sec) {
    return (sec.lines || []).reduce((s, l) => s + (Number(l.qty) || 0) * (Number(l.pu) || 0), 0);
  }
  // Une rubrique : Σ de ses lignes (forfait = montant direct ; formule = a × b)
  function rubriqueLineTotal(l) {
    return l.mode === 'forfait' ? (Number(l.amount) || 0) : (Number(l.a) || 0) * (Number(l.b) || 0);
  }
  function rubriqueTotal(rub) {
    return (rub.lines || []).reduce((s, l) => s + rubriqueLineTotal(l), 0);
  }
  // Total général : Σ sections + Σ rubriques
  function grandTotal(q) {
    const a = (q.sections || []).reduce((s, sec) => s + sectionTotal(sec), 0);
    const b = (q.rubriques || []).reduce((s, r) => s + rubriqueTotal(r), 0);
    return a + b;
  }

  function uid() { return 'id' + Math.random().toString(36).slice(2, 9); }

  window.DATO = {
    formatMoney, formatFCFA, montantEnLettres, toWords,
    sectionTotal, rubriqueTotal, rubriqueLineTotal, grandTotal, uid,
  };
})();
