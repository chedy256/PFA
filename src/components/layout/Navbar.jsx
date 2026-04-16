import { useNavigate, useLocation } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'
import { useTheme } from '../../context/ThemeContext'

const pageTitles = {
  '/dashboard': 'Dashboard',
  '/students':  'Student Management',
  '/teachers':  'Teacher Management',
  '/calendar':  'Internship Calendar',
  '/calendar/config':     'Calendar — Configuration',
  '/calendar/planning':   'Calendar — Planning',
  '/calendar/jurys':      'Calendar — Jurys',
  '/calendar/validation': 'Calendar — Validation',
}

export default function Navbar() {
  const { user, logout } = useAuth()
  const { dark, toggle } = useTheme()
  const navigate = useNavigate()
  const location = useLocation()
  const title    = pageTitles[location.pathname] || 'InternHub'

  return (
    <div style={{
      height: 62,
      background: 'var(--bg-secondary)',
      borderBottom: '1.5px solid var(--border)',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      padding: '0 28px', position: 'sticky', top: 0, zIndex: 100,
      boxShadow: 'var(--shadow-sm)',
    }}>
      <h2 style={{
        color: 'var(--text-primary)', fontSize: 17, fontWeight: 700,
        fontFamily: 'Syne, sans-serif', letterSpacing: -0.2,
      }}>{title}</h2>

      <div style={{ display: 'flex', alignItems: 'center', gap: 14 }}>
        {/* Theme toggle */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <span style={{ fontSize: 15 }}>{dark ? '🌙' : '☀️'}</span>
          <button className={`theme-toggle${dark ? ' dark' : ''}`} onClick={toggle} title={dark ? 'Light mode' : 'Dark mode'} />
        </div>

        <div style={{ width: 1, height: 28, background: 'var(--border)' }} />

        {/* User chip */}
        <div style={{
          display: 'flex', alignItems: 'center', gap: 10,
          padding: '6px 14px 6px 8px',
          background: 'var(--bg-card)',
          border: '1.5px solid var(--border)',
          borderRadius: 40,
        }}>
          <div style={{
            width: 28, height: 28, borderRadius: '50%',
            background: 'linear-gradient(135deg, #0066CC, #4D94DB)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            fontSize: 12, fontWeight: 700, color: '#fff',
          }}>{user?.name?.charAt(0) || 'A'}</div>
          <span style={{ color: 'var(--text-primary)', fontSize: 13, fontWeight: 500 }}>{user?.name}</span>
        </div>

        {/* Logout */}
        <button
          onClick={() => { logout(); navigate('/login') }}
          style={{
            background: 'transparent', color: 'var(--text-tertiary)',
            border: '1.5px solid var(--border)', borderRadius: 10,
            padding: '7px 14px', fontSize: 13, fontWeight: 500,
          }}
          onMouseEnter={e => { e.currentTarget.style.background = dark ? '#2E0000' : '#FEF2F2'; e.currentTarget.style.color = '#DC2626'; e.currentTarget.style.borderColor = '#FECACA' }}
          onMouseLeave={e => { e.currentTarget.style.background = 'transparent'; e.currentTarget.style.color = 'var(--text-tertiary)'; e.currentTarget.style.borderColor = 'var(--border)' }}
        >⏻ Logout</button>
      </div>
    </div>
  )
}
