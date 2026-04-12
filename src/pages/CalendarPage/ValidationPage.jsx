import { useMemo } from 'react'
import { usePlanner } from './PlannerContext'
import './planner.css'

export default function ValidationPage() {
  const { config, presentations, juries, slots } = usePlanner()

  const issues = useMemo(() => {
    if (!config || presentations.length === 0) return null

    const result = []

    /* 1. Room + slot collision */
    const byCell = {}
    presentations.forEach(p => {
      const k = `${p.room}_${p.slotId}`;
      (byCell[k] = byCell[k] || []).push(p)
    })
    Object.values(byCell).forEach(arr => {
      if (arr.length > 1) {
        result.push({
          type: 'error',
          msg: `Conflit de salle : ${arr.map(x => x.student).join(' et ')} — même salle et même créneau`
        })
      }
    })

    /* 2. Jury double-booking (same slot) */
    const jurySlot = {}
    presentations.forEach(p => {
      p.juryIds.forEach(jid => {
        const k = `${jid}_${p.slotId}`;
        (jurySlot[k] = jurySlot[k] || []).push(p.student)
      })
    })
    Object.entries(jurySlot).forEach(([k, arr]) => {
      if (arr.length > 1) {
        const jid  = k.split('_d')[0]
        const jury = juries.find(j => j.id === jid)
        result.push({
          type: 'error',
          msg: `${jury?.name} est affecté à 2 soutenances simultanées : ${arr.join(' et ')}`
        })
      }
    })

    /* 3. Max-per-day exceeded */
    const juryDayMap = {}
    presentations.forEach(p => {
      p.juryIds.forEach(jid => {
        const k = `${jid}_d${p.day}`
        juryDayMap[k] = (juryDayMap[k] || 0) + 1
      })
    })
    Object.entries(juryDayMap).forEach(([k, cnt]) => {
      if (cnt > config.maxPerDay) {
        const [jid] = k.split('_d')
        const jury  = juries.find(j => j.id === jid)
        result.push({
          type: 'warn',
          msg: `${jury?.name} dépasse la limite de ${config.maxPerDay} soutenances/jour (${cnt} affectées)`
        })
      }
    })

    /* 4. Unscheduled students */
    const unassigned = config.students - presentations.length
    if (unassigned > 0) {
      result.push({
        type: 'warn',
        msg: `${unassigned} étudiant(s) sans soutenance planifiée (jurys insuffisants pour couvrir tous les créneaux)`
      })
    }

    /* 5. All good */
    if (result.length === 0) {
      result.push({ type: 'ok', msg: 'Aucun conflit détecté — le planning est valide ✓' })
    }

    return result
  }, [config, presentations, juries])

  if (!issues) {
    return (
      <div className="pfe-empty-state">
        <div className="big">✅</div>
        Aucun planning à valider pour l'instant.
      </div>
    )
  }

  return (
    <div className="pfe-panel">
      <div className="pfe-conflict-list">
        {issues.map((issue, i) => (
          <div className={`conflict-item ${issue.type}`} key={i}>
            <div className="conflict-dot" />
            <span>{issue.msg}</span>
          </div>
        ))}
      </div>
    </div>
  )
}
