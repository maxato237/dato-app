/* ============================================================
   DATO — Sortable : réordonnancement par glisser-déposer (pointer)
   - Poignée explicite (data-handle)
   - Réordonne en direct quand le pointeur croise le milieu d'un voisin
   - L'élément déplacé est "soulevé" (ombre + échelle)
   ============================================================ */
function Sortable({ items, getKey, onChange, renderItem, gap = 0, className, style, handle = '[data-handle]' }) {
  const [ds, setDs] = React.useState(null); // {key, dy} pendant le drag
  const ref = React.useRef(null);
  const st = React.useRef({});

  const list = ds ? st.current.order : items;

  function onPointerDown(e, key) {
    if (!e.target.closest(handle)) return;
    e.preventDefault();
    const children = Array.from(ref.current.children);
    const hmap = {};
    children.forEach((c) => {
      const k = c.getAttribute('data-key');
      hmap[k] = c.getBoundingClientRect().height;
    });
    st.current = { key, startY: e.clientY, order: items.slice(), hmap, gap };
    setDs({ key, dy: 0 });
    window.addEventListener('pointermove', onPointerMove);
    window.addEventListener('pointerup', onPointerUp, { once: true });
    if (navigator.vibrate) navigator.vibrate(8);
  }

  function onPointerMove(e) {
    const s = st.current;
    let dy = e.clientY - s.startY;
    let cur = s.order.findIndex((it) => getKey(it) === s.key);
    if (dy > 0) {
      while (cur < s.order.length - 1) {
        const h = (s.hmap[String(getKey(s.order[cur + 1]))] || 56) + s.gap;
        if (dy > h / 2) {
          [s.order[cur], s.order[cur + 1]] = [s.order[cur + 1], s.order[cur]];
          dy -= h; s.startY += h; cur++;
        } else break;
      }
    } else {
      while (cur > 0) {
        const h = (s.hmap[String(getKey(s.order[cur - 1]))] || 56) + s.gap;
        if (dy < -h / 2) {
          [s.order[cur], s.order[cur - 1]] = [s.order[cur - 1], s.order[cur]];
          dy += h; s.startY -= h; cur--;
        } else break;
      }
    }
    setDs({ key: s.key, dy });
  }

  function onPointerUp() {
    window.removeEventListener('pointermove', onPointerMove);
    const s = st.current;
    if (s.order) onChange(s.order);
    setDs(null);
  }

  return (
    <div ref={ref} className={className} style={{ display: 'flex', flexDirection: 'column', gap, ...style }}>
      {list.map((it) => {
        const key = getKey(it);
        const dragging = ds && ds.key === key;
        return (
          <div
            key={key}
            data-key={key}
            onPointerDown={(e) => onPointerDown(e, key)}
            style={{
              touchAction: 'pan-y',
              transform: dragging ? `translateY(${ds.dy}px) scale(1.02)` : 'none',
              transition: dragging ? 'none' : 'transform .18s ease',
              zIndex: dragging ? 30 : 1,
              position: 'relative',
              boxShadow: dragging ? '0 14px 32px rgba(16,24,40,.18)' : 'none',
              borderRadius: 12,
              opacity: dragging ? 0.98 : 1,
            }}
          >
            {renderItem(it, dragging)}
          </div>
        );
      })}
    </div>
  );
}
window.Sortable = Sortable;
