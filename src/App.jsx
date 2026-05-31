import { useRef, useState } from 'react';
import { Ruler, Timer, Film, ArrowDown } from 'lucide-react';

const COLORS = {
  background: '#F2F2F7',
  card: '#FFFFFF',
  label: '#8E8E93',
  text: '#1C1C1E',
  blue: '#007AFF',
  hairline: '#E5E5EA',
};

const FONT = "-apple-system, 'SF Pro Display', 'SF Pro Text', sans-serif";

function parseInput(value) {
  if (value === '' || value === '-') return null;
  const n = parseFloat(value);
  return Number.isFinite(n) ? n : null;
}

function formatDecimal(value, decimals) {
  return value.toFixed(decimals);
}

function isIntegerInput(value) {
  return value === '' || /^\d*$/.test(value);
}

const styles = {
  app: {
    width: '100%',
    maxWidth: 390,
    minHeight: '100dvh',
    margin: '0 auto',
    background: COLORS.background,
    fontFamily: FONT,
    position: 'relative',
    boxSizing: 'border-box',
    display: 'flex',
    flexDirection: 'column',
  },
  content: {
    flex: 1,
    padding: 16,
    paddingBottom: 'calc(100px + env(safe-area-inset-bottom, 0px))',
    display: 'flex',
    flexDirection: 'column',
    gap: 16,
  },
  card: {
    background: COLORS.card,
    borderRadius: 16,
    boxShadow: '0 1px 3px rgba(0,0,0,0.08)',
    padding: 0,
    overflow: 'hidden',
  },
  fieldRow: {
    padding: '12px 16px',
    minHeight: 56,
    boxSizing: 'border-box',
  },
  fieldLabel: {
    fontSize: 12,
    fontWeight: 500,
    color: COLORS.label,
    textTransform: 'uppercase',
    letterSpacing: '0.04em',
    marginBottom: 4,
  },
  fieldInput: {
    width: '100%',
    border: 'none',
    outline: 'none',
    background: 'transparent',
    fontSize: 28,
    fontWeight: 500,
    color: COLORS.text,
    fontFamily: FONT,
    padding: 0,
    margin: 0,
    WebkitAppearance: 'none',
  },
  fieldReadonly: {
    fontSize: 28,
    fontWeight: 500,
    color: COLORS.text,
    lineHeight: 1.2,
  },
  fieldReadonlyEmpty: {
    fontSize: 28,
    fontWeight: 500,
    color: COLORS.label,
    lineHeight: 1.2,
  },
  hairline: {
    height: 0.5,
    background: COLORS.hairline,
    marginLeft: 16,
  },
  footnote: {
    fontSize: 12,
    color: COLORS.label,
    textAlign: 'center',
    marginTop: -8,
  },
  pillRow: {
    display: 'flex',
    gap: 8,
    padding: 12,
  },
  pill: (selected) => ({
    flex: 1,
    padding: '8px 16px',
    borderRadius: 20,
    border: selected ? 'none' : `1px solid ${COLORS.hairline}`,
    background: selected ? COLORS.blue : 'transparent',
    color: selected ? '#FFFFFF' : COLORS.label,
    fontSize: 15,
    fontWeight: 500,
    fontFamily: FONT,
    cursor: 'pointer',
    textAlign: 'center',
  }),
  fpsSelect: {
    width: '100%',
    border: 'none',
    outline: 'none',
    background: 'transparent',
    fontSize: 28,
    fontWeight: 500,
    color: COLORS.text,
    fontFamily: FONT,
    padding: 0,
    margin: 0,
    WebkitAppearance: 'none',
    appearance: 'none',
    cursor: 'pointer',
  },
  inlineToggle: {
    display: 'flex',
    gap: 6,
    marginTop: 8,
  },
  inlinePill: (selected) => ({
    padding: '4px 12px',
    borderRadius: 12,
    border: selected ? 'none' : `1px solid ${COLORS.hairline}`,
    background: selected ? COLORS.blue : 'transparent',
    color: selected ? '#FFFFFF' : COLORS.label,
    fontSize: 12,
    fontWeight: 500,
    fontFamily: FONT,
    cursor: 'pointer',
  }),
  swapRow: {
    display: 'flex',
    justifyContent: 'center',
    padding: '8px 0',
  },
  swapButton: {
    width: 44,
    height: 44,
    borderRadius: '50%',
    border: 'none',
    background: COLORS.background,
    color: COLORS.blue,
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    cursor: 'pointer',
  },
  tabBar: {
    position: 'fixed',
    bottom: 0,
    left: '50%',
    transform: 'translateX(-50%)',
    width: '100%',
    maxWidth: 390,
    height: 'calc(80px + env(safe-area-inset-bottom, 0px))',
    paddingBottom: 'env(safe-area-inset-bottom, 0px)',
    background: COLORS.card,
    borderTop: `0.5px solid ${COLORS.hairline}`,
    display: 'flex',
    flexDirection: 'row',
    boxSizing: 'border-box',
  },
  tab: (active) => ({
    flex: 1,
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 2,
    border: 'none',
    background: 'transparent',
    cursor: 'pointer',
    color: active ? COLORS.blue : COLORS.label,
    fontFamily: FONT,
    padding: 0,
  }),
  tabLabel: {
    fontSize: 10,
    fontWeight: 500,
  },
};

function Hairline() {
  return <div style={styles.hairline} />;
}

function Card({ children }) {
  return <div style={styles.card}>{children}</div>;
}

function FieldLabel({ title }) {
  return <div style={styles.fieldLabel}>{title}</div>;
}

function FieldRow({
  label,
  value,
  onChange,
  onFocus,
  inputMode = 'decimal',
  isLast = false,
  children,
}) {
  return (
    <>
      <div style={styles.fieldRow}>
        <FieldLabel title={label} />
        <input
          style={styles.fieldInput}
          type="text"
          inputMode={inputMode}
          value={value}
          onFocus={onFocus}
          onChange={(e) => onChange(e.target.value)}
        />
        {children}
      </div>
      {!isLast && <Hairline />}
    </>
  );
}

function ReadOnlyRow({ label, value, isLast = false }) {
  return (
    <>
      <div style={styles.fieldRow}>
        <FieldLabel title={label} />
        <div style={value ? styles.fieldReadonly : styles.fieldReadonlyEmpty}>
          {value || '—'}
        </div>
      </div>
      {!isLast && <Hairline />}
    </>
  );
}

function PillPairToggle({ leftTitle, rightTitle, isLeftSelected, onLeft, onRight }) {
  return (
    <div style={styles.pillRow}>
      <button type="button" style={styles.pill(isLeftSelected)} onClick={onLeft}>
        {leftTitle}
      </button>
      <button type="button" style={styles.pill(!isLeftSelected)} onClick={onRight}>
        {rightTitle}
      </button>
    </div>
  );
}

function InlinePillPairToggle({ is48k, on48k, on96k }) {
  return (
    <div style={styles.inlineToggle}>
      <button type="button" style={styles.inlinePill(is48k)} onClick={on48k}>
        48k
      </button>
      <button type="button" style={styles.inlinePill(!is48k)} onClick={on96k}>
        96k
      </button>
    </div>
  );
}

// ─── Tab 1: Distance ─────────────────────────────────────────────────────────

const SPEED_OF_SOUND = 343;
const METRES_PER_FOOT = 0.3048;

function DistanceTab() {
  const editingField = useRef('metres');
  const isSyncing = useRef(false);
  const [metres, setMetres] = useState('');
  const [feet, setFeet] = useState('');
  const [ms, setMs] = useState('');

  function clearAll() {
    isSyncing.current = true;
    setMetres('');
    setFeet('');
    setMs('');
    isSyncing.current = false;
  }

  function applyDerived(updates) {
    isSyncing.current = true;
    updates();
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        isSyncing.current = false;
      });
    });
  }

  function handleMetresChange(value) {
    if (isSyncing.current) return;
    editingField.current = 'metres';
    setMetres(value);
    const n = parseInput(value);
    if (n === null) {
      if (value === '') clearAll();
      return;
    }
    applyDerived(() => {
      setFeet(formatDecimal(n / METRES_PER_FOOT, 3));
      setMs(formatDecimal((n / SPEED_OF_SOUND) * 1000, 2));
    });
  }

  function handleFeetChange(value) {
    if (isSyncing.current) return;
    editingField.current = 'feet';
    setFeet(value);
    const n = parseInput(value);
    if (n === null) {
      if (value === '') clearAll();
      return;
    }
    const m = n * METRES_PER_FOOT;
    applyDerived(() => {
      setMetres(formatDecimal(m, 3));
      setMs(formatDecimal((m / SPEED_OF_SOUND) * 1000, 2));
    });
  }

  function handleMsChange(value) {
    if (isSyncing.current) return;
    editingField.current = 'ms';
    setMs(value);
    const n = parseInput(value);
    if (n === null) {
      if (value === '') clearAll();
      return;
    }
    const m = (n / 1000) * SPEED_OF_SOUND;
    applyDerived(() => {
      setMetres(formatDecimal(m, 3));
      setFeet(formatDecimal(m / METRES_PER_FOOT, 3));
    });
  }

  return (
    <>
      <Card>
        <FieldRow
          label="Metres"
          value={metres}
          onFocus={() => { editingField.current = 'metres'; }}
          onChange={handleMetresChange}
        />
        <FieldRow
          label="Feet"
          value={feet}
          onFocus={() => { editingField.current = 'feet'; }}
          onChange={handleFeetChange}
        />
        <FieldRow
          label="Milliseconds"
          value={ms}
          onFocus={() => { editingField.current = 'ms'; }}
          onChange={handleMsChange}
          isLast
        />
      </Card>
      <p style={styles.footnote}>Speed of sound: 343 m/s at 20°C</p>
    </>
  );
}

// ─── Tab 2: Latency ──────────────────────────────────────────────────────────

function LatencyTab() {
  const [samplesToMs, setSamplesToMs] = useState(true);
  const [is48k, setIs48k] = useState(true);
  const isSyncing = useRef(false);
  const [samples, setSamples] = useState('');
  const [ms, setMs] = useState('');

  const sampleRate = is48k ? 48000 : 96000;

  function applyDerived(updates) {
    isSyncing.current = true;
    updates();
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        isSyncing.current = false;
      });
    });
  }

  function recalculateFromInput(rate = sampleRate, direction = samplesToMs) {
    if (direction) {
      if (!samples) {
        applyDerived(() => setMs(''));
        return;
      }
      const n = parseInt(samples, 10);
      if (!Number.isFinite(n)) return;
      applyDerived(() => {
        setMs(formatDecimal((n / rate) * 1000, 3));
      });
    } else {
      const n = parseInput(ms);
      if (n === null) {
        if (ms === '') applyDerived(() => setSamples(''));
        return;
      }
      applyDerived(() => {
        setSamples(String(Math.round((n / 1000) * rate)));
      });
    }
  }

  function handleSamplesInput(value) {
    if (isSyncing.current) return;
    if (!isIntegerInput(value)) return;
    setSamples(value);
    if (value === '') {
      applyDerived(() => setMs(''));
      return;
    }
    const n = parseInt(value, 10);
    if (!Number.isFinite(n)) return;
    applyDerived(() => {
      setMs(formatDecimal((n / sampleRate) * 1000, 3));
    });
  }

  function handleMsInput(value) {
    if (isSyncing.current) return;
    setMs(value);
    const n = parseInput(value);
    if (n === null) {
      if (value === '') applyDerived(() => setSamples(''));
      return;
    }
    applyDerived(() => {
      setSamples(String(Math.round((n / 1000) * sampleRate)));
    });
  }

  function flipDirection() {
    setSamplesToMs((prev) => {
      const next = !prev;
      queueMicrotask(() => recalculateFromInput(sampleRate, next));
      return next;
    });
  }

  function handleRateChange(nextIs48k) {
    const rate = nextIs48k ? 48000 : 96000;
    setIs48k(nextIs48k);
    recalculateFromInput(rate, samplesToMs);
  }

  return (
    <>
      <Card>
        <PillPairToggle
          leftTitle="48k"
          rightTitle="96k"
          isLeftSelected={is48k}
          onLeft={() => handleRateChange(true)}
          onRight={() => handleRateChange(false)}
        />
      </Card>

      <Card>
        {samplesToMs ? (
          <FieldRow
            label="Samples"
            value={samples}
            inputMode="numeric"
            onChange={handleSamplesInput}
          />
        ) : (
          <FieldRow
            label="Milliseconds"
            value={ms}
            onChange={handleMsInput}
          />
        )}

        <Hairline />

        <div style={styles.swapRow}>
          <button
            type="button"
            style={styles.swapButton}
            onClick={flipDirection}
            aria-label="Switch conversion direction"
          >
            <ArrowDown size={20} strokeWidth={2.25} />
          </button>
        </div>

        <Hairline />

        {samplesToMs ? (
          <ReadOnlyRow label="Milliseconds" value={ms} isLast />
        ) : (
          <ReadOnlyRow label="Samples" value={samples} isLast />
        )}
      </Card>
    </>
  );
}

// ─── Tab 3: Frames ───────────────────────────────────────────────────────────

const FPS_OPTIONS = [23.976, 24, 25, 29.97, 30, 47.952, 48, 50, 59.94, 60];

function fpsLabel(fps) {
  return fps % 1 === 0 ? String(fps) : String(fps);
}

function FramesTab() {
  const editingField = useRef('frames');
  const isSyncing = useRef(false);
  const [fps, setFps] = useState(25);
  const [is48k, setIs48k] = useState(true);
  const [frames, setFrames] = useState('');
  const [ms, setMs] = useState('');
  const [samples, setSamples] = useState('');

  const sampleRate = is48k ? 48000 : 96000;

  function clearAll() {
    isSyncing.current = true;
    setFrames('');
    setMs('');
    setSamples('');
    isSyncing.current = false;
  }

  function applyDerived(updates) {
    isSyncing.current = true;
    updates();
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        isSyncing.current = false;
      });
    });
  }

  function handleFramesChange(value) {
    if (isSyncing.current) return;
    editingField.current = 'frames';
    if (!isIntegerInput(value)) return;
    setFrames(value);
    if (value === '') {
      clearAll();
      return;
    }
    const n = parseInt(value, 10);
    if (!Number.isFinite(n)) return;
    const msVal = (n / fps) * 1000;
    applyDerived(() => {
      setMs(formatDecimal(msVal, 3));
      setSamples(String(Math.round((msVal / 1000) * sampleRate)));
    });
  }

  function handleMsChange(value) {
    if (isSyncing.current) return;
    editingField.current = 'ms';
    setMs(value);
    const n = parseInput(value);
    if (n === null) {
      if (value === '') clearAll();
      return;
    }
    applyDerived(() => {
      setFrames(String(Math.round((n / 1000) * fps)));
      setSamples(String(Math.round((n / 1000) * sampleRate)));
    });
  }

  function handleSamplesChange(value) {
    if (isSyncing.current) return;
    editingField.current = 'samples';
    if (!isIntegerInput(value)) return;
    setSamples(value);
    if (value === '') {
      clearAll();
      return;
    }
    const n = parseInt(value, 10);
    if (!Number.isFinite(n)) return;
    const msVal = (n / sampleRate) * 1000;
    applyDerived(() => {
      setMs(formatDecimal(msVal, 3));
      setFrames(String(Math.round((msVal / 1000) * fps)));
    });
  }

  function recalculate(from) {
    switch (from) {
      case 'frames':
        handleFramesChange(frames);
        break;
      case 'ms':
        handleMsChange(ms);
        break;
      case 'samples':
        handleSamplesChange(samples);
        break;
      default:
        break;
    }
  }

  return (
    <>
      <Card>
        <div style={styles.fieldRow}>
          <FieldLabel title="Frame Rate" />
          <select
            style={styles.fpsSelect}
            value={fps}
            onChange={(e) => {
              setFps(parseFloat(e.target.value));
              setTimeout(() => recalculate(editingField.current), 0);
            }}
          >
            {FPS_OPTIONS.map((option) => (
              <option key={option} value={option}>
                {fpsLabel(option)}
              </option>
            ))}
          </select>
        </div>
      </Card>

      <Card>
        <FieldRow
          label="Frames"
          value={frames}
          inputMode="numeric"
          onFocus={() => { editingField.current = 'frames'; }}
          onChange={handleFramesChange}
        />
        <FieldRow
          label="Milliseconds"
          value={ms}
          onFocus={() => { editingField.current = 'ms'; }}
          onChange={handleMsChange}
        />
        <FieldRow
          label="Samples"
          value={samples}
          inputMode="numeric"
          onFocus={() => { editingField.current = 'samples'; }}
          onChange={handleSamplesChange}
          isLast
        >
          <InlinePillPairToggle
            is48k={is48k}
            on48k={() => {
              setIs48k(true);
              setTimeout(() => recalculate(editingField.current), 0);
            }}
            on96k={() => {
              setIs48k(false);
              setTimeout(() => recalculate(editingField.current), 0);
            }}
          />
        </FieldRow>
      </Card>
    </>
  );
}

// ─── Tab bar & App ───────────────────────────────────────────────────────────

const TABS = [
  { id: 'distance', label: 'Distance', Icon: Ruler },
  { id: 'latency', label: 'Latency', Icon: Timer },
  { id: 'frames', label: 'Frames', Icon: Film },
];

function TabBar({ active, onChange }) {
  return (
    <nav style={styles.tabBar}>
      {TABS.map(({ id, label, Icon }) => {
        const isActive = active === id;
        return (
          <button
            key={id}
            type="button"
            style={styles.tab(isActive)}
            onClick={() => onChange(id)}
          >
            <Icon size={22} strokeWidth={isActive ? 2.25 : 1.75} />
            <span style={styles.tabLabel}>{label}</span>
          </button>
        );
      })}
    </nav>
  );
}

export default function App() {
  const [activeTab, setActiveTab] = useState('distance');

  return (
    <div style={styles.app}>
      <main style={styles.content}>
        {activeTab === 'distance' && <DistanceTab />}
        {activeTab === 'latency' && <LatencyTab />}
        {activeTab === 'frames' && <FramesTab />}
      </main>
      <TabBar active={activeTab} onChange={setActiveTab} />
    </div>
  );
}
