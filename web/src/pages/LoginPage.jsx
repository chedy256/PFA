import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../context/AuthContext'
import { useTheme } from '../context/ThemeContext'

// Firebase error code → friendly message
const friendlyError = (code) => {
  const map = {
    'auth/user-not-found':       'No account found with this email.',
    'auth/wrong-password':       'Incorrect password. Please try again.',
    'auth/invalid-email':        'Please enter a valid email address.',
    'auth/too-many-requests':    'Too many attempts. Please try again later.',
    'auth/network-request-failed': 'Network error. Check your connection.',
    'auth/invalid-credential':   'Invalid email or password.',
  }
  return map[code] || 'Something went wrong. Please try again.'
}

export default function LoginPage() {
  const [tab,      setTab]      = useState('login')   // 'login' | 'reset'
  const [email,    setEmail]    = useState('')
  const [password, setPassword] = useState('')
  const [error,    setError]    = useState('')
  const [info,     setInfo]     = useState('')
  const [loading, setLoading] = useState(false)

  const { loginWithEmail, resetPassword } = useAuth()
  const { dark, toggle } = useTheme()
  const navigate = useNavigate()

  // ── Email / Password Login ────────────────────────────────────────
  const handleEmailLogin = async (e) => {
    e.preventDefault()
    setError(''); setInfo(''); setLoading(true)
    try {
      await loginWithEmail(email, password)
      navigate('/dashboard')
    } catch (err) {
      setError(friendlyError(err.code))
    } finally {
      setLoading(false)
    }
  }

  // ── Password Reset ────────────────────────────────────────────────
  const handleReset = async (e) => {
    e.preventDefault()
    setError(''); setInfo(''); setLoading(true)
    try {
      await resetPassword(email)
      setInfo('Password reset email sent! Check your inbox.')
    } catch (err) {
      setError(friendlyError(err.code))
    } finally {
      setLoading(false)
    }
  }

  return (
    <div style={{
      minHeight: '100vh', background: 'var(--bg-primary)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      padding: 16, position: 'relative',
    }}>
      {/* Background blobs */}
      <div style={{ position: 'absolute', inset: 0, overflow: 'hidden', pointerEvents: 'none' }}>
        <div style={{ position: 'absolute', top: '-10%', right: '-5%', width: 500, height: 500, borderRadius: '50%', background: 'radial-gradient(circle, rgba(0,102,204,0.07) 0%, transparent 70%)' }} />
        <div style={{ position: 'absolute', bottom: '-10%', left: '-5%',  width: 400, height: 400, borderRadius: '50%', background: 'radial-gradient(circle, rgba(108,99,255,0.05) 0%, transparent 70%)' }} />
      </div>

      {/* Theme toggle */}
      <div style={{ position: 'absolute', top: 20, right: 24, display: 'flex', alignItems: 'center', gap: 8 }}>
        <span style={{ fontSize: 16 }}>{dark ? '🌙' : '☀️'}</span>
        <button className={`theme-toggle${dark ? ' dark' : ''}`} onClick={toggle} />
      </div>

      <div className="animate-fadeIn" style={{ width: '100%', maxWidth: 420, position: 'relative' }}>
        <div style={{
          background: 'var(--bg-secondary)', border: '1.5px solid var(--border)',
          borderRadius: 24, padding: '40px 38px',
          boxShadow: 'var(--shadow-lg)',
        }}>
          {/* Logo */}
          <div style={{ textAlign: 'center', marginBottom: 28 }}>
            <img src="/logo.png" alt="University Logo" style={{
              width: 60, height: 60, margin: '0 auto 14px',
              borderRadius: 16, objectFit: 'contain',
              boxShadow: '0 6px 20px rgba(0,102,204,0.28)',
            }} />
            <h1 style={{ color: 'var(--text-primary)', fontSize: 26, fontWeight: 800, marginBottom: 4, fontFamily: 'Syne, sans-serif' }}>
              InternHub
            </h1>
            <p style={{ color: 'var(--text-tertiary)', fontSize: 13 }}>Internship Management Platform</p>
          </div>

          {tab === 'login' ? (
            <>
              {/* Email/Password form */}
              <form onSubmit={handleEmailLogin}>
                <div style={{ marginBottom: 14 }}>
                  <label style={{ color: 'var(--text-secondary)', fontSize: 12, fontWeight: 600, display: 'block', marginBottom: 7, letterSpacing: 0.5 }}>EMAIL ADDRESS</label>
                  <input type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="you@example.com" required autoComplete="email" />
                </div>
                <div style={{ marginBottom: 8 }}>
                  <label style={{ color: 'var(--text-secondary)', fontSize: 12, fontWeight: 600, display: 'block', marginBottom: 7, letterSpacing: 0.5 }}>PASSWORD</label>
                  <input type="password" value={password} onChange={e => setPassword(e.target.value)} placeholder="••••••••" required autoComplete="current-password" />
                </div>

                {/* Forgot password link */}
                <div style={{ textAlign: 'right', marginBottom: 18 }}>
                  <button type="button" onClick={() => { setTab('reset'); setError(''); setInfo('') }} style={{
                    background: 'none', border: 'none', color: '#0066CC',
                    fontSize: 13, cursor: 'pointer', fontWeight: 500,
                  }}>Forgot password?</button>
                </div>

                {/* Error */}
                {error && (
                  <div style={{
                    background: dark ? '#2E0000' : '#FEF2F2',
                    border: `1.5px solid ${dark ? '#DC2626' : '#FECACA'}`,
                    borderRadius: 10, padding: '11px 15px',
                    color: '#DC2626', fontSize: 13, marginBottom: 16,
                  }}>{error}</div>
                )}

                <button type="submit" disabled={loading} style={{
                  width: '100%', padding: '13px',
                  background: loading ? (dark ? '#0D2E4D' : '#B3D1F5') : 'linear-gradient(135deg, #0066CC, #4D94DB)',
                  color: loading ? (dark ? '#4D94DB' : '#0066CC') : '#FFFFFF',
                  border: 'none', borderRadius: 12, fontSize: 15, fontWeight: 700,
                  fontFamily: 'Syne, sans-serif', cursor: loading ? 'not-allowed' : 'pointer',
                  boxShadow: loading ? 'none' : '0 4px 14px rgba(0,102,204,0.28)',
                  transition: 'all 0.2s',
                }}>
                  {loading ? 'Signing in...' : 'Sign In →'}
                </button>
              </form>
            </>
          ) : (
            /* ── Password Reset Tab ─────────────────────────────── */
            <form onSubmit={handleReset}>
              <div style={{ marginBottom: 16 }}>
                <button type="button" onClick={() => { setTab('login'); setError(''); setInfo('') }} style={{
                  background: 'none', border: 'none', color: 'var(--text-muted)',
                  fontSize: 13, cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 6,
                  marginBottom: 16, padding: 0,
                }}>← Back to login</button>

                <h3 style={{ color: 'var(--text-primary)', fontSize: 18, fontWeight: 700, marginBottom: 6, fontFamily: 'Syne, sans-serif' }}>Reset your password</h3>
                <p style={{ color: 'var(--text-tertiary)', fontSize: 13, marginBottom: 20 }}>Enter your email and we'll send you a reset link.</p>

                <label style={{ color: 'var(--text-secondary)', fontSize: 12, fontWeight: 600, display: 'block', marginBottom: 7, letterSpacing: 0.5 }}>EMAIL ADDRESS</label>
                <input type="email" value={email} onChange={e => setEmail(e.target.value)} placeholder="you@example.com" required autoComplete="email" />
              </div>

              {error && (
                <div style={{ background: dark ? '#2E0000' : '#FEF2F2', border: `1.5px solid ${dark ? '#DC2626' : '#FECACA'}`, borderRadius: 10, padding: '11px 15px', color: '#DC2626', fontSize: 13, marginBottom: 16 }}>
                  {error}
                </div>
              )}
              {info && (
                <div style={{ background: dark ? '#0D2E1A' : '#F0FDF4', border: `1.5px solid ${dark ? '#2E8B57' : '#A8D5BC'}`, borderRadius: 10, padding: '11px 15px', color: dark ? '#2E8B57' : '#166534', fontSize: 13, marginBottom: 16 }}>
                  {info}
                </div>
              )}

              <button type="submit" disabled={loading} style={{
                width: '100%', padding: '13px',
                background: loading ? (dark ? '#0D2E4D' : '#B3D1F5') : 'linear-gradient(135deg, #0066CC, #4D94DB)',
                color: loading ? (dark ? '#4D94DB' : '#0066CC') : '#FFFFFF',
                border: 'none', borderRadius: 12, fontSize: 15, fontWeight: 700,
                fontFamily: 'Syne, sans-serif', cursor: loading ? 'not-allowed' : 'pointer',
                boxShadow: loading ? 'none' : '0 4px 14px rgba(0,102,204,0.28)',
              }}>
                {loading ? 'Sending...' : 'Send Reset Email'}
              </button>
            </form>
          )}
        </div>
      </div>
    </div>
  )
}
