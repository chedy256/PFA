import { useState, useMemo } from 'react'
import { useNavigate } from 'react-router-dom'
import { usePlanner } from './PlannerContext'
import './planner.css'

const FIELDS = [
  { id: 'students',    label: 'Nombre d\'étudiants',              defaultVal: 12,  min: 1,   max: 300, hint: 'Étudiants à soutenir' },
  { id: 'rooms',       label: 'Nombre de salles',                 defaultVal: 3,   min: 1,   max: 20,  hint: 'Salles disponibles' },
  { id: 'juries',      label: 'Nombre de jurys',                  defaultVal: 6,   min: 2,   max: 100, hint: 'Membres de jury disponibles' },
  { id: 'jurySize',    label: 'Membres par jury',                 defaultVal: 2,   min: 2,   max: 5,   hint: 'Par soutenance (min 2)' },
  { id: 'maxPerDay',   label: 'Max soutenances / jury / jour',    defaultVal: 3,   min: 1,   max: 15,  hint: 'Limite par personne par jour' },
  { id: 'duration',    label: 'Durée par soutenance (min)',        defaultVal: 45,  min: 15,  max: 180, hint: 'Durée totale avec délibération', step: 15 },
  { id: 'startHour',   label: 'Heure de début',                   defaultVal: 8,   min: 6,   max: 12,  hint: 'Heure (format 24h)' },
  { id: 'endHour',     label: 'Heure de fin',                     defaultVal: 18,  min: 13,  max: 22,  hint: 'Heure (format 24h)' },
]

export default function ConfigPage() {
  const navigate  = useNavigate()
  const { generate } = usePlanner()

  const [values, setValues] = useState(() =>
    Object.fromEntries(FIELDS.map(f => [f.id, f.defaultVal]))
  )

  const handleChange = (id, v) => {
    setValues(prev => ({ ...prev, [id]: v }))
  }

  /* ── Computed constraints ── */
  const constraints = useMemo(() => {
    const c = {
      students:  Math.max(1,  values.students  || 12),
      rooms:     Math.max(1,  values.rooms      || 3),
      juries:    Math.max(2,  values.juries     || 6),
      jurySize:  Math.max(2,  values.jurySize   || 2),
      maxPerDay: Math.max(1,  values.maxPerDay  || 3),
      duration:  Math.max(15, values.duration   || 45),
      startHour: Math.max(6,  values.startHour  || 8),
      endHour:   Math.max(13, values.endHour    || 18),
    }
    const slotsPerDay    = Math.floor((c.endHour - c.startHour) * 60 / c.duration)
    const capacityPerDay = c.rooms * slotsPerDay
    const daysNeeded     = capacityPerDay > 0 ? Math.ceil(c.students / capacityPerDay) : '∞'
    const avgPerJury     = (c.students / c.juries).toFixed(1)
    const totalHours     = Math.ceil(c.students * c.duration / 60 * 10) / 10

    return [
      { icon: '🎓', text: 'Créneaux par jour (par salle)',                  val: slotsPerDay },
      { icon: '🏛',  text: `Capacité totale par jour (${c.rooms} salles)`, val: capacityPerDay },
      { icon: '📆', text: 'Jours nécessaires (estimé)',                     val: daysNeeded },
      { icon: '👨‍🏫', text: 'Interventions jury au total',                 val: c.students * c.jurySize },
      { icon: '📊', text: 'Soutenances moyennes par jury',                  val: avgPerJury },
      { icon: '⏱',  text: 'Durée totale estimée',                          val: `~${totalHours}h` },
    ]
  }, [values])

  const handleGenerate = () => {
    const c = {
      students:  Math.max(1,  parseInt(values.students, 10)  || 12),
      rooms:     Math.max(1,  parseInt(values.rooms, 10)     || 3),
      juries:    Math.max(2,  parseInt(values.juries, 10)    || 6),
      jurySize:  Math.max(2,  parseInt(values.jurySize, 10)  || 2),
      maxPerDay: Math.max(1,  parseInt(values.maxPerDay, 10) || 3),
      duration:  Math.max(15, parseInt(values.duration, 10)  || 45),
      startHour: Math.max(6,  parseInt(values.startHour, 10) || 8),
      endHour:   Math.max(13, parseInt(values.endHour, 10)   || 18),
    }
    generate(c)
    navigate('/calendar/planning')
  }

  return (
    <div className="pfe-panel">
      <div className="pfe-section-title">Paramètres généraux</div>

      <div className="pfe-setup-grid">
        {FIELDS.map(f => (
          <div className="pfe-field" key={f.id}>
            <label htmlFor={`f-${f.id}`}>{f.label}</label>
            <input
              type="number"
              id={`f-${f.id}`}
              value={values[f.id]}
              min={f.min}
              max={f.max}
              step={f.step || 1}
              onChange={e => handleChange(f.id, parseInt(e.target.value, 10) || '')}
            />
            <div className="pfe-hint">{f.hint}</div>
          </div>
        ))}
      </div>

      <div className="pfe-section-title" style={{ marginTop: 28 }}>Récapitulatif des contraintes</div>
      <div className="pfe-constraints-list">
        {constraints.map((r, i) => (
          <div className="pfe-constraint-row" key={i}>
            <span className="icon">{r.icon}</span>
            <span className="text">{r.text}</span>
            <span className="value">{r.val}</span>
          </div>
        ))}
      </div>

      <button className="pfe-generate-btn" onClick={handleGenerate}>
        <svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" strokeWidth="2">
          <path d="M2 8h12M9 3l5 5-5 5"/>
        </svg>
        Générer le planning
      </button>
    </div>
  )
}
