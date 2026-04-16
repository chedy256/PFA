import { createContext, useContext, useState, useCallback } from 'react'

/* ── Constants ── */
const COLORS      = ['card-blue','card-teal','card-purple','card-coral','card-green','card-amber']
const ROOM_COLORS = ['#3B8BD4','#1D9E75','#534AB7','#D85A30','#639922','#BA7517','#D4537E','#5DCAA5']

/* ── Sample name pools ── */
const JURY_FIRST = [
  'Ahmed','Sana','Mohamed','Fatma','Yassine','Leila','Karim','Nadia',
  'Bilel','Rania','Hatem','Amira','Sofiane','Maha','Tarek','Dorra',
  'Walid','Ines','Slim','Nesrine','Omar','Wafa','Fares','Sihem',
  'Hamdi','Lobna','Adnen','Ghofrane','Nizar','Sarra'
]
const JURY_LAST = [
  'Ben Ali','Trabelsi','Saadi','Hamdi','Mansouri','Ghanmi','Khelifi',
  'Amara','Sfaxi','Jlassi','Ouali','Dridi','Chebbi','Marzouk',
  'Baccouche','Tlili','Gargouri','Mbarki','Hajlaoui','Zouari'
]
const STUDENT_FIRST = [
  'Amine','Sara','Khalil','Manel','Hedi','Yasmine','Fedi','Kenza','Wissem',
  'Ghalia','Ayoub','Rim','Zied','Asma','Mehdi','Sirine','Nabil','Chaima',
  'Adel','Lina','Seif','Dina','Hamza','Nour','Rayen','Syrine','Adem','Rym',
  'Mariem','Tarek','Oussama','Eya','Skander','Amani','Jabeur','Hiba'
]
const STUDENT_LAST = [
  'Boussaid','Ferchichi','Ayadi','Brika','Nasri','Chaabane','Riahi','Hajji',
  'Ghedira','Khalil','Bouzid','Farhat','Saidani','Mezghani','Braham','Zouari',
  'Mzali','Bali','Salah','Gharbi','Ben Amor','Jelassi','Abidi','Triki'
]

const PlannerContext = createContext(null)

export { COLORS, ROOM_COLORS }

export function PlannerProvider({ children }) {
  const [config,        setConfig]        = useState(null)
  const [presentations, setPresentations] = useState([])
  const [juries,        setJuries]        = useState([])
  const [rooms,         setRooms]         = useState([])
  const [slots,         setSlots]         = useState([])
  const [currentDay,    setCurrentDay]    = useState(0)

  /* ── Build helpers ── */
  const buildRooms = (c) =>
    Array.from({ length: c.rooms }, (_, i) => ({ id: i, name: `Salle ${String.fromCharCode(65 + i)}` }))

  const buildSlots = (c) => {
    const slotsPerDay = Math.floor((c.endHour - c.startHour) * 60 / c.duration)
    const daysNeeded  = Math.max(1, Math.ceil(c.students / (c.rooms * slotsPerDay)))
    const fmt = mins =>
      `${String(Math.floor(mins / 60)).padStart(2, '0')}:${String(mins % 60).padStart(2, '0')}`
    const result = []
    for (let d = 0; d < daysNeeded; d++) {
      for (let s = 0; s < slotsPerDay; s++) {
        const startMin = c.startHour * 60 + s * c.duration
        const endMin   = startMin + c.duration
        result.push({ id: `d${d}s${s}`, day: d, slot: s, startMin, endMin, label: `${fmt(startMin)}-${fmt(endMin)}` })
      }
    }
    return result
  }

  const buildJuries = (c) =>
    Array.from({ length: c.juries }, (_, i) => ({
      id:   `j${i}`,
      name: `Dr. ${JURY_FIRST[i % JURY_FIRST.length]} ${JURY_LAST[i % JURY_LAST.length]}`
    }))

  const buildStudents = (c) =>
    Array.from({ length: c.students }, (_, i) => ({
      id:   `st${i}`,
      name: `${STUDENT_FIRST[i % STUDENT_FIRST.length]} ${STUDENT_LAST[i % STUDENT_LAST.length]}`
    }))

  /* ── Assign presentations ── */
  const assignPresentations = (c, students, builtJuries, builtSlots) => {
    const result = []
    const slotsPerDay   = Math.floor((c.endHour - c.startHour) * 60 / c.duration)
    const juryDayCount  = {}
    const presidentDay  = {}
    const occupied      = {}

    builtJuries.forEach(j => { juryDayCount[j.id] = {} })

    let stIdx = 0
    const days = [...new Set(builtSlots.map(s => s.day))]

    for (const d of days) {
      for (let s = 0; s < slotsPerDay && stIdx < students.length; s++) {
        for (let r = 0; r < c.rooms && stIdx < students.length; r++) {
          const slot = builtSlots.find(x => x.day === d && x.slot === s)
          const key  = `r${r}_${slot.id}`
          if (occupied[key]) continue

          const available = builtJuries.filter(j => (juryDayCount[j.id][d] || 0) < c.maxPerDay)
          if (available.length < c.jurySize) continue

          const sorted = [...available].sort((a, b) => (juryDayCount[a.id][d] || 0) - (juryDayCount[b.id][d] || 0))
          const picked = sorted.slice(0, c.jurySize)

          const president = picked.reduce((best, j) => {
            const pkJ   = `${j.id}_d${d}`
            const pkBest = `${best.id}_d${d}`
            return (presidentDay[pkJ] || 0) <= (presidentDay[pkBest] || 0) ? j : best
          })

          picked.forEach(j => { juryDayCount[j.id][d] = (juryDayCount[j.id][d] || 0) + 1 })
          const pk = `${president.id}_d${d}`
          presidentDay[pk] = (presidentDay[pk] || 0) + 1

          result.push({
            id: `p${stIdx}`, student: students[stIdx].name,
            room: r, slotId: slot.id, day: d, slot: s,
            juryIds: picked.map(j => j.id), presidentId: president.id,
            color: COLORS[r % COLORS.length]
          })
          occupied[key] = true
          stIdx++
        }
      }
    }
    return result
  }

  /* ── Generate (main action) ── */
  const generate = useCallback((cfg) => {
    const c = cfg
    setConfig(c)
    setCurrentDay(0)

    const builtRooms    = buildRooms(c)
    const builtSlots    = buildSlots(c)
    const builtJuries   = buildJuries(c)
    const students      = buildStudents(c)
    const builtPres     = assignPresentations(c, students, builtJuries, builtSlots)

    setRooms(builtRooms)
    setSlots(builtSlots)
    setJuries(builtJuries)
    setPresentations(builtPres)

    return builtPres.length
  }, [])

  /* ── Drag & drop swap ── */
  const movePres = useCallback((presId, targetRoom, targetSlotIdx) => {
    setPresentations(prev => {
      const next = [...prev.map(p => ({...p}))]
      const p = next.find(x => x.id === presId)
      if (!p) return prev

      const daySlots = slots.filter(s => s.day === currentDay)
      const target   = daySlots[targetSlotIdx]
      if (!target) return prev

      const conflict = next.find(x =>
        x.id !== p.id && x.room === targetRoom && x.slotId === target.id && x.day === currentDay
      )

      if (conflict) {
        const oldRoom   = p.room
        const oldSlotId = p.slotId
        const oldSlot   = daySlots.findIndex(s => s.id === oldSlotId)
        p.room = targetRoom; p.slot = targetSlotIdx; p.slotId = target.id
        p.color = COLORS[targetRoom % COLORS.length]
        conflict.room = oldRoom; conflict.slot = oldSlot; conflict.slotId = oldSlotId
        conflict.color = COLORS[oldRoom % COLORS.length]
      } else {
        p.room = targetRoom; p.slot = targetSlotIdx; p.slotId = target.id
        p.color = COLORS[targetRoom % COLORS.length]
      }
      return next
    })
  }, [slots, currentDay])

  /* ── CRUD presentations ── */
  const updatePresentation = useCallback((id, data) => {
    setPresentations(prev => prev.map(p => p.id === id ? { ...p, ...data } : p))
  }, [])

  const addPresentation = useCallback((data) => {
    setPresentations(prev => [...prev, { id: `p_${Date.now()}`, ...data }])
  }, [])

  const deletePresentation = useCallback((id) => {
    setPresentations(prev => prev.filter(p => p.id !== id))
  }, [])

  const value = {
    config, presentations, juries, rooms, slots, currentDay,
    setCurrentDay, generate, movePres,
    updatePresentation, addPresentation, deletePresentation,
    COLORS, ROOM_COLORS,
  }

  return <PlannerContext.Provider value={value}>{children}</PlannerContext.Provider>
}

export const usePlanner = () => useContext(PlannerContext)
