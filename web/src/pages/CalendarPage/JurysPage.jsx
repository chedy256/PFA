import { usePlanner } from './PlannerContext'
import './planner.css'

export default function JurysPage() {
  const { config, presentations, juries, slots } = usePlanner()

  if (!config || juries.length === 0) {
    return (
      <div className="pfe-empty-state">
        <div className="big">👥</div>
        Générez d'abord un planning pour voir les affectations des jurys.
      </div>
    )
  }

  return (
    <div className="pfe-panel">
      <div className="pfe-jury-grid">
        {juries.map(j => {
          const myPres  = presentations.filter(p => p.juryIds.includes(j.id))
          const asPresi = myPres.filter(p => p.presidentId === j.id)
          const total   = myPres.length
          const statusCls = total === 0 ? 'danger' : total > config.maxPerDay ? 'warn' : 'ok'

          const initials = j.name
            .split(' ')
            .filter(w => !w.match(/^(Dr\.|Prof\.)/))
            .map(w => w[0])
            .slice(0, 2)
            .join('')

          return (
            <div className="pfe-jury-card" key={j.id}>
              <div className="jury-name">
                <div className="jury-avatar">{initials}</div>
                <span>{j.name}</span>
              </div>
              <div className="jury-stats">
                <span className={`jury-stat ${statusCls}`}>
                  {total} soutenance{total !== 1 ? 's' : ''}
                </span>
                <span className="jury-stat">{asPresi.length}× Président</span>
              </div>
              <div className="jury-assignments">
                {myPres.length > 0 ? myPres.map(p => {
                  const slot    = slots.find(s => s.id === p.slotId)
                  const isPresi = p.presidentId === j.id
                  return (
                    <div className="jury-assignment" key={p.id}>
                      <span className="stname">{p.student}</span>
                      <span style={{ fontSize: 10, color: 'var(--txt3)', whiteSpace: 'nowrap' }}>
                        J{p.day + 1} {slot ? slot.label : '–'}
                      </span>
                      <span className={`pres-badge ${isPresi ? 'president' : 'member'}`}>
                        {isPresi ? '👑 Président' : 'Membre'}
                      </span>
                    </div>
                  )
                }) : (
                  <div style={{ fontSize: 11, color: 'var(--txt3)', padding: '4px 0' }}>
                    Aucune affectation
                  </div>
                )}
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
