/* ══════════════════════════════════════════════════════════
   PFE Planner — app.js
   ══════════════════════════════════════════════════════════ */

/* ── Constants ── */
const COLORS      = ['card-blue', 'card-teal', 'card-purple', 'card-coral', 'card-green', 'card-amber'];
const ROOM_COLORS = ['#3B8BD4', '#1D9E75', '#534AB7', '#D85A30', '#639922', '#BA7517', '#D4537E', '#5DCAA5'];

/* ── Sample name pools ── */
const JURY_FIRST = [
  'Ahmed','Sana','Mohamed','Fatma','Yassine','Leila','Karim','Nadia',
  'Bilel','Rania','Hatem','Amira','Sofiane','Maha','Tarek','Dorra',
  'Walid','Ines','Slim','Nesrine','Omar','Wafa','Fares','Sihem',
  'Hamdi','Lobna','Adnen','Ghofrane','Nizar','Sarra'
];
const JURY_LAST = [
  'Ben Ali','Trabelsi','Saadi','Hamdi','Mansouri','Ghanmi','Khelifi',
  'Amara','Sfaxi','Jlassi','Ouali','Dridi','Chebbi','Marzouk',
  'Baccouche','Tlili','Gargouri','Mbarki','Hajlaoui','Zouari'
];
const STUDENT_FIRST = [
  'Amine','Sara','Khalil','Manel','Hedi','Yasmine','Fedi','Kenza','Wissem',
  'Ghalia','Ayoub','Rim','Zied','Asma','Mehdi','Sirine','Nabil','Chaima',
  'Adel','Lina','Seif','Dina','Hamza','Nour','Rayen','Syrine','Adem','Rym',
  'Mariem','Tarek','Oussama','Eya','Skander','Amani','Jabeur','Hiba'
];
const STUDENT_LAST = [
  'Boussaid','Ferchichi','Ayadi','Brika','Nasri','Chaabane','Riahi','Hajji',
  'Ghedira','Khalil','Bouzid','Farhat','Saidani','Mezghani','Braham','Zouari',
  'Mzali','Bali','Salah','Gharbi','Ben Amor','Jelassi','Abidi','Triki'
];

/* ── Application state ── */
const state = {
  config:       null,
  presentations: [],
  juries:       [],
  rooms:        [],
  slots:        [],
  currentDay:   0,
  dragId:       null,
  editId:       null
};

/* ══════════════════════════════════════════
   INIT — runs after DOM is ready
══════════════════════════════════════════ */
document.addEventListener('DOMContentLoaded', () => {
  initTabs();
  initModalClose();
  attachSetupListeners();
  updateConstraintsPreview();
});

/* ══════════════════════════════════════════
   TABS
══════════════════════════════════════════ */
function initTabs() {
  document.querySelectorAll('.tab').forEach(tab => {
    tab.addEventListener('click', () => {
      document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
      document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
      tab.classList.add('active');
      document.getElementById('panel-' + tab.dataset.tab).classList.add('active');
      if (tab.dataset.tab === 'jury')      renderJuryPanel();
      if (tab.dataset.tab === 'conflicts') renderConflicts();
    });
  });
}

/* ══════════════════════════════════════════
   SETUP — read config & live preview
══════════════════════════════════════════ */
function attachSetupListeners() {
  document.querySelectorAll('#panel-setup input').forEach(input => {
    input.addEventListener('input', updateConstraintsPreview);
  });
}

/**
 * Read all form inputs and return a validated config object.
 */
function getCfg() {
  return {
    students:  Math.max(1,  parseInt(document.getElementById('f-students').value,   10) || 12),
    rooms:     Math.max(1,  parseInt(document.getElementById('f-rooms').value,       10) || 3),
    juries:    Math.max(2,  parseInt(document.getElementById('f-juries').value,      10) || 6),
    jurySize:  Math.max(2,  parseInt(document.getElementById('f-jury-size').value,   10) || 2),
    maxPerDay: Math.max(1,  parseInt(document.getElementById('f-max-per-day').value, 10) || 3),
    duration:  Math.max(15, parseInt(document.getElementById('f-duration').value,    10) || 45),
    startHour: Math.max(6,  parseInt(document.getElementById('f-start-hour').value,  10) || 8),
    endHour:   Math.max(13, parseInt(document.getElementById('f-end-hour').value,    10) || 18),
  };
}

/**
 * Rebuild the constraints summary every time an input changes.
 */
function updateConstraintsPreview() {
  const c = getCfg();
  const slotsPerDay    = Math.floor((c.endHour - c.startHour) * 60 / c.duration);
  const capacityPerDay = c.rooms * slotsPerDay;
  const daysNeeded     = capacityPerDay > 0 ? Math.ceil(c.students / capacityPerDay) : '∞';
  const avgPerJury     = (c.students / c.juries).toFixed(1);
  const totalHours     = Math.ceil(c.students * c.duration / 60 * 10) / 10;

  const rows = [
    { icon: '🎓', text: 'Créneaux par jour (par salle)',                    val: slotsPerDay },
    { icon: '🏛',  text: `Capacité totale par jour (${c.rooms} salles)`,   val: capacityPerDay },
    { icon: '📆', text: 'Jours nécessaires (estimé)',                       val: daysNeeded },
    { icon: '👨‍🏫', text: 'Interventions jury au total',                   val: c.students * c.jurySize },
    { icon: '📊', text: 'Soutenances moyennes par jury',                    val: avgPerJury },
    { icon: '⏱',  text: 'Durée totale estimée',                            val: `~${totalHours}h` },
  ];

  document.getElementById('constraints-preview').innerHTML = rows.map(r => `
    <div class="constraint-row">
      <span class="icon">${r.icon}</span>
      <span class="text">${r.text}</span>
      <span class="value">${r.val}</span>
    </div>`).join('');
}

/* ══════════════════════════════════════════
   GENERATE
══════════════════════════════════════════ */
function generate() {
  const c = getCfg();
  state.config     = c;
  state.currentDay = 0;

  buildRooms(c);
  buildSlots(c);
  buildJuries(c);

  const students = buildStudents(c);
  assignPresentations(c, students);

  renderSchedule();
  renderJuryPanel();
  renderConflicts();

  document.getElementById('status-badge').textContent = `${state.presentations.length} soutenances`;
  switchToTab('schedule');
}

/* ── Build rooms ── */
function buildRooms(c) {
  state.rooms = Array.from({ length: c.rooms }, (_, i) => ({
    id: i,
    name: `Salle ${String.fromCharCode(65 + i)}`
  }));
}

/* ── Build time slots ── */
function buildSlots(c) {
  const slotsPerDay = Math.floor((c.endHour - c.startHour) * 60 / c.duration);
  const daysNeeded  = Math.max(1, Math.ceil(c.students / (c.rooms * slotsPerDay)));

  const fmt = mins =>
    `${String(Math.floor(mins / 60)).padStart(2, '0')}:${String(mins % 60).padStart(2, '0')}`;

  state.slots = [];
  for (let d = 0; d < daysNeeded; d++) {
    for (let s = 0; s < slotsPerDay; s++) {
      const startMin = c.startHour * 60 + s * c.duration;
      const endMin   = startMin + c.duration;
      state.slots.push({
        id: `d${d}s${s}`, day: d, slot: s,
        startMin, endMin,
        label: `${fmt(startMin)}-${fmt(endMin)}`
      });
    }
  }
}

/* ── Build jury members ── */
function buildJuries(c) {
  state.juries = Array.from({ length: c.juries }, (_, i) => ({
    id:   `j${i}`,
    name: `Dr. ${JURY_FIRST[i % JURY_FIRST.length]} ${JURY_LAST[i % JURY_LAST.length]}`
  }));
}

/* ── Build student list ── */
function buildStudents(c) {
  return Array.from({ length: c.students }, (_, i) => ({
    id:   `st${i}`,
    name: `${STUDENT_FIRST[i % STUDENT_FIRST.length]} ${STUDENT_LAST[i % STUDENT_LAST.length]}`
  }));
}

/* ── Assign presentations ── */
function assignPresentations(c, students) {
  state.presentations = [];

  const slotsPerDay   = Math.floor((c.endHour - c.startHour) * 60 / c.duration);
  const juryDayCount  = {};   // juryId  → { dayIdx → count }
  const presidentDay  = {};   // `${jid}_d${day}` → count
  const occupied      = {};   // `r${room}_${slotId}` → true

  state.juries.forEach(j => { juryDayCount[j.id] = {}; });

  let stIdx = 0;
  const days = [...new Set(state.slots.map(s => s.day))];

  for (const d of days) {
    for (let s = 0; s < slotsPerDay && stIdx < students.length; s++) {
      for (let r = 0; r < c.rooms && stIdx < students.length; r++) {
        const slot = state.slots.find(x => x.day === d && x.slot === s);
        const key  = `r${r}_${slot.id}`;
        if (occupied[key]) continue;

        // Find available jury members for this day
        const available = state.juries.filter(j =>
          (juryDayCount[j.id][d] || 0) < c.maxPerDay
        );
        if (available.length < c.jurySize) continue;

        // Balance load: pick least-busy jurors
        const sorted = [...available].sort((a, b) =>
          (juryDayCount[a.id][d] || 0) - (juryDayCount[b.id][d] || 0)
        );
        const picked = sorted.slice(0, c.jurySize);

        // Choose president: least-often president today
        const president = picked.reduce((best, j) => {
          const pkJ   = `${j.id}_d${d}`;
          const pkBest = `${best.id}_d${d}`;
          return (presidentDay[pkJ] || 0) <= (presidentDay[pkBest] || 0) ? j : best;
        });

        // Update counters
        picked.forEach(j => {
          juryDayCount[j.id][d] = (juryDayCount[j.id][d] || 0) + 1;
        });
        const pk = `${president.id}_d${d}`;
        presidentDay[pk] = (presidentDay[pk] || 0) + 1;

        state.presentations.push({
          id:          `p${stIdx}`,
          student:     students[stIdx].name,
          room:        r,
          slotId:      slot.id,
          day:         d,
          slot:        s,
          juryIds:     picked.map(j => j.id),
          presidentId: president.id,
          color:       COLORS[r % COLORS.length]
        });

        occupied[key] = true;
        stIdx++;
      }
    }
  }
}

/* ══════════════════════════════════════════
   RENDER SCHEDULE
══════════════════════════════════════════ */
function renderSchedule() {
  if (!state.config) return;

  const day = state.currentDay;

  // Show the schedule view
  document.getElementById('schedule-empty').style.display = 'none';
  document.getElementById('schedule-view').style.display  = 'flex';

  // Update toolbar stats
  document.getElementById('stat-students').textContent = state.presentations.length;
  document.getElementById('stat-rooms').textContent    = state.config.rooms;
  document.getElementById('stat-duration').textContent = state.config.duration;

  const days = [...new Set(state.slots.map(s => s.day))];
  document.getElementById('stat-days').textContent = days.length;

  renderDayNavigation(days, day);

  const daySlots = state.slots.filter(s => s.day === day);

  renderTimeColumn(daySlots);
  renderRoomHeaders();
  renderRoomBodies(daySlots);
  renderCards(daySlots, day);
  renderLegend();
}

/* ── Day navigation pills ── */
function renderDayNavigation(days, currentDay) {
  const nav = document.getElementById('day-nav');
  if (days.length <= 1) {
    nav.style.display = 'none';
    return;
  }
  nav.style.display = 'flex';
  nav.innerHTML = '<span style="font-size:12px;color:var(--txt3);margin-right:4px">Jour :</span>' +
    days.map(d => `
      <button class="day-btn ${d === currentDay ? 'active' : ''}" onclick="switchDay(${d})">
        Jour ${d + 1}
      </button>`).join('');
}

/* ── Time column ── */
function renderTimeColumn(daySlots) {
  document.getElementById('time-col').innerHTML =
    '<div style="height:48px;border-bottom:0.5px solid var(--border)"></div>' +
    daySlots.map(sl => `<div class="time-slot">${sl.label.split('-')[0]}</div>`).join('');
}

/* ── Room header row ── */
function renderRoomHeaders() {
  document.getElementById('rooms-header').innerHTML =
    state.rooms.map((r, i) => `
      <div class="room-header-cell">
        <span class="room-dot" style="background:${ROOM_COLORS[i % ROOM_COLORS.length]}"></span>
        ${r.name}
      </div>`).join('');
}

/* ── Room body (drop zones) ── */
function renderRoomBodies(daySlots) {
  document.getElementById('rooms-body').innerHTML =
    state.rooms.map((r, ri) => `
      <div class="room-col" id="room-col-${ri}">
        ${daySlots.map((sl, si) => `
          <div class="time-row" id="cell-${ri}-${si}"
            ondragover="dragOver(event, '${ri}', '${si}')"
            ondragleave="dragLeave(event)"
            ondrop="drop(event, '${ri}', '${si}')">
          </div>`).join('')}
      </div>`).join('');
}

/* ── Presentation cards ── */
function renderCards(daySlots, day) {
  state.presentations
    .filter(p => p.day === day)
    .forEach(p => {
      const slotIdx = daySlots.findIndex(s => s.id === p.slotId);
      if (slotIdx === -1) return;

      const cell = document.getElementById(`cell-${p.room}-${slotIdx}`);
      if (!cell) return;

      const president = state.juries.find(j => j.id === p.presidentId);
      const members   = state.juries.filter(j => p.juryIds.includes(j.id) && j.id !== p.presidentId);

      const shortName = jury => jury.name.replace(/^Dr\. /, '').split(' ')[0];
      const juryStr   = [
        president ? `👑 ${shortName(president)}` : '',
        ...members.map(j => shortName(j))
      ].filter(Boolean).join(', ');

      cell.innerHTML = `
        <div class="pres-card ${p.color}" id="card-${p.id}"
          draggable="true"
          ondragstart="dragStart(event, '${p.id}')"
          ondragend="dragEnd()"
          onclick="openEditModal('${p.id}')">
          <div class="card-student">${p.student}</div>
          <div class="card-jury">${juryStr}</div>
          <div class="card-time">${daySlots[slotIdx].label}</div>
        </div>`;
    });
}

/* ── Legend ── */
function renderLegend() {
  document.getElementById('legend').innerHTML =
    state.rooms.map((r, i) => `
      <div class="legend-item">
        <div class="legend-dot" style="background:${ROOM_COLORS[i % ROOM_COLORS.length]}"></div>
        <span>${r.name}</span>
      </div>`).join('') +
    '<div class="legend-item" style="margin-left:auto">👑 = Président du jury</div>';
}

/* ── Switch displayed day ── */
function switchDay(d) {
  state.currentDay = d;
  renderSchedule();
}

/* ══════════════════════════════════════════
   DRAG & DROP
══════════════════════════════════════════ */
function dragStart(e, id) {
  state.dragId = id;
  setTimeout(() => {
    const card = document.getElementById(`card-${id}`);
    if (card) card.classList.add('dragging');
  }, 0);
  e.dataTransfer.effectAllowed = 'move';
}

function dragEnd() {
  if (state.dragId) {
    const card = document.getElementById(`card-${state.dragId}`);
    if (card) card.classList.remove('dragging');
  }
}

function dragOver(e, ri, si) {
  e.preventDefault();
  e.currentTarget.classList.add('drag-over');
}

function dragLeave(e) {
  e.currentTarget.classList.remove('drag-over');
}

function drop(e, ri, si) {
  e.preventDefault();
  e.currentTarget.classList.remove('drag-over');
  if (!state.dragId) return;

  const p = state.presentations.find(x => x.id === state.dragId);
  if (!p) return;

  const day      = state.currentDay;
  const daySlots = state.slots.filter(s => s.day === day);
  const target   = daySlots[+si];
  if (!target) return;

  const conflict = state.presentations.find(x =>
    x.id !== p.id && x.room === +ri && x.slotId === target.id && x.day === day
  );

  if (conflict) {
    // Swap the two cards
    const oldRoom   = p.room;
    const oldSlotId = p.slotId;
    const oldSlot   = daySlots.findIndex(s => s.id === oldSlotId);

    p.room    = +ri;     p.slot    = +si;      p.slotId = target.id;
    p.color   = COLORS[+ri % COLORS.length];

    conflict.room   = oldRoom; conflict.slot = oldSlot; conflict.slotId = oldSlotId;
    conflict.color  = COLORS[oldRoom % COLORS.length];
  } else {
    p.room   = +ri;
    p.slot   = +si;
    p.slotId = target.id;
    p.color  = COLORS[+ri % COLORS.length];
  }

  state.dragId = null;
  renderSchedule();
  renderConflicts();
}

/* ══════════════════════════════════════════
   MODAL — Edit / Add presentation
══════════════════════════════════════════ */
function initModalClose() {
  document.getElementById('modal').addEventListener('click', e => {
    if (e.target === document.getElementById('modal')) closeModal();
  });
}

function populateModalSelects() {
  // Rooms
  document.getElementById('modal-room').innerHTML =
    state.rooms.map(r => `<option value="${r.id}">${r.name}</option>`).join('');

  // Slots
  document.getElementById('modal-slot').innerHTML =
    state.slots.map(s => `<option value="${s.id}">Jour ${s.day + 1} — ${s.label}</option>`).join('');

  // Juries (president & members share the same pool)
  const juryHtml = state.juries.map(j =>
    `<option value="${j.id}">${j.name}</option>`).join('');
  document.getElementById('modal-president').innerHTML = juryHtml;
  document.getElementById('modal-members').innerHTML   = juryHtml;
}

function openEditModal(id) {
  state.editId = id;
  const p = state.presentations.find(x => x.id === id);
  if (!p) return;

  populateModalSelects();

  document.getElementById('modal-title').textContent       = 'Modifier la soutenance';
  document.getElementById('modal-id').value                = id;
  document.getElementById('modal-student').value           = p.student;
  document.getElementById('modal-room').value              = p.room;
  document.getElementById('modal-slot').value              = p.slotId;
  document.getElementById('modal-president').value         = p.presidentId;

  const mSel = document.getElementById('modal-members');
  Array.from(mSel.options).forEach(opt => {
    opt.selected = p.juryIds.includes(opt.value);
  });

  document.getElementById('btn-delete').style.display = 'inline-block';
  document.getElementById('modal').classList.remove('hidden');
}

function openAddModal() {
  state.editId = null;
  populateModalSelects();

  document.getElementById('modal-title').textContent       = 'Ajouter une soutenance';
  document.getElementById('modal-id').value                = '';
  document.getElementById('modal-student').value           = '';
  document.getElementById('btn-delete').style.display      = 'none';
  document.getElementById('modal').classList.remove('hidden');
}

function closeModal() {
  document.getElementById('modal').classList.add('hidden');
}

function saveModal() {
  const student = document.getElementById('modal-student').value.trim();
  if (!student) {
    alert('Le nom de l\'étudiant est requis.');
    return;
  }

  const room        = +document.getElementById('modal-room').value;
  const slotId      = document.getElementById('modal-slot').value;
  const presidentId = document.getElementById('modal-president').value;
  const mSel        = document.getElementById('modal-members');
  const memberIds   = Array.from(mSel.selectedOptions).map(o => o.value);

  // Make sure president is always in the jury
  if (!memberIds.includes(presidentId)) memberIds.push(presidentId);

  const slot = state.slots.find(s => s.id === slotId);

  if (state.editId) {
    const p = state.presentations.find(x => x.id === state.editId);
    if (p) {
      p.student     = student;
      p.room        = room;
      p.slotId      = slotId;
      p.day         = slot?.day  ?? 0;
      p.slot        = slot?.slot ?? 0;
      p.presidentId = presidentId;
      p.juryIds     = memberIds;
      p.color       = COLORS[room % COLORS.length];
    }
  } else {
    state.presentations.push({
      id:          `p_${Date.now()}`,
      student,
      room,
      slotId,
      day:         slot?.day  ?? 0,
      slot:        slot?.slot ?? 0,
      presidentId,
      juryIds:     memberIds,
      color:       COLORS[room % COLORS.length]
    });
  }

  closeModal();
  renderSchedule();
  renderJuryPanel();
  renderConflicts();
}

function deletePresentation() {
  if (!state.editId) return;
  if (!confirm('Supprimer cette soutenance ?')) return;
  state.presentations = state.presentations.filter(p => p.id !== state.editId);
  closeModal();
  renderSchedule();
  renderJuryPanel();
  renderConflicts();
}

/* ══════════════════════════════════════════
   JURY PANEL
══════════════════════════════════════════ */
function renderJuryPanel() {
  if (!state.juries.length) return;

  document.getElementById('jury-empty').style.display = 'none';
  const grid = document.getElementById('jury-grid');
  grid.style.display = 'grid';

  grid.innerHTML = state.juries.map(j => {
    const myPres    = state.presentations.filter(p => p.juryIds.includes(j.id));
    const asPresi   = myPres.filter(p => p.presidentId === j.id);
    const total     = myPres.length;
    const statusCls = total === 0 ? 'danger' : total > state.config.maxPerDay ? 'warn' : 'ok';

    // Initials (skip "Dr.")
    const initials = j.name
      .split(' ')
      .filter(w => !w.match(/^(Dr\.|Prof\.)/))
      .map(w => w[0])
      .slice(0, 2)
      .join('');

    const assignments = myPres.map(p => {
      const slot      = state.slots.find(s => s.id === p.slotId);
      const isPresi   = p.presidentId === j.id;
      return `
        <div class="jury-assignment">
          <span class="stname">${p.student}</span>
          <span style="font-size:10px;color:var(--txt3);white-space:nowrap">
            J${p.day + 1} ${slot ? slot.label : '–'}
          </span>
          <span class="pres-badge ${isPresi ? 'president' : 'member'}">
            ${isPresi ? '👑 Président' : 'Membre'}
          </span>
        </div>`;
    }).join('');

    return `
      <div class="jury-card">
        <div class="jury-name">
          <div class="jury-avatar">${initials}</div>
          <span>${j.name}</span>
        </div>
        <div class="jury-stats">
          <span class="jury-stat ${statusCls}">${total} soutenance${total !== 1 ? 's' : ''}</span>
          <span class="jury-stat">${asPresi.length}× Président</span>
        </div>
        <div class="jury-assignments">
          ${assignments || '<div style="font-size:11px;color:var(--txt3);padding:4px 0">Aucune affectation</div>'}
        </div>
      </div>`;
  }).join('');
}

/* ══════════════════════════════════════════
   CONFLICTS / VALIDATION
══════════════════════════════════════════ */
function renderConflicts() {
  if (!state.presentations.length) return;

  document.getElementById('conflict-empty').style.display = 'none';
  const list   = document.getElementById('conflict-list');
  list.style.display = 'flex';

  const issues = [];

  /* 1. Room + slot collision */
  const byCell = {};
  state.presentations.forEach(p => {
    const k = `${p.room}_${p.slotId}`;
    (byCell[k] = byCell[k] || []).push(p);
  });
  Object.values(byCell).forEach(arr => {
    if (arr.length > 1) {
      issues.push({
        type: 'error',
        msg:  `Conflit de salle : ${arr.map(x => x.student).join(' et ')} — même salle et même créneau`
      });
    }
  });

  /* 2. Jury double-booking (same slot) */
  const jurySlot = {};
  state.presentations.forEach(p => {
    p.juryIds.forEach(jid => {
      const k = `${jid}_${p.slotId}`;
      (jurySlot[k] = jurySlot[k] || []).push(p.student);
    });
  });
  Object.entries(jurySlot).forEach(([k, arr]) => {
    if (arr.length > 1) {
      const jid  = k.split('_d')[0];
      const jury = state.juries.find(j => j.id === jid);
      issues.push({
        type: 'error',
        msg:  `${jury?.name} est affecté à 2 soutenances simultanées : ${arr.join(' et ')}`
      });
    }
  });

  /* 3. Max-per-day exceeded */
  const juryDayMap = {};
  state.presentations.forEach(p => {
    p.juryIds.forEach(jid => {
      const k = `${jid}_d${p.day}`;
      juryDayMap[k] = (juryDayMap[k] || 0) + 1;
    });
  });
  Object.entries(juryDayMap).forEach(([k, cnt]) => {
    if (cnt > state.config.maxPerDay) {
      const [jid] = k.split('_d');
      const jury  = state.juries.find(j => j.id === jid);
      issues.push({
        type: 'warn',
        msg:  `${jury?.name} dépasse la limite de ${state.config.maxPerDay} soutenances/jour (${cnt} affectées)`
      });
    }
  });

  /* 4. Unscheduled students */
  const unassigned = state.config.students - state.presentations.length;
  if (unassigned > 0) {
    issues.push({
      type: 'warn',
      msg:  `${unassigned} étudiant(s) sans soutenance planifiée (jurys insuffisants pour couvrir tous les créneaux)`
    });
  }

  /* 5. All good */
  if (issues.length === 0) {
    issues.push({ type: 'ok', msg: 'Aucun conflit détecté — le planning est valide ✓' });
  }

  list.innerHTML = issues.map(i => `
    <div class="conflict-item ${i.type}">
      <div class="conflict-dot"></div>
      <span>${i.msg}</span>
    </div>`).join('');
}

/* ══════════════════════════════════════════
   HELPERS
══════════════════════════════════════════ */
function switchToTab(tabName) {
  document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
  document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
  document.querySelector(`[data-tab="${tabName}"]`).classList.add('active');
  document.getElementById(`panel-${tabName}`).classList.add('active');
}
