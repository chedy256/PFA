import { useState, useEffect } from 'react'
import { NavLink, useLocation } from 'react-router-dom'
import { useAuth } from '../../context/AuthContext'

const navLinks = [
  { to: '/dashboard', label: 'Dashboard', icon: '⊞' },
  { to: '/students',  label: 'Students',  icon: '👥' },
  { to: '/teachers',  label: 'Teachers',  icon: '🎓' },
]

const calendarSubs = [
  { to: '/calendar/config',     label: 'Config' },
  { to: '/calendar/planning',   label: 'Planning' },
  { to: '/calendar/jurys',      label: 'Jurys' },
  { to: '/calendar/validation', label: 'Validation' },
]

export default function Sidebar({ collapsed, setCollapsed }) {
  const { user } = useAuth()
  const location = useLocation()

  const isCalendarActive = location.pathname.startsWith('/calendar')
  const [calendarOpen, setCalendarOpen] = useState(isCalendarActive)

  // Auto-open submenu when navigating to a calendar route
  useEffect(() => {
    if (isCalendarActive && !collapsed) {
      setCalendarOpen(true)
    }
  }, [isCalendarActive, collapsed])

  const toggleCalendar = () => {
    if (collapsed) {
      setCollapsed(false)
      setCalendarOpen(true)
    } else {
      setCalendarOpen(o => !o)
    }
  }

  const linkStyle = (isActive) => ({
    display: 'flex', alignItems: 'center',
    gap: 12, padding: collapsed ? '11px' : '10px 14px',
    borderRadius: 10, marginBottom: 3,
    background: isActive ? '#E8F2FF' : 'transparent',
    color: isActive ? '#0066CC' : 'var(--text-secondary)',
    textDecoration: 'none', fontWeight: isActive ? 600 : 400,
    fontSize: 14, transition: 'all 0.15s',
    justifyContent: collapsed ? 'center' : 'flex-start',
    borderLeft: isActive ? '3px solid #0066CC' : '3px solid transparent',
  })

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
          <NavLink key={to} to={to} style={({ isActive }) => linkStyle(isActive)}>
            <span style={{ fontSize: 18, flexShrink: 0 }}>{icon}</span>
            {!collapsed && <span>{label}</span>}
          </NavLink>
        ))}

        {/* Calendar — collapsible with submenu */}
        <div>
          <button
            onClick={toggleCalendar}
            style={{
              ...linkStyle(isCalendarActive),
              width: '100%', border: 'none', cursor: 'pointer',
              fontFamily: 'DM Sans, sans-serif',
            }}
          >
            <span style={{ fontSize: 18, flexShrink: 0 }}>📅</span>
            {!collapsed && (
              <>
                <span style={{ flex: 1, textAlign: 'left' }}>Calendar</span>
                <span style={{
                  fontSize: 10,
                  transition: 'transform 0.25s ease',
                  transform: calendarOpen ? 'rotate(90deg)' : 'rotate(0deg)',
                  color: isCalendarActive ? '#0066CC' : 'var(--text-muted)',
                }}>▶</span>
              </>
            )}
          </button>

          {/* Submenu with animated height */}
          {!collapsed && (
            <div style={{
              overflow: 'hidden',
              maxHeight: calendarOpen ? 200 : 0,
              transition: 'max-height 0.3s cubic-bezier(0.4,0,0.2,1)',
            }}>
              <div style={{ paddingLeft: 20, paddingTop: 2, paddingBottom: 4 }}>
                {calendarSubs.map(sub => {
                  const isActive = location.pathname === sub.to || location.pathname === sub.to + '/'
                  return (
                    <NavLink
                      key={sub.to}
                      to={sub.to}
                      style={{
                        display: 'flex', alignItems: 'center', gap: 8,
                        padding: '7px 12px', borderRadius: 8, marginBottom: 2,
                        fontSize: 13, textDecoration: 'none',
                        fontWeight: isActive ? 600 : 400,
                        color: isActive ? '#0066CC' : 'var(--text-tertiary)',
                        background: isActive ? 'rgba(0,102,204,0.07)' : 'transparent',
                        transition: 'all 0.15s',
                        borderLeft: isActive ? '2px solid #0066CC' : '2px solid transparent',
                      }}
                    >
                      {sub.label}
                    </NavLink>
                  )
                })}
              </div>
            </div>
          )}
        </div>
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
