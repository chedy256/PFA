import { useState, useRef, useCallback } from 'react'
import { usePlanner, COLORS, ROOM_COLORS } from './PlannerContext'
import './planner.css'

export default function PlanningPage() {
  const {
    config, presentations, juries, rooms, slots, currentDay,
    setCurrentDay, generate, movePres,
    updatePresentation, addPresentation, deletePresentation
  } = usePlanner()

  const [dragId, setDragId] = useState(null)
  const [modal,  setModal]  = useState(null) // null | { mode:'edit'|'add', pres? }

  if (!config || presentations.length === 0) {
    return (
      <div className="pfe-empty-state">
        <div className="big">📅</div>
        Configurez les paramètres puis cliquez sur <strong>Générer le planning</strong>
      </div>
    )
  }

  const days     = [...new Set(slots.map(s => s.day))]
  const daySlots = slots.filter(s => s.day === currentDay)

  /* ── Drag & Drop handlers ── */
  const handleDragStart = (e, id) => {
    setDragId(id)
    e.dataTransfer.effectAllowed = 'move'
    setTimeout(() => {
      const el = document.getElementById(`card-${id}`)
      if (el) el.classList.add('dragging')
    }, 0)
  }

  const handleDragEnd = () => {
    if (dragId) {
      const el = document.getElementById(`card-${dragId}`)
      if (el) el.classList.remove('dragging')
    }
    setDragId(null)
  }

  const handleDragOver = (e) => {
    e.preventDefault()
    e.currentTarget.classList.add('drag-over')
  }

  const handleDragLeave = (e) => {
    e.currentTarget.classList.remove('drag-over')
  }

  const handleDrop = (e, ri, si) => {
    e.preventDefault()
    e.currentTarget.classList.remove('drag-over')
    if (!dragId) return
    movePres(dragId, ri, si)
    setDragId(null)
  }

  /* ── Modal helpers ── */
  const openEdit = (p) => setModal({ mode: 'edit', pres: { ...p } })
  const openAdd  = () => setModal({ mode: 'add', pres: { student: '', room: 0, slotId: slots[0]?.id || '', presidentId: juries[0]?.id || '', juryIds: [] } })
  const closeModal = () => setModal(null)

  const handleSave = () => {
    if (!modal) return
    const p = modal.pres
    if (!p.student.trim()) { alert('Le nom de l\'étudiant est requis.'); return }

    if (!p.juryIds.includes(p.presidentId)) p.juryIds = [...p.juryIds, p.presidentId]
    const slot = slots.find(s => s.id === p.slotId)

    if (modal.mode === 'edit') {
      updatePresentation(p.id, {
        student: p.student, room: p.room, slotId: p.slotId,
        day: slot?.day ?? 0, slot: slot?.slot ?? 0,
        presidentId: p.presidentId, juryIds: p.juryIds,
        color: COLORS[p.room % COLORS.length]
      })
    } else {
      addPresentation({
        student: p.student, room: p.room, slotId: p.slotId,
        day: slot?.day ?? 0, slot: slot?.slot ?? 0,
        presidentId: p.presidentId, juryIds: p.juryIds,
        color: COLORS[p.room % COLORS.length]
      })
    }
    closeModal()
  }

  const handleDelete = () => {
    if (!modal?.pres?.id) return
    if (!confirm('Supprimer cette soutenance ?')) return
    deletePresentation(modal.pres.id)
    closeModal()
  }

  const handleRegenerate = () => {
    if (config) generate(config)
  }

  /* ── Short name helper ── */
  const shortName = (jury) => jury.name.replace(/^Dr\. /, '').split(' ')[0]

  return (
    <div className="pfe-schedule-panel">
      {/* Toolbar */}
      <div className="pfe-schedule-toolbar">
        <div className="toolbar-stat">Étudiants: <strong>{presentations.length}</strong></div>
        <div className="toolbar-sep" />
        <div className="toolbar-stat">Salles: <strong>{config.rooms}</strong></div>
        <div className="toolbar-sep" />
        <div className="toolbar-stat">Durée: <strong>{config.duration}</strong> min</div>
        <div className="toolbar-sep" />
        <div className="toolbar-stat">Jours: <strong>{days.length}</strong></div>
        <div className="toolbar-spacer" />
        <button className="toolbar-btn" onClick={openAdd}>+ Ajouter</button>
        <button className="toolbar-btn primary" onClick={handleRegenerate}>↺ Regénérer</button>
      </div>

      {/* Day navigation */}
      {days.length > 1 && (
        <div className="pfe-day-nav">
          <span style={{ fontSize: 12, color: 'var(--txt3)', marginRight: 4 }}>Jour :</span>
          {days.map(d => (
            <button key={d} className={`day-btn${d === currentDay ? ' active' : ''}`} onClick={() => setCurrentDay(d)}>
              Jour {d + 1}
            </button>
          ))}
        </div>
      )}

      {/* Schedule grid */}
      <div className="pfe-schedule-scroll">
        {/* Time column */}
        <div className="pfe-time-col">
          <div style={{ height: 48, borderBottom: '0.5px solid var(--border)' }} />
          {daySlots.map(sl => (
            <div className="time-slot" key={sl.id}>{sl.label.split('-')[0]}</div>
          ))}
        </div>

        {/* Rooms grid */}
        <div className="pfe-rooms-grid">
          {/* Room headers */}
          <div className="pfe-rooms-header">
            {rooms.map((r, i) => (
              <div className="room-header-cell" key={r.id}>
                <span className="room-dot" style={{ background: ROOM_COLORS[i % ROOM_COLORS.length] }} />
                {r.name}
              </div>
            ))}
          </div>

          {/* Room bodies */}
          <div className="pfe-rooms-body">
            {rooms.map((r, ri) => (
              <div className="room-col" key={ri}>
                {daySlots.map((sl, si) => {
                  const pres = presentations.find(p => p.day === currentDay && p.room === ri && p.slotId === sl.id)
                  const president = pres ? juries.find(j => j.id === pres.presidentId) : null
                  const members   = pres ? juries.filter(j => pres.juryIds.includes(j.id) && j.id !== pres.presidentId) : []
                  const juryStr   = pres ? [
                    president ? `👑 ${shortName(president)}` : '',
                    ...members.map(j => shortName(j))
                  ].filter(Boolean).join(', ') : ''

                  return (
                    <div className="time-row" key={`${ri}-${si}`}
                      onDragOver={handleDragOver}
                      onDragLeave={handleDragLeave}
                      onDrop={e => handleDrop(e, ri, si)}
                    >
                      {pres && (
                        <div className={`pres-card ${pres.color}`} id={`card-${pres.id}`}
                          draggable
                          onDragStart={e => handleDragStart(e, pres.id)}
                          onDragEnd={handleDragEnd}
                          onClick={() => openEdit(pres)}
                        >
                          <div className="card-student">{pres.student}</div>
                          <div className="card-jury">{juryStr}</div>
                          <div className="card-time">{sl.label}</div>
                        </div>
                      )}
                    </div>
                  )
                })}
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Legend */}
      <div className="pfe-legend">
        {rooms.map((r, i) => (
          <div className="legend-item" key={i}>
            <div className="legend-dot" style={{ background: ROOM_COLORS[i % ROOM_COLORS.length] }} />
            <span>{r.name}</span>
          </div>
        ))}
        <div className="legend-item" style={{ marginLeft: 'auto' }}>👑 = Président du jury</div>
      </div>

      {/* ── Modal overlay ── */}
      {modal && (
        <div className="pfe-modal-overlay" onClick={closeModal}>
          <div className="pfe-modal" onClick={e => e.stopPropagation()}>
            <h2>{modal.mode === 'edit' ? 'Modifier la soutenance' : 'Ajouter une soutenance'}</h2>

            <div className="modal-field">
              <label>Étudiant</label>
              <input type="text" value={modal.pres.student}
                onChange={e => setModal(m => ({ ...m, pres: { ...m.pres, student: e.target.value } }))}
                placeholder="Nom de l'étudiant" />
            </div>

            <div className="modal-field">
              <label>Salle</label>
              <select value={modal.pres.room}
                onChange={e => setModal(m => ({ ...m, pres: { ...m.pres, room: +e.target.value } }))}>
                {rooms.map(r => <option key={r.id} value={r.id}>{r.name}</option>)}
              </select>
            </div>

            <div className="modal-field">
              <label>Créneau horaire</label>
              <select value={modal.pres.slotId}
                onChange={e => setModal(m => ({ ...m, pres: { ...m.pres, slotId: e.target.value } }))}>
                {slots.map(s => <option key={s.id} value={s.id}>Jour {s.day + 1} — {s.label}</option>)}
              </select>
            </div>

            <div className="modal-field">
              <label>Président du jury</label>
              <select value={modal.pres.presidentId}
                onChange={e => setModal(m => ({ ...m, pres: { ...m.pres, presidentId: e.target.value } }))}>
                {juries.map(j => <option key={j.id} value={j.id}>{j.name}</option>)}
              </select>
            </div>

            <div className="modal-field">
              <label>Membres du jury</label>
              <select multiple value={modal.pres.juryIds}
                onChange={e => {
                  const vals = Array.from(e.target.selectedOptions).map(o => o.value)
                  setModal(m => ({ ...m, pres: { ...m.pres, juryIds: vals } }))
                }}>
                {juries.map(j => <option key={j.id} value={j.id}>{j.name}</option>)}
              </select>
              <div className="modal-hint">Maintenez Ctrl (ou ⌘) pour sélectionner plusieurs membres</div>
            </div>

            <div className="pfe-modal-actions">
              {modal.mode === 'edit' && (
                <button className="btn-delete" onClick={handleDelete}>Supprimer</button>
              )}
              <button className="btn-cancel" onClick={closeModal}>Annuler</button>
              <button className="btn-save" onClick={handleSave}>Enregistrer</button>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
