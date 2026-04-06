import { NavLink } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'

const navLinks = [
  { to: '/dashboard', label: 'Dashboard', icon: '⊞' },
  { to: '/students',  label: 'Students',  icon: '👥' },
  { to: '/teachers',  label: 'Teachers',  icon: '🎓' },
  { to: '/calendar',  label: 'Calendar',  icon: '📅' },
]

export default function Sidebar({ collapsed, setCollapsed }) {
  const { user } = useAuth()

  return (
    <div style={{
      width: collapsed ? 68 : 230,
      background: 'var(--bg-secondary)',
      borderRight: '1.5px solid var(--border)',
      height: '100vh',
      display: 'flex', flexDirection: 'column',
      transition: 'width 0.25s cubic-bezier(0.4,0,0.2,1)',
      flexShrink: 0, position: 'sticky', top: 0, overflow: 'hidden',
      boxShadow: 'var(--shadow-sm)',
    }}>
      {/* Logo */}
      <div style={{
        padding: collapsed ? '20px 14px' : '20px 22px',
        borderBottom: '1.5px solid var(--border)',
        display: 'flex', alignItems: 'center', gap: 12,
        justifyContent: collapsed ? 'center' : 'flex-start',
      }}>
        <img src="/logo.png" alt="University Logo" style={{
          width: 36, height: 36, flexShrink: 0,
          borderRadius: 10, objectFit: 'contain',
        }} />
        {!collapsed && (
          <div>
            <div style={{ color: 'var(--text-primary)', fontWeight: 800, fontSize: 16, fontFamily: 'Syne, sans-serif' }}>InternHub</div>
            <div style={{ color: 'var(--text-muted)', fontSize: 11 }}>Management Platform</div>
          </div>
        )}
      </div>

      {/* Nav links */}
      <nav style={{ flex: 1, padding: '12px 10px', overflowY: 'auto' }}>
        {navLinks.map(({ to, label, icon }) => (
          <NavLink key={to} to={to} style={({ isActive }) => ({
            display: 'flex', alignItems: 'center',
            gap: 12, padding: collapsed ? '11px' : '10px 14px',
            borderRadius: 10, marginBottom: 3,
            background: isActive ? '#E8F2FF' : 'transparent',
            color: isActive ? '#0066CC' : 'var(--text-secondary)',
            textDecoration: 'none', fontWeight: isActive ? 600 : 400,
            fontSize: 14, transition: 'all 0.15s',
            justifyContent: collapsed ? 'center' : 'flex-start',
            borderLeft: isActive ? '3px solid #0066CC' : '3px solid transparent',
          })}>
            <span style={{ fontSize: 18, flexShrink: 0 }}>{icon}</span>
            {!collapsed && <span>{label}</span>}
          </NavLink>
        ))}
      </nav>

      {/* User + collapse */}
      <div style={{ borderTop: '1.5px solid var(--border)', padding: '12px 10px' }}>
        {!collapsed && (
          <div style={{
            display: 'flex', alignItems: 'center', gap: 10,
            padding: '10px 12px', borderRadius: 10,
            background: 'var(--bg-card)', marginBottom: 10,
            border: '1.5px solid var(--border)',
          }}>
            <div style={{
              width: 30, height: 30, borderRadius: '50%',
              background: 'linear-gradient(135deg, #0066CC, #4D94DB)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontSize: 12, fontWeight: 700, color: '#fff', flexShrink: 0,
            }}>{user?.name?.charAt(0) || 'A'}</div>
            <div style={{ minWidth: 0 }}>
              <div style={{ color: 'var(--text-primary)', fontSize: 13, fontWeight: 600, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{user?.name}</div>
              <div style={{ color: 'var(--text-muted)', fontSize: 11 }}>Administrator</div>
            </div>
          </div>
        )}
        <button onClick={() => setCollapsed(!collapsed)} style={{
          width: '100%', padding: '9px',
          background: 'var(--bg-card)',
          border: '1.5px solid var(--border)',
          color: 'var(--text-tertiary)',
          borderRadius: 10, fontSize: 15,
          display: 'flex', alignItems: 'center', justifyContent: 'center',
        }}>{collapsed ? '→' : '←'}</button>
      </div>
    </div>
  )
}
