// ── STATUS BADGE ─────────────────────────────────────────────────────────────
const statusLight = {
  'In Progress': { bg: '#E8F2FF', color: '#0066CC', border: '#B3D1F5' },
  'Completed':   { bg: '#E8F5EE', color: '#2E8B57', border: '#A8D5BC' },
  'Pending':     { bg: '#FFFBEB', color: '#F59E0B', border: '#FDE68A' },
  'Rejected':    { bg: '#FEF2F2', color: '#DC2626', border: '#FECACA' },
}
const statusDark = {
  'In Progress': { bg: '#0D2E4D', color: '#4D94DB', border: '#1A4A7A' },
  'Completed':   { bg: '#0D2E1A', color: '#2E8B57', border: '#1A4D2A' },
  'Pending':     { bg: '#2E2000', color: '#F59E0B', border: '#4D3800' },
  'Rejected':    { bg: '#2E0000', color: '#DC2626', border: '#4D0000' },
}
const availLight = {
  'Available': { bg: '#E8F5EE', color: '#2E8B57', border: '#A8D5BC' },
  'Busy':      { bg: '#FFFBEB', color: '#F59E0B', border: '#FDE68A' },
  'On Leave':  { bg: '#F8F9FD', color: '#72777F', border: '#E0E6ED' },
}
const availDark = {
  'Available': { bg: '#0D2E1A', color: '#2E8B57', border: '#1A4D2A' },
  'Busy':      { bg: '#2E2000', color: '#F59E0B', border: '#4D3800' },
  'On Leave':  { bg: '#252525', color: '#A0A0A0', border: '#333333' },
}

export function Badge({ label, type = 'status' }) {
  const isDark = document.documentElement.getAttribute('data-theme') === 'dark'
  const map = type === 'status'
    ? (isDark ? statusDark  : statusLight)
    : (isDark ? availDark   : availLight)
  const s = map[label] || { bg: '#F8F9FD', color: '#72777F', border: '#E0E6ED' }
  return (
    <span style={{
      background: s.bg, color: s.color, border: `1.5px solid ${s.border}`,
      borderRadius: 20, padding: '3px 12px', fontSize: 12, fontWeight: 600,
      whiteSpace: 'nowrap', letterSpacing: 0.2,
    }}>{label}</span>
  )
}

// ── BUTTON ────────────────────────────────────────────────────────────────────
export function Button({ children, variant = 'primary', size = 'md', onClick, disabled, style = {} }) {
  const variants = {
    primary: { bg: '#0066CC', color: '#FFFFFF', border: '#0066CC',   hover: '#004C99' },
    secondary:{ bg: '#6C63FF',color: '#FFFFFF', border: '#6C63FF',   hover: '#5750D9' },
    danger:  { bg: '#FEF2F2', color: '#DC2626', border: '#FECACA',   hover: '#FEE2E2' },
    ghost:   { bg: 'transparent', color: 'var(--text-secondary)', border: 'var(--border)', hover: 'var(--bg-hover)' },
    cyan:    { bg: '#E8F2FF', color: '#0066CC', border: '#B3D1F5',   hover: '#D1E6FF' },
    outline: { bg: 'transparent', color: '#0066CC', border: '#B3D1F5', hover: '#E8F2FF' },
    success: { bg: '#E8F5EE', color: '#2E8B57', border: '#A8D5BC',   hover: '#D1EDDC' },
    purple: { bg: '#ECF0FF', color: '#6C63FF', border: '#D4C9FF',   hover: '#DDD1FF' },
  }
  const v   = variants[variant] || variants.primary
  const pad = size === 'sm' ? '5px 12px' : size === 'lg' ? '12px 28px' : '9px 20px'
  const fs  = size === 'sm' ? 12 : size === 'lg' ? 15 : 14

  return (
    <button onClick={onClick} disabled={disabled} style={{
      background: v.bg, color: v.color, border: `1.5px solid ${v.border}`,
      borderRadius: 10, padding: pad, fontSize: fs, fontWeight: 600,
      display: 'inline-flex', alignItems: 'center', gap: 6,
      opacity: disabled ? 0.5 : 1, cursor: disabled ? 'not-allowed' : 'pointer',
      ...style,
    }}
      onMouseEnter={e => { if (!disabled) e.currentTarget.style.background = v.hover }}
      onMouseLeave={e => { e.currentTarget.style.background = v.bg }}
    >{children}</button>
  )
}
