import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { Toaster } from 'react-hot-toast'
import { AuthProvider } from './context/AuthContext'
import { ThemeProvider } from './context/ThemeContext'
import Layout from './components/layout/Layout'
import LoginPage     from './pages/LoginPage'
import DashboardPage from './pages/DashboardPage'
import StudentsPage  from './pages/StudentsPage'
import TeachersPage  from './pages/TeachersPage'
import CalendarPage  from './pages/CalendarPage'
import ConfigPage    from './pages/CalendarPage/ConfigPage'
import PlanningPage  from './pages/CalendarPage/PlanningPage'
import JurysPage     from './pages/CalendarPage/JurysPage'
import ValidationPage from './pages/CalendarPage/ValidationPage'

export default function App() {
  return (
    <ThemeProvider>
      <AuthProvider>
        <BrowserRouter>
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route element={<Layout />}>
              <Route path="/dashboard" element={<DashboardPage />} />
              <Route path="/students"  element={<StudentsPage />} />
              <Route path="/teachers"  element={<TeachersPage />} />
              <Route path="/calendar"  element={<CalendarPage />}>
                <Route index element={<Navigate to="config" replace />} />
                <Route path="config"     element={<ConfigPage />} />
                <Route path="planning"   element={<PlanningPage />} />
                <Route path="jurys"      element={<JurysPage />} />
                <Route path="validation" element={<ValidationPage />} />
              </Route>
            </Route>
            <Route path="*" element={<Navigate to="/login" replace />} />
          </Routes>
        </BrowserRouter>
        <Toaster
          position="bottom-right"
          toastOptions={{
            style: {
              background: 'var(--bg-card)',
              border: '1.5px solid var(--border)',
              color: 'var(--text-primary)',
              borderRadius: 12,
              fontSize: 14,
              boxShadow: 'var(--shadow-md)',
            },
          }}
        />
      </AuthProvider>
    </ThemeProvider>
  )
}
