import { Outlet } from 'react-router-dom'
import { PlannerProvider, usePlanner } from './CalendarPage/PlannerContext'
import './CalendarPage/planner.css'

function PlannerShell() {
  const { presentations } = usePlanner()

  const badgeText = presentations.length > 0
    ? `${presentations.length} soutenances`
    : 'Configuration'

  return (
    <div className="pfe-planner-root" style={{ height: '100%', overflow: 'auto' }}>


      {/* Active panel */}
      <div style={{ flex: 1, display: 'flex', flexDirection: 'column', minHeight: 0 }}>
        <Outlet />
      </div>
    </div>
  )
}

export default function CalendarPage() {
  return (
    <PlannerProvider>
      <PlannerShell />
    </PlannerProvider>
  )
}
