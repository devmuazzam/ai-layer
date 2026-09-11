// EXTRACT of 'TCG Platform (standalone) for pregress tracking.html' (~/Downloads, 2026-09-10 21:35), unpacked template.html.
// Section A: job-detail Progress Tracking tab — template.html lines 8949-9870
  // ── Job Progress Tracking ────────────────────────────────────
  PT_STEP_META = {
    preTrip: ['Pre-Trip Inspection', 'clipboard'], leftYard: ['Left Yard', 'truck'], driving: ['Driving to Site', 'truck'],
    arrivedJob: ['Arrive Job', 'mapPin'], custFirstSig: ['Customer First Signature', 'penTool'],
    jsa: ['JSA \u2014 Tailboard', 'shield'],
    startWork: ['Start Work (Boom Time)', 'play'], incident: ['Incident / Mishap Report', 'alert'],
    endWork: ['End Work (Boom Time)', 'pause'], custSig: ['Customer Final Signature', 'penTool'],
    leftJob: ['Left Job Site', 'truck'], arriveYard: ['Arrive Yard', 'home'],
    postInsp: ['Post-Trip Inspection', 'clipboard'],
    compliance: ['Compliance Checklist', 'fileText'], labor: ['Labor & Unit Details', 'ruler'],
    review: ['Review & Complete', 'checkCircle'],
  };
  ptAllPending() {
    return ['preTrip', 'leftYard', 'driving', 'arrivedJob', 'custFirstSig', 'jsa', 'startWork', 'endWork', 'custSig', 'leftJob', 'arriveYard', 'postInsp', 'compliance', 'labor', 'review'].map(k => ({ k, st: 'pending' }));
  }
  ptAssetList() {
    return [
      { key: 'crane', name: 'Crane', code: '10003', items: ['Load Line / Hook / Sheaves', 'Straps / Shackles / Tag Line / Air Port Flag / Safety Chains / Rope', 'Spill and Clean Kits / Cones / Wheel Chalks / Fire Extinguisher', 'Crane Annual and Quad Certification Stickers', 'Head Lights / Running Lights / Auxiliary Lights', 'Warning Labels', 'Coolant Level', 'Engine Oil', 'Belts and Pulleys', 'Seat Belts', 'Tire and Lugnuts', 'Mud Flats', 'Windows and Mirrors', 'Brake Operation', 'Compliance: Registration / Tags / Annual Permits / Operating Manual / Load Chart', 'Annual Permits', 'Additional Comments'] },
      { key: 'tractor', name: 'Tractor', code: 'AT15', items: ['Chains / Binders', 'Straps / Shackles', 'Spill and Clean Kits', 'Air Hoses', 'Inspection Stickers', 'PPE', 'Auxiliary Lights', 'Safety Chains and Tape', 'Warning Labels', 'Coolant Level', 'Engine Oil', 'Belts and Pulleys', 'Seat Belts', 'Hydraulic Oil Level', 'Power Steering Fluid', 'Tires and Lugnuts', 'Mud Flaps and Rims', 'Windows and Mirrors', 'Lights and Signals', 'Brake Operation', 'Registration and Tags', 'Insurance Cards', 'Travel Permits', 'Trailer Connections', 'Load Strapped Down', 'Additional Comments'] },
      { key: 'trailer', name: 'Trailer', code: '10003 OL', items: ['Insurance and Registration', 'Wheel Chalks', 'DOT Tape', 'Deck Condition'] },
    ];
  }
  PT_CK_DEFS = [
    { key: 'preTrip', name: 'Pre-Trip Checklist', inspLabel: 'Pre-Trip Inspection', colOpts: ['Completed', 'Deficiency', 'N/A'], assets: this.ptAssetList() },
    { key: 'jsa', name: 'JSA Checklist', questions: [
      { q: 'Working Near Cranes / Suspended Loads / Falling Objects / Moving Machinery / Tag Lines / Lift Barricades / Ladders Used / Tools and Equipment / Sharp Metals', opts: ['OK', 'Issue', 'N/A'] },
      { q: 'PPE: Gloves / High Visibility Vests / Safety Glasses / Fall Arrest Systems', opts: ['OK', 'Issue', 'N/A'] },
      { q: 'Site Conditions: Poor Lighting / Poor Visibility / Slippery Surfaces / Trip Hazards / Working at Heights / Flammable and Pressurized Fluids and Materials in Area / Inhalable Dust or Fibers / High Noise Area / Communication Difficulties / Street Permits / Lane Closures / FAA Permit / Pedestrian Control', opts: ['OK', 'Issue', 'N/A'] },
      { q: 'Rigging: Shackles / Chains / Slings / Cables / Spreader Bar', opts: ['OK', 'Issue', 'N/A'] },
      { q: 'Electrical > 4001 AMPS / Multiple Electrical Feeds / Equipment Grounded', opts: ['OK', 'Issue', 'N/A'] },
      { q: 'Safety Meeting Performed', opts: ['OK', 'Issue', 'N/A'] },
    ] },
    { key: 'postTrip', name: 'Post-Trip Checklist', inspLabel: 'Post-Trip Inspection', autoFill: true, colOpts: ['Completed', 'Deficiency', 'N/A'], assets: this.ptAssetList() },
    { key: 'compliance', name: 'Compliance Checklist', questions: [
      { q: 'Per-diem eligible (\u2265 50 mi)?', opts: ['Yes', 'No', 'N/A'] },
      { q: 'Timesheet submitted?', opts: ['Yes', 'No', 'N/A'] },
      { q: 'JHA reviewed & signed?', opts: ['Yes', 'No', 'N/A'] },
      { q: 'Required PPE worn all shift?', opts: ['Yes', 'No', 'N/A'] },
    ] },
  ];
  PT_CK_ANSWERS = {
    'TK-11722': { preTrip: { crane: [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2], tractor: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], trailer: [0, 0, 0, 0] }, jsa: [0, 0, 0, 0, 0, 0], postTrip: null, compliance: null },
    'TK-34098': { preTrip: { crane: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], tractor: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], trailer: [0, 0, 0, 0] }, jsa: [0, 0, 0, 0, 0, 0], postTrip: { crane: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], tractor: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], trailer: [0, 0, 0, 0] }, compliance: [0, 0, 0, 0] },
    'TK-55310': { preTrip: { crane: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 2], tractor: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], trailer: [0, 0, 0, 0] }, jsa: [0, 0, 0, 0, 0, 0], postTrip: { crane: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], tractor: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2], trailer: [0, 0, 1, 0] }, compliance: [1, 0, 0, 0] },
    'TK-12935': { preTrip: null, jsa: null, postTrip: null, compliance: null },
  };
  PT_CK_DEFECTS = {
    'TK-11722': {
      'preTrip:crane:4': { desc: 'Right auxiliary light out — bulb replacement needed before night operation.', priority: 'Medium', photo: true, gps: '34.0512, -118.2440', ts: '9:28 AM' },
      'preTrip:crane:11': { desc: 'Rear mud flap torn and hanging loose against the tire.', priority: 'Low', photo: true, gps: '34.0512, -118.2440', ts: '9:29 AM' },
    },
    'TK-55310': {
      'preTrip:crane:10': { desc: 'Front driver-side lug nuts loose — two missing torque caps. Flagged for shop before next lift.', priority: 'High', photo: true, gps: '34.0522, -118.2437', ts: '7:08 AM' },
      'postTrip:trailer:2': { desc: 'DOT reflective tape peeling on rear left corner — reapply at yard.', priority: 'Low', photo: true, gps: '34.0498, -118.2501', ts: '4:49 PM' },
    },
  };
  ptPriorityTone(p) {
    return { Low: 'grey', Medium: 'amber', High: 'red', 'EMERGENCY — Blocking': 'red' }[p] || 'amber';
  }
  ptCkStats(def, arr) {
    const started = arr != null;
    let total = 0, answered = 0, hasDef = false;
    if (def.assets) {
      def.assets.forEach(a => { total += a.items.length; const av = started ? arr[a.key] : null; if (av) a.items.forEach((_, i) => { if (av[i] >= 0) { answered++; if (def.colOpts[av[i]] === 'Deficiency') hasDef = true; } }); });
    } else {
      total = def.questions.length;
      if (started) def.questions.forEach((q, i) => { if (arr[i] >= 0) { answered++; const o = q.opts[arr[i]]; if (o === 'Fail' || o === 'Deficiency' || o === 'Issue') hasDef = true; } });
    }
    return { started, total, answered, hasDef };
  }
  // Checklists live inside the step flow — a ticket cannot complete until every one is answered.
  // Each checklist is captured at its own step — reaching past that step means it is filled.
  PT_CK_STEP_GATE = { preTrip: 'preTrip', jsa: 'jsa', postTrip: 'postInsp', compliance: 'compliance' };
  ptCkFilled(def) {
    if (def.assets) { const o = {}; def.assets.forEach(a => { o[a.key] = a.items.map((_, i) => i === a.items.length - 1 ? 2 : 0); }); return o; }
    return def.questions.map(() => 0);
  }
  ptCkAnswers(t) {
    const real = this.PT_CK_ANSWERS[t.id] || {};
    const stepSt = {}; (t.timeline || []).forEach(x => { stepSt[x.k] = x.st; });
    const out = {};
    this.PT_CK_DEFS.forEach(d => {
      if (real[d.key] != null) { out[d.key] = real[d.key]; return; }
      const gs = stepSt[this.PT_CK_STEP_GATE[d.key]];
      if (gs && gs !== 'pending' && gs !== 'progress') out[d.key] = this.ptCkFilled(d);
    });
    return out;
  }
  ptCkRollup(t) {
    const defs = this.PT_CK_DEFS;
    const ans = this.ptCkAnswers(t);
    let done = 0, defects = 0, open = [];
    defs.forEach(d => {
      const st = this.ptCkStats(d, ans[d.key]);
      if (st.hasDef) defects++;
      if (st.started && st.answered === st.total) done++; else open.push(d.name);
    });
    return { done, total: defs.length, defects, open, allDone: done === defs.length };
  }
  ptCkOptChip(o, on) {
    let c = '#94a3b8', bg = '#fff', bd = '#e2e8f0';
    if (on) { if (o === 'Completed' || o === 'Pass' || o === 'Yes' || o === 'OK') { c = '#067647'; bg = '#ecfdf3'; bd = '#abefc6'; } else if (o === 'Deficiency' || o === 'Fail' || o === 'Issue') { c = '#b42318'; bg = '#fef3f2'; bd = '#fecdca'; } else if (o === 'No') { c = '#b54708'; bg = '#fffaeb'; bd = '#fedf89'; } else { c = '#175cd3'; bg = '#eff8ff'; bd = '#b2ddff'; } }
    return this.h('span', { style: { display: 'inline-flex', alignItems: 'center', gap: '.35rem', borderRadius: '8px', padding: '.28rem .65rem', fontSize: '12px', fontWeight: on ? 700 : 600, color: c, background: bg, border: '1px solid ' + bd } },
      on ? this.icon('check', 12, c) : this.h('span', { style: { width: '11px', height: '11px', borderRadius: '999px', border: '1.5px solid #cbd5e1' } }), o);
  }
  ptCkDefect(t, key) { return (this.PT_CK_DEFECTS[t.id] || {})[key]; }
  ptCkItemRow(num, text, opts, sel, detail, hideUnanswered, resultOnly) {
    const isDef = sel >= 0 && (opts[sel] === 'Deficiency' || opts[sel] === 'Issue');
    if (resultOnly) {
      return this.h('div', { key: num, style: { padding: '.5rem 0', borderTop: num > 1 ? '1px solid #f1f5f9' : 'none' } },
        this.h('div', { style: { display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: '.75rem' } },
          this.h('span', { style: { fontSize: '13px', fontWeight: 600, color: 'var(--ink)', lineHeight: 1.4 } }, num + '. ' + text),
          sel >= 0 ? this.h('span', { style: { flexShrink: 0 } }, this.ptCkOptChip(opts[sel], true)) : this.h('span', { style: { flexShrink: 0, fontSize: '12px', fontWeight: 700, color: '#cbd5e1' } }, '\u2014')),
        isDef ? this.ptDefectPanel(detail) : null);
    }
    return this.h('div', { key: num, style: { padding: '.7rem 0', borderTop: num > 1 ? '1px solid #f1f5f9' : 'none' } },
      this.h('div', { style: { display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: '.75rem', marginBottom: '.5rem' } },
        this.h('span', { style: { fontSize: '13.5px', fontWeight: 600, color: 'var(--ink)', lineHeight: 1.4 } }, num + '. ' + text),
        (sel < 0 && !hideUnanswered) ? this.ptMiniPill('Not answered', 'amber') : null),
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.4rem' } }, opts.map((o, oi) => this.h('span', { key: oi }, this.ptCkOptChip(o, oi === sel)))),
      isDef ? this.ptDefectPanel(detail) : null);
  }
  ptDefectPanel(d) {
    if (!d) return this.h('div', { style: { marginTop: '.6rem', display: 'flex', alignItems: 'center', gap: '.4rem', borderRadius: '10px', border: '1px solid #fecdca', background: '#fffbfa', padding: '.6rem .8rem', fontSize: '12.5px', fontWeight: 600, color: '#b42318' } },
      this.icon('alert', 14, '#b42318'), 'Deficiency logged \u2014 no details captured.');
    const tone = this.ptPriorityTone(d.priority);
    return this.h('div', { style: { marginTop: '.6rem', borderRadius: '12px', border: '1px solid #fecdca', background: '#fffbfa', overflow: 'hidden' } },
      this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', padding: '.6rem .8rem', background: '#fef3f2', borderBottom: '1px solid #fecdca' } },
        this.icon('alert', 15, '#b42318'), this.h('span', { style: { flex: 1, fontSize: '12.5px', fontWeight: 800, color: '#912018' } }, 'Deficiency details'),
        this.h('span', { style: { display: 'flex', alignItems: 'center', gap: '.3rem', fontSize: '11px', fontWeight: 700, color: 'var(--text3)' } }, this.icon('clock', 11, '#94a3b8'), d.ts)),
      this.h('div', { style: { padding: '.8rem', display: 'flex', flexDirection: 'column', gap: '.7rem' } },
        this.h('div', { style: { fontSize: '13px', color: 'var(--text2)', lineHeight: 1.55 } }, d.desc),
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', flexWrap: 'wrap' } },
          this.h('span', { style: { fontSize: '11px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '.04em', color: 'var(--muted)' } }, 'Priority'),
          this.ptMiniPill(d.priority, tone)),
        d.photo ? this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.7rem' } },
          this.h('div', { style: { width: '76px', height: '58px', flexShrink: 0, borderRadius: '9px', border: '1px dashed #cbd5e1', background: '#f8fafc', display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon('camera', 20, '#94a3b8')),
          this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.15rem' } },
            this.h('span', { style: { fontSize: '12px', fontWeight: 700, color: 'var(--ink)' } }, 'Photo attached'),
            this.h('span', { style: { display: 'flex', alignItems: 'center', gap: '.3rem', fontSize: '11.5px', color: 'var(--text3)' } }, this.icon('mapPin', 11, '#94a3b8'), 'GPS ' + d.gps))) : null));
  }
  ptCkBody(t, def, arr, resultOnly) {
    const s = this.ptCkStats(def, arr);
    if (def.assets) {
      const asset = def.assets.find(a => a.key === this.state.ptCkAsset) || def.assets[0];
      const av = s.started ? arr[asset.key] : null;
      const tabs = this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.4rem', marginBottom: '.9rem' } }, def.assets.map(a => {
        const on = a.key === asset.key;
        const astarted = s.started && arr[a.key];
        const adone = astarted && arr[a.key].filter(x => x >= 0).length === a.items.length;
        const dot = !astarted ? '#cbd5e1' : (arr[a.key].some((x, i) => x >= 0 && def.colOpts[x] === 'Deficiency') ? '#f79009' : adone ? '#22c55e' : '#2e90fa');
        return this.h('button', { key: a.key, onClick: () => this.setState({ ptCkAsset: a.key }), style: { display: 'inline-flex', alignItems: 'center', gap: '.4rem', height: '34px', padding: '0 .85rem', borderRadius: '9px', border: '1px solid ' + (on ? 'transparent' : 'var(--border)'), background: on ? 'var(--blue)' : '#fff', color: on ? '#fff' : 'var(--text2)', fontSize: '13px', fontWeight: 700, cursor: 'pointer' } },
          this.h('span', { style: { width: '7px', height: '7px', borderRadius: '999px', background: dot } }), a.name, this.h('span', { style: { fontSize: '11px', fontWeight: 600, opacity: .8 } }, '(' + a.items.length + ')'));
      }));
      const photo = this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.9rem', borderRadius: '12px', border: '1px solid var(--border)', background: '#fbfcfe', padding: '.7rem .8rem', marginBottom: '.85rem' } },
        this.h('div', { style: { width: '96px', height: '68px', flexShrink: 0, borderRadius: '10px', border: '1px dashed #cbd5e1', background: 'repeating-linear-gradient(45deg,#f1f5f9,#f1f5f9 8px,#e9eef5 8px,#e9eef5 16px)', display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon('camera', 22, '#94a3b8')),
        this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.15rem' } },
          this.h('span', { style: { fontSize: '13px', fontWeight: 700, color: 'var(--ink)' } }, asset.name + ' unit photo'),
          this.h('span', { style: { fontSize: '11.5px', color: 'var(--text3)' } }, asset.code + ' \u00B7 captured at ' + (def.inspLabel || 'inspection')),
          this.h('span', { style: { display: 'flex', alignItems: 'center', gap: '.3rem', fontSize: '11.5px', fontWeight: 600, color: '#175cd3', marginTop: '.15rem' } }, this.icon('camera', 12, '#175cd3'), 'Photo on file')));
      const meta = this.h('div', { style: { fontSize: '11.5px', fontWeight: 700, letterSpacing: '.03em', color: 'var(--muted)', textTransform: 'uppercase', marginBottom: '.5rem' } }, 'Unit Checklist \u00B7 ' + asset.code + ' \u2014 ' + asset.name + ' ' + (def.inspLabel || 'Pre-Trip Inspection'));
      const rows = this.h('div', {}, asset.items.map((it, i) => this.ptCkItemRow(i + 1, it, def.colOpts, av ? av[i] : -1, this.ptCkDefect(t, def.key + ':' + asset.key + ':' + i), def.autoFill, resultOnly)));
      return [tabs, resultOnly ? null : photo, meta, rows].filter(Boolean);
    }
    return def.questions.map((q, i) => this.ptCkItemRow(i + 1, q.q, q.opts, s.started ? arr[i] : -1, this.ptCkDefect(t, def.key + ':' + i), def.autoFill, resultOnly));
  }
  ptStepCk(t, defKey) {
    const def = this.PT_CK_DEFS.find(d => d.key === defKey);
    if (!def) return null;
    const arr = this.ptCkAnswers(t)[defKey];
    if (arr == null) return this.h('div', { style: { fontSize: '12.5px', color: 'var(--text3)', fontStyle: 'italic' } }, 'Checklist not started.');
    return this.h('div', { style: { borderRadius: '12px', border: '1px solid var(--border)', background: '#fbfcfe', padding: '.85rem 1rem' } }, this.ptCkBody(t, def, arr, true));
  }
  ptCkCard(t, def, arr) {
    const s = this.ptCkStats(def, arr);
    let code, label;
    if (!s.started) { code = 'pending'; label = 'Not started'; }
    else if (s.answered < s.total) { code = 'progress'; label = 'In progress \u00B7 ' + s.answered + '/' + s.total; }
    else if (s.hasDef) { code = 'flagged'; label = 'Completed \u00B7 needs review'; }
    else { code = 'done'; label = 'Completed'; }
    const key = t.id + ':ck:' + def.key;
    const open = !!this.state.ptExpand[key];
    const v = this.ptVis(code);
    const header = this.h('button', { onClick: () => this.setState(st => ({ ptExpand: { ...st.ptExpand, [key]: !st.ptExpand[key] } })),
      style: { display: 'flex', alignItems: 'center', gap: '.7rem', width: '100%', textAlign: 'left', background: open ? '#fbfcfe' : '#fff', border: '1px solid ' + (open ? v.bd : 'var(--border)'), borderRadius: open ? '12px 12px 0 0' : '12px', padding: '.8rem 1rem', cursor: 'pointer' } },
      this.icon('clipboard', 16, v.c),
      this.h('span', { style: { flex: 1, minWidth: 0, fontSize: '14px', fontWeight: 700, color: 'var(--ink)' } }, def.name),
      def.assets ? this.h('span', { style: { fontSize: '11px', fontWeight: 600, color: 'var(--text3)' } }, '3 assets') : null,
      this.h('span', { style: { fontSize: '11.5px', fontWeight: 700, color: 'var(--text3)', background: '#f1f5f9', borderRadius: '999px', padding: '.15rem .55rem' } }, s.answered + '/' + s.total),
      this.ptChip(code, label),
      this.h('span', { style: { display: 'flex', flexShrink: 0, transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .15s' } }, this.icon('chevron', 16, '#94a3b8')));
    const body = this.ptCkBody(t, def, arr, false);
    const panel = open ? this.h('div', { style: { border: '1px solid ' + v.bd, borderTop: 'none', borderRadius: '0 0 12px 12px', background: '#fff', padding: '.85rem 1rem 1rem' } }, body) : null;
    return this.h('div', { key: def.key, style: { display: 'flex', flexDirection: 'column' } }, header, panel);
  }
  ptChecklistsSection(t) {
    const ans = this.ptCkAnswers(t);
    const ck = this.ptCkRollup(t);
    const done = ck.done;
    const gate = ck.allDone
      ? { c: '#067647', bg: '#ecfdf3', bd: '#abefc6', icon: 'checkCircle', text: 'All checklists answered \u2014 ticket is clear to complete.' }
      : { c: '#b54708', bg: '#fffaeb', bd: '#fedf89', icon: 'clock', text: 'Ticket cannot be completed until every checklist is answered \u2014 not yet reached: ' + ck.open.join(', ') + '.' };
    return this.h('div', { style: { marginTop: '1.9rem' } },
      this.h('div', { style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '.75rem', marginBottom: '.75rem' } },
        this.h('div', { style: { fontSize: '13px', fontWeight: 700, letterSpacing: '.04em', color: 'var(--text2)' } }, 'CHECKLISTS'),
        this.h('span', { style: { fontSize: '12px', fontWeight: 700, color: 'var(--text3)' } }, done + ' of ' + this.PT_CK_DEFS.length + ' complete')),
      this.h('div', { style: { fontSize: '12.5px', color: 'var(--text3)', marginBottom: '.85rem' } }, 'Captured inside the step flow \u2014 listed here only for monitoring.'),
      this.h('div', { style: { display: 'flex', alignItems: 'flex-start', gap: '.5rem', borderRadius: '12px', border: '1px solid ' + gate.bd, background: gate.bg, padding: '.7rem .85rem', marginBottom: '1.1rem' } },
        this.h('span', { style: { display: 'flex', flexShrink: 0, marginTop: '1px' } }, this.icon(gate.icon, 15, gate.c)),
        this.h('span', { style: { fontSize: '12.5px', fontWeight: 600, color: gate.c, lineHeight: 1.45 } }, gate.text)),
      this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.75rem' } }, this.PT_CK_DEFS.map(def => this.ptCkCard(t, def, ans[def.key]))));
  }
  PT_SCHEDULES = [
    { date: '04/09/2026', status: 'Ticket Sent', tone: 'blue', tickets: [
      { id: 'TK-11722', name: 'Richard Lee', role: 'Operator', roleTone: '#d1218b', opened: true, idx: 3,
        summary: { step: 11, total: 15, current: 'Arrive Yard — Incomplete', boomHrs: '3.6', net: '3.6 hrs', incidents: 0, deficiencies: 2, boomPaused: false, incomplete: true, incompleteStep: 'Arrive Yard', expiredAt: '5:00 PM' },
        timeline: [
          { k: 'preTrip', st: 'flagged', result: 'pass', time: '5:45 AM', defCount: 2, items: [['Fluids & leaks', 'pass'], ['Wire rope', 'pass'], ['Head lights', 'fail'], ['Mud flats', 'fail'], ['Brake operation', 'pass']],
            deficiencies: [['Auxiliary light out', 'Minor'], ['Mud flap torn', 'Minor']] },
          { k: 'leftYard', st: 'done', time: '6:00 AM', gps: '1400 Eastside Blvd · ±8m', meta: [['Odometer out', '84,201 mi'], ['Unit', 'CR-118 · 90-ton']] },
          { k: 'driving', st: 'done', departed: '6:00 AM', driveTime: '00:54:58', eta: '22 min', distance: '14.3 mi', dest: '1847 Harbor Blvd, Long Beach, CA 90802', geofence: true },
          { k: 'arrivedJob', st: 'flagged', time: '9:24 AM', est: '9:00 AM', varMin: 24, gps: '1400 Eastside Blvd · ±8m', note: 'Traffic delay on I-45 reported by operator.' },
          { k: 'custFirstSig', st: 'done', time: '9:30 AM', signedBy: 'K. Ramos · Site Rep', identity: true },
          { k: 'jsa', st: 'done', time: '9:40 AM', issues: 0 },
          { k: 'startWork', st: 'done', boomStart: '1:08 PM',
            lunches: [
              { n: 1, start: '12:05 PM', end: '12:35 PM', dur: '30 min' },
              { n: 2, locked: true, note: 'Available after Break 1 is resolved · after ~10h work' },
              { n: 3, locked: true, note: 'Available after Break 2 is resolved · after ~15h work' },
            ],
            breakdown: { start: '1:15 PM', end: '1:29 PM', pausedMin: 14, ended: true, cause: 'Hydraulic line failure — boom paused' } },
          { k: 'endWork', st: 'done', boomStart: '1:08 PM', boomEnd: '4:45 PM', est: '5:00 PM', varMin: -15, elapsed: '3.6 h', pausedMin: 14, boomHrs: '3.6' },
          { k: 'custSig', st: 'done', time: '4:52 PM', signedBy: 'K. Ramos · Site Rep', identity: true },
          { k: 'leftJob', st: 'done', time: '5:05 PM', gps: '1847 Harbor Blvd, Long Beach · ±10m' },
          { k: 'arriveYard', st: 'incomplete', est: '5:00 PM', overdue: true, note: 'Allocated shift time expired at 5:00 PM before Arrive Yard was confirmed — no yard check-in or GPS return recorded.' },
          { k: 'postInsp', st: 'pending' },
          { k: 'compliance', st: 'pending' },
          { k: 'labor', st: 'pending' },
          { k: 'review', st: 'pending' },
        ] },
      { id: 'TK-34098', name: 'John Smith', role: 'Oiler', roleTone: '#4338ca', opened: true, idx: 7,
        summary: { step: 7, total: 15, current: 'Start Work (Boom Time) — Blocked (Incident)', boomHrs: '0.0', net: '—', incidents: 1, deficiencies: 0, boomPaused: false, flagged: true, blocked: true, incidentMessage: 'Crane boom has been broken.', incidentReportedBy: 'John Smith (Field Worker)', incidentVia: 'TCG Field Mobile App', incidentStep: 'Start Work (Boom Time)' },
        timeline: [
          { k: 'preTrip', st: 'done', result: 'pass', time: '5:40 AM', defCount: 0, items: [['Fluids & leaks', 'pass'], ['Wire rope', 'pass'], ['Mirrors', 'pass'], ['Lights & horn', 'pass']] },
          { k: 'leftYard', st: 'done', time: '5:50 AM', gps: '1400 Eastside Blvd · ±8m', meta: [['Odometer out', '112,004 mi'], ['Unit', 'CR-092 · 60-ton']] },
          { k: 'driving', st: 'done', departed: '5:50 AM', driveTime: '01:02:14', eta: 'on time', distance: '38.6 mi', dest: '1847 Harbor Blvd, Long Beach, CA 90802', geofence: true },
          { k: 'arrivedJob', st: 'done', time: '8:52 AM', est: '9:00 AM', varMin: -8, gps: '1400 Eastside Blvd · ±8m' },
          { k: 'custFirstSig', st: 'done', time: '8:58 AM', signedBy: 'M. Alvarez · Site Superintendent', identity: true },
          { k: 'jsa', st: 'done', time: '9:06 AM', issues: 0 },
          { k: 'startWork', st: 'incident', boomStart: null, incidentReported: true, incidentMessage: 'Crane boom has been broken.', incidentReportedBy: 'John Smith (Field Worker)', incidentVia: 'TCG Field Mobile App', lunches: [], breakdown: null },
          { k: 'endWork', st: 'pending' },
          { k: 'custSig', st: 'pending' },
          { k: 'leftJob', st: 'pending' },
          { k: 'arriveYard', st: 'pending' },
          { k: 'postInsp', st: 'pending' },
          { k: 'compliance', st: 'pending' },
          { k: 'labor', st: 'pending' },
          { k: 'review', st: 'pending' },
        ] },
      { id: 'TK-55310', name: 'Maria Torres', role: 'Operator', roleTone: '#d1218b', opened: true, idx: 2,
        summary: { step: 14, total: 15, current: 'Review blocked', boomHrs: '6.4', net: '6.4 hrs', incidents: 0, deficiencies: 1, boomPaused: false, blocked: true },
        timeline: [
          { k: 'preTrip', st: 'done', result: 'pass', time: '5:15 AM', defCount: 0, items: [['Fluids & leaks', 'pass'], ['Wire rope', 'pass'], ['Mirrors', 'pass'], ['Lights & horn', 'pass']] },
          { k: 'leftYard', st: 'done', time: '5:30 AM', gps: '1400 Eastside Blvd · ±8m', meta: [['Odometer out', '67,540 mi'], ['Unit', 'CR-140 · 110-ton']] },
          { k: 'driving', st: 'done', departed: '5:30 AM', driveTime: '01:28:40', eta: 'on time', distance: '52.1 mi', dest: '900 Pier F Ave, Long Beach, CA 90802', geofence: true },
          { k: 'arrivedJob', st: 'done', time: '7:02 AM', est: '7:00 AM', varMin: 2, gps: '900 Pier F Ave · ±6m' },
          { k: 'custFirstSig', st: 'done', time: '7:08 AM', signedBy: 'D. Cole · Project Manager', identity: true },
          { k: 'jsa', st: 'done', time: '7:16 AM', issues: 0 },
          { k: 'startWork', st: 'done', boomStart: '7:20 AM',
            lunches: [{ n: 1, start: '12:00 PM', end: '12:30 PM', dur: '30 min' }, { n: 2, skipped: true }],
            breakdown: { start: '11:40 AM', end: '12:02 PM', pausedMin: 22, ended: true, cause: 'Outrigger re-level' } },
          { k: 'endWork', st: 'flagged', boomStart: '7:20 AM', boomEnd: '3:47 PM', est: '3:00 PM', varMin: 47, elapsed: '6.77 h', pausedMin: 22, boomHrs: '6.4' },
          { k: 'custSig', st: 'flagged', refused: true, note: 'Customer declined to sign — disputed billable hours. Blocks Review & Complete.' },
          { k: 'leftJob', st: 'done', time: '3:58 PM', gps: '900 Pier F Ave · ±6m' },
          { k: 'arriveYard', st: 'done', time: '4:41 PM', gps: 'TCG Yard · Santa Fe Springs' },
          { k: 'postInsp', st: 'flagged', time: '4:48 PM', pass: '23/24', newDef: 1, deficiencies: [['Outrigger pad worn', 'Minor']] },
          { k: 'compliance', st: 'done', perDiem: 'Not eligible', flags: ['Per-diem not eligible (< 50 mi)'] },
          { k: 'labor', st: 'done', net: '6.4 hrs', boomRange: '160–180' },
          { k: 'review', st: 'flagged', submitted: false, net: '6.4 hrs', sigs: false, note: 'Blocked — missing customer signature.' },
        ] },
      { id: 'TK-12935', name: 'Al Pacino', role: 'Operator', roleTone: '#d1218b', opened: false, idx: 11,
        summary: { step: 0, total: 15, current: 'Not opened', boomHrs: '0.0', net: '—', incidents: 0, deficiencies: 0, boomPaused: false, notOpened: true },
        timeline: this.ptAllPending() },
    ] },
    { date: '04/10/2026', status: 'Allocation Completed', tone: 'amber', tickets: [] },
    { date: '04/11/2026', status: 'Allocation Completed', tone: 'amber', tickets: [] },
    { date: '04/13/2026', status: 'Open', tone: 'slate', tickets: [] },
    { date: '04/14/2026', status: 'Open', tone: 'slate', tickets: [] },
    { date: '04/15/2026', status: 'Open', tone: 'slate', tickets: [] },
  ];
  ptOpenBadge(opened) {
    return opened ? this.auditBadge('green', 'Opened')
      : this.h('span', { style: { display: 'inline-flex', alignItems: 'center', borderRadius: '999px', border: '1px solid #fecdca', background: '#fef3f2', color: '#b42318', padding: '.1rem .5rem', fontSize: '10.5px', fontWeight: 700, letterSpacing: '.02em' } }, 'NOT OPENED');
  }
  ptStatusBadge(t) {
    const su = t.summary || {};
    if (su.incomplete) return this.h('span', { style: { display: 'inline-flex', alignItems: 'center', gap: '.25rem', borderRadius: '999px', border: '1px solid #fda29b', background: '#fef3f2', color: '#b42318', padding: '.1rem .5rem', fontSize: '10.5px', fontWeight: 700, letterSpacing: '.02em' } }, this.icon('alert', 10, '#b42318'), 'INCOMPLETE');
    if (su.flagged) return this.h('span', { style: { display: 'inline-flex', alignItems: 'center', gap: '.25rem', borderRadius: '999px', border: '1px solid #fedf89', background: '#fffaeb', color: '#b54708', padding: '.1rem .5rem', fontSize: '10.5px', fontWeight: 700, letterSpacing: '.02em' } }, this.icon('alert', 10, '#b54708'), 'FLAGGED');
    if (this.ptTicketStatus(t).statusCode === 'done') return this.h('span', { style: { display: 'inline-flex', alignItems: 'center', gap: '.25rem', borderRadius: '999px', border: '1px solid #abefc6', background: '#ecfdf3', color: '#067647', padding: '.1rem .5rem', fontSize: '10.5px', fontWeight: 700, letterSpacing: '.02em' } }, this.icon('checkCircle', 10, '#067647'), 'COMPLETED');
    return this.ptOpenBadge(t.opened);
  }
  ptSidebar() {
    const s = this.state;
    return this.h('div', { style: { width: '18rem', flexShrink: 0, display: 'flex', flexDirection: 'column', gap: '.6rem' } },
      this.h('div', { style: { fontSize: '12px', fontWeight: 600, color: 'var(--muted)' } }, 'Scheduled Date'),
      this.PT_SCHEDULES.map(sc => {
        const open = s.ptSchedule === sc.date;
        const hasT = sc.tickets.length > 0;
        return this.h('div', { key: sc.date, style: { display: 'flex', flexDirection: 'column', gap: '.35rem' } },
          this.h('button', { onClick: () => this.setState({ ptSchedule: open ? null : sc.date, ptTicket: null }), style: { display: 'flex', alignItems: 'center', gap: '.6rem', width: '100%', textAlign: 'left', height: '48px', padding: '0 .85rem', borderRadius: '12px', border: '1px solid ' + (open ? 'transparent' : 'var(--border)'), background: open ? 'var(--blue)' : '#fff', color: open ? '#fff' : 'var(--ink)', cursor: 'pointer' } },
            this.icon('calendar', 16, open ? '#fff' : '#94a3b8'),
            this.h('span', { style: { flex: 1, fontSize: '14px', fontWeight: 700 } }, sc.date),
            open ? this.h('span', { style: { fontSize: '11.5px', fontWeight: 700, color: '#fff', background: 'rgba(255,255,255,.2)', borderRadius: '999px', padding: '.15rem .6rem' } }, sc.status) : this.auditBadge(sc.tone, sc.status),
            this.h('span', { style: { display: 'flex', transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .15s' } }, this.icon('chevron', 15, open ? '#fff' : '#94a3b8'))),
          open ? (hasT ? sc.tickets.map(t => { const tSel = s.ptTicket === t.id; return this.h('button', { key: t.id, onClick: () => this.setState({ ptTicket: t.id }), style: { display: 'flex', alignItems: 'center', gap: '.5rem', width: '100%', textAlign: 'left', height: '40px', padding: '0 .85rem 0 1.1rem', borderRadius: '10px', border: '1px solid ' + (tSel ? '#b2ddff' : 'transparent'), background: tSel ? '#eff8ff' : 'transparent', cursor: 'pointer' } },
            this.icon('arrowRight', 13, tSel ? '#175cd3' : '#94a3b8'),
            this.h('span', { style: { flex: 1, fontSize: '13.5px', fontWeight: 700, fontFamily: 'ui-monospace,monospace', color: tSel ? '#175cd3' : 'var(--ink)' } }, t.id),
            this.ptStatusBadge(t)); }) : null) : null);
      }));
  }
  ptTicketCard(t, compact) {
    return this.h('div', { key: t.id, style: { flex: compact ? '1 1 260px' : 'none', borderRadius: '16px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 2px rgba(15,23,42,.04)', padding: '1.25rem' } },
      this.h('div', { style: { textAlign: 'center', fontSize: '20px', fontWeight: 800, letterSpacing: '-.01em', color: 'var(--ink)', marginBottom: '1rem' } }, t.id),
      this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.75rem', marginBottom: '1rem' } },
        this.avatar(t.name, t.idx, 44),
        this.h('div', { style: { flex: 1, minWidth: 0 } },
          this.h('div', { style: { fontSize: '15px', fontWeight: 700, color: 'var(--ink)' } }, t.name),
          this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', marginTop: '2px' } }, this.h('span', { style: { width: '4px', height: '13px', borderRadius: '2px', background: t.roleTone } }), this.h('span', { style: { fontSize: '13px', color: 'var(--text2)' } }, t.role))),
        this.ptStatusBadge(t)),
      this.h('button', { onClick: () => this.ping('Reminder email sent to ' + t.name), style: { display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '.5rem', width: '100%', height: '44px', borderRadius: '10px', border: 'none', background: 'var(--blue)', color: '#fff', fontSize: '13.5px', fontWeight: 700, cursor: 'pointer', marginBottom: '.6rem' } }, this.icon('send', 15, '#fff'), 'Send Reminder via Email'),
      this.h('button', { onClick: () => this.ping('Calling ' + t.name), style: { display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '.5rem', width: '100%', height: '44px', borderRadius: '10px', border: '1px solid var(--border)', background: '#fff', color: 'var(--text2)', fontSize: '13.5px', fontWeight: 700, cursor: 'pointer' } }, this.icon('phone', 15), 'Contact ' + t.role));
  }
  ptVis(code) {
    const m = {
      done: { c: '#067647', bg: '#ecfdf3', bd: '#abefc6', ic: 'check', label: 'Completed' },
      progress: { c: '#175cd3', bg: '#eff8ff', bd: '#b2ddff', ic: 'clock', label: 'In Progress' },
      pending: { c: '#94a3b8', bg: '#ffffff', bd: '#cbd5e1', ic: null, label: 'Not reached' },
      skipped: { c: '#94a3b8', bg: '#f1f5f9', bd: '#e2e8f0', ic: 'minus', label: 'Skipped / N/A' },
      flagged: { c: '#b54708', bg: '#fffaeb', bd: '#fedf89', ic: 'flag', label: 'Flagged' },
      incident: { c: '#b42318', bg: '#fef3f2', bd: '#fecdca', ic: 'alert', label: 'Incident' },
      incomplete: { c: '#b42318', bg: '#fef3f2', bd: '#fecdca', ic: 'alert', label: 'Incomplete' },
    };
    return m[code] || m.pending;
  }
  ptChip(code, label) {
    const v = this.ptVis(code);
    return this.h('span', { style: { display: 'inline-flex', alignItems: 'center', gap: '.3rem', borderRadius: '999px', border: '1px solid ' + v.bd, background: v.bg, color: v.c, padding: '.2rem .55rem', fontSize: '11px', fontWeight: 700, whiteSpace: 'nowrap' } },
      v.ic ? this.icon(v.ic, 11, v.c) : this.h('span', { style: { width: '6px', height: '6px', borderRadius: '999px', background: v.c } }), label || v.label);
  }
  ptDelta(varMin) {
    if (varMin == null || varMin === 0) return null;
    const late = varMin > 0;
    return this.h('span', { style: { display: 'inline-flex', alignItems: 'center', borderRadius: '6px', padding: '.15rem .45rem', fontSize: '11px', fontWeight: 700, whiteSpace: 'nowrap', color: late ? '#b54708' : '#067647', background: late ? '#fffaeb' : '#ecfdf3', border: '1px solid ' + (late ? '#fedf89' : '#abefc6') } },
      (late ? '+' : '\u2212') + Math.abs(varMin) + ' min ' + (late ? 'late' : 'early'));
  }
  ptMiniPill(text, tone) {
    const map = { grey: ['#64748b', '#f1f5f9', '#e2e8f0'], amber: ['#b54708', '#fffaeb', '#fedf89'], green: ['#067647', '#ecfdf3', '#abefc6'], red: ['#b42318', '#fef3f2', '#fecdca'], blue: ['#175cd3', '#eff8ff', '#b2ddff'] };
    const m = map[tone] || map.grey;
    return this.h('span', { style: { display: 'inline-flex', alignItems: 'center', borderRadius: '6px', padding: '.15rem .45rem', fontSize: '11px', fontWeight: 700, color: m[0], background: m[1], border: '1px solid ' + m[2], whiteSpace: 'nowrap' } }, text);
  }
  ptSubHits(st) {
    const out = [];
    if (st.k === 'arrivedJob' && st.varMin) out.push(this.ptDelta(st.varMin));
    if (st.k === 'endWork' && st.varMin) out.push(this.ptDelta(st.varMin));
    if (st.k === 'endWork' && st.overdue) out.push(this.ptMiniPill('Overdue', 'amber'));
    if (st.k === 'arriveYard' && st.overdue) out.push(this.ptMiniPill('Overdue', 'red'));
    if (st.k === 'endWork' && st.boomHrs) out.push(this.ptMiniPill(st.boomHrs + ' boom hrs', 'blue'));
    if ((st.k === 'preTrip' || st.k === 'postInsp') && st.defCount) out.push(this.ptMiniPill(st.defCount + ' deficiency' + (st.defCount === 1 ? '' : 's'), 'amber'));
    if (st.k === 'postInsp' && st.newDef) out.push(this.ptMiniPill(st.newDef + ' new deficiency', 'amber'));
    if (st.k === 'startWork' && st.breakdown && !st.breakdown.ended) out.push(this.ptMiniPill('Boom paused', 'amber'));
    if (st.k === 'startWork' && st.incidentReported) out.push(this.ptMiniPill('Incident', 'red'));
    if (st.k === 'incident') out.push(this.ptMiniPill(st.severity, 'red'));
    if (st.k === 'custSig' && st.refused) out.push(this.ptMiniPill('Refused', 'amber'));
    if (st.k === 'review' && st.submitted === false) out.push(this.ptMiniPill('Blocked', 'amber'));
    if (st.k === 'labor' && st.net) out.push(this.ptMiniPill(st.net + ' net', 'blue'));
    return out.filter(Boolean);
  }
  ptKV(label, val, color) {
    return this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.15rem' } },
      this.h('span', { style: { fontSize: '10.5px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '.04em', color: 'var(--muted)' } }, label),
      this.h('span', { style: { fontSize: '13.5px', fontWeight: 700, color: color || 'var(--ink)' } }, val));
  }
  ptGrid(pairs) {
    return this.h('div', { style: { display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(120px,1fr))', gap: '.85rem 1.25rem' } }, pairs.map((p, i) => this.ptKV(p[0], p[1], p[2])));
  }
  ptCkItems(items) {
    return this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.4rem' } }, items.map((it, i) => {
      const pass = it[1] === 'pass';
      return this.h('span', { key: i, style: { display: 'inline-flex', alignItems: 'center', gap: '.3rem', borderRadius: '8px', padding: '.25rem .5rem', fontSize: '12px', fontWeight: 600, color: pass ? '#475467' : '#b42318', background: pass ? '#f8fafc' : '#fef3f2', border: '1px solid ' + (pass ? '#e2e8f0' : '#fecdca') } },
        this.icon(pass ? 'check' : 'x', 12, pass ? '#12b76a' : '#f04438'), it[0]); }));
  }
  ptDefList(defs) {
    return this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.4rem', borderRadius: '10px', border: '1px solid #fedf89', background: '#fffdf7', padding: '.75rem' } },
      this.h('div', { style: { fontSize: '11px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '.04em', color: '#b54708' } }, 'Deficiencies'),
      defs.map((d, i) => this.h('div', { key: i, style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '.75rem', fontSize: '13px' } },
        this.h('span', { style: { color: 'var(--ink)', fontWeight: 600 } }, d[0]), this.ptMiniPill(d[1], 'amber'))));
  }
  ptSubSection(iconName, title, iconColor, children) {
    return this.h('div', { style: { borderRadius: '12px', border: '1px solid var(--border)', background: '#fbfcfe', padding: '.85rem 1rem' } },
      this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', marginBottom: '.7rem' } },
        this.icon(iconName, 15, iconColor || '#64748b'), this.h('span', { style: { fontSize: '12.5px', fontWeight: 800, letterSpacing: '.01em', color: 'var(--ink)' } }, title)),
      children);
  }
  ptGpsRow(loc, label) {
    return this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', borderRadius: '10px', border: '1px solid #abefc6', background: '#f6fef9', padding: '.55rem .75rem' } },
      this.h('span', { style: { width: '26px', height: '26px', flexShrink: 0, borderRadius: '8px', background: '#eff8ff', color: '#175cd3', display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon('mapPin', 14, '#175cd3')),
      this.h('div', { style: { flex: 1, minWidth: 0 } }, this.h('div', { style: { fontSize: '12.5px', fontWeight: 700, color: '#067647' } }, label || 'GPS verified'), this.h('div', { style: { fontSize: '12px', color: 'var(--text3)' } }, loc)),
      this.ptMiniPill('Verified', 'green'));
  }
  ptSigBox(signedBy) {
    return this.h('div', { style: { display: 'inline-flex', flexDirection: 'column', gap: '.4rem' } },
      this.h('div', { style: { width: '170px', height: '58px', borderRadius: '10px', border: '1px solid var(--border)', background: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center' } },
        this.h('svg', { width: 150, height: 44, viewBox: '0 0 150 44', fill: 'none' }, this.h('path', { d: 'M6 30c8-14 13 7 19-1s5-17 11-11-1 21 7 19 9-23 17-15 4 17 12 11 11-19 17-13 8 8 14 4', stroke: '#0f172a', strokeWidth: 2, strokeLinecap: 'round', strokeLinejoin: 'round' }))),
      this.h('span', { style: { fontSize: '12px', color: 'var(--text3)' } }, 'Signed by ', this.h('strong', { style: { color: 'var(--text2)' } }, signedBy)));
  }
  ptPhotoTile(label) {
    return this.h('div', { style: { width: '84px', display: 'flex', flexDirection: 'column', gap: '.3rem', alignItems: 'center' } },
      this.h('div', { style: { width: '84px', height: '64px', borderRadius: '10px', border: '1px dashed #cbd5e1', background: '#f8fafc', display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon('camera', 20, '#94a3b8')),
      this.h('span', { style: { fontSize: '10.5px', color: 'var(--text3)' } }, label));
  }
  // ── Completed-ticket PDF report ──────────────────────────────
  ptReportOpen(id) {
    this.setState({ ptReport: id });
    setTimeout(() => { try { window.print(); } catch (e) {} }, 450);
  }
  rpSection(title, kids, note) {
    return this.h('div', { key: title, className: 'tcg-pbreak', style: { marginTop: '1.15rem' } },
      this.h('div', { style: { display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: '.75rem', borderBottom: '1.5px solid #0f2851', paddingBottom: '.3rem', marginBottom: '.6rem' } },
        this.h('span', { style: { fontSize: '11px', fontWeight: 800, letterSpacing: '.09em', textTransform: 'uppercase', color: '#0f2851' } }, title),
        note ? this.h('span', { style: { fontSize: '10px', fontWeight: 700, color: '#64748b' } }, note) : null),
      kids);
  }
  rpKV(pairs) {
    return this.h('div', { style: { display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(150px,1fr))', gap: '.4rem 1.1rem' } },
      pairs.filter(Boolean).map((p, i) => this.h('div', { key: i, style: { display: 'flex', flexDirection: 'column', borderBottom: '1px dotted #e2e8f0', padding: '.2rem 0' } },
        this.h('span', { style: { fontSize: '8.5px', fontWeight: 800, letterSpacing: '.06em', textTransform: 'uppercase', color: '#94a3b8' } }, p[0]),
        this.h('span', { style: { fontSize: '10.5px', fontWeight: 600, color: p[2] || '#101828', lineHeight: 1.35 } }, p[1] == null || p[1] === '' ? '\u2014' : String(p[1])))));
  }
  rpRow(cells, head) {
    return this.h('div', { style: { display: 'flex', gap: '.5rem', padding: '.28rem .45rem', borderBottom: '1px solid ' + (head ? '#cbd5e1' : '#f1f5f9'), background: head ? '#f8fafc' : 'transparent' } },
      cells.map((c, i) => this.h('span', { key: i, style: { flex: i === 0 ? '0 0 22px' : (i === 1 ? '1 1 auto' : '0 0 88px'), fontSize: head ? '8.5px' : '10px', fontWeight: head ? 800 : (i === 2 ? 700 : 500), letterSpacing: head ? '.06em' : 0, textTransform: head ? 'uppercase' : 'none', color: head ? '#64748b' : (i === 2 ? (c === 'Deficiency' || c === 'Issue' || c === 'Fail' || c === 'No' ? '#b42318' : c === 'Not answered' ? '#94a3b8' : '#067647') : '#101828'), lineHeight: 1.35 } }, c)));
  }
  rpChecklist(t, def, arr) {
    const defects = this.PT_CK_DEFECTS[t.id] || {};
    if (arr == null) return this.h('div', { style: { fontSize: '10px', fontStyle: 'italic', color: '#94a3b8', padding: '.25rem 0' } }, 'Not started \u2014 the step that captures this checklist was not reached.');
    const blocks = [];
    if (def.assets) {
      def.assets.forEach(a => {
        const av = arr[a.key];
        blocks.push(this.h('div', { key: a.key, className: 'tcg-pbreak', style: { marginBottom: '.5rem' } },
          this.h('div', { style: { fontSize: '10px', fontWeight: 800, color: '#0f2851', margin: '.35rem 0 .15rem' } }, a.name + ' \u00b7 ' + a.code),
          this.rpRow(['#', 'Item', 'Result'], true),
          a.items.map((it, i) => {
            const v = av ? av[i] : -1;
            const lbl = v >= 0 ? def.colOpts[v] : 'Not answered';
            const dk = def.key + ':' + a.key + ':' + i;
            const d = defects[dk];
            return this.h('div', { key: i },
              this.rpRow([String(i + 1), it, lbl]),
              d ? this.h('div', { style: { fontSize: '9.5px', color: '#b42318', padding: '.15rem .45rem .3rem 27px', lineHeight: 1.4 } }, 'Deficiency \u00b7 ' + d.priority + ' \u00b7 ' + d.ts + ' \u00b7 GPS ' + d.gps + (d.photo ? ' \u00b7 photo attached' : '') + ' \u2014 ' + d.desc) : null);
          })));
      });
    } else {
      blocks.push(this.h('div', { key: 'q' }, this.rpRow(['#', 'Question', 'Answer'], true),
        def.questions.map((q, i) => this.rpRow([String(i + 1), q.q, arr[i] >= 0 ? q.opts[arr[i]] : 'Not answered']))));
    }
    return this.h('div', {}, blocks);
  }
  ptTicketReport(t) {
    const su = t.summary || {};
    const stt = this.ptTicketStatus(t);
    const ck = this.ptCkRollup(t);
    const ans = this.ptCkAnswers(t);
    const info = this.PT_TICKET_INFO[t.id] || {};
    const defects = this.PT_CK_DEFECTS[t.id] || {};
    const doneCount = t.timeline.filter(x => x.st === 'done').length;
    const banner = stt.statusCode === 'done'
      ? { c: '#067647', bg: '#ecfdf3', bd: '#abefc6', txt: 'COMPLETED \u2014 all 15 steps and all 4 checklists captured' }
      : { c: '#b54708', bg: '#fffaeb', bd: '#fedf89', txt: stt.statusLabel.toUpperCase() + ' \u2014 ' + doneCount + ' of ' + t.timeline.length + ' steps, ' + ck.done + ' of ' + ck.total + ' checklists' };
    const doc = this.h('div', { id: 'tcg-ticket-report', style: { width: '7.5in', maxHeight: '80vh', overflowY: 'auto', background: '#fff', borderRadius: '10px', padding: '.6in', boxShadow: '0 24px 60px rgba(8,20,45,.4)', color: '#101828' } },
      this.h('div', { style: { display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: '1rem', borderBottom: '3px solid #0f2851', paddingBottom: '.5rem' } },
        this.h('div', {},
          this.h('div', { style: { fontSize: '17px', fontWeight: 800, letterSpacing: '-.01em', color: '#0f2851' } }, 'The Crane Guys'),
          this.h('div', { style: { fontSize: '9.5px', fontWeight: 700, letterSpacing: '.09em', textTransform: 'uppercase', color: '#64748b', marginTop: '2px' } }, 'Field Ticket Completion Report')),
        this.h('div', { style: { textAlign: 'right' } },
          this.h('div', { style: { fontSize: '15px', fontWeight: 800, fontFamily: 'ui-monospace,monospace', color: '#0f2851' } }, t.id),
          this.h('div', { style: { fontSize: '9.5px', color: '#64748b', marginTop: '2px' } }, info.date || 'Thu, Apr 9, 2026'))),
      this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', border: '1px solid ' + banner.bd, background: banner.bg, borderRadius: '7px', padding: '.35rem .55rem', margin: '.55rem 0 .2rem' } },
        this.h('span', { style: { fontSize: '10px', fontWeight: 800, letterSpacing: '.04em', color: banner.c } }, banner.txt)),
      this.rpSection('Ticket & Job Details', this.rpKV([
        ['Ticket No', info.no || t.id], ['Quote', info.quote], ['Customer', info.customer], ['Job Site', info.jobSite],
        ['Shift Date', info.date], ['Salesperson', info.salesperson], ['Equipment', info.equipment], ['Customer Phone', info.customerPhone],
        ['Site Contact', info.contact], ['Contact Phone', info.contactPhone], ['Nearest Hospital', info.hospital], ['Hospital Phone', info.hospitalPhone]])),
      info.work ? this.rpSection('Scope of Work', this.h('div', { style: { fontSize: '10.5px', lineHeight: 1.5, color: '#344054' } }, info.work)) : null,
      this.rpSection('Crew & Shift Summary', this.rpKV([
        ['Assigned To', t.name + ' \u00b7 ' + t.role], ['Ticket Status', stt.statusLabel], ['Steps Completed', doneCount + ' of ' + t.timeline.length],
        ['Progress', stt.pct + '%'], ['Current / Last Step', su.current], ['Boom Hours', su.boomHrs ? su.boomHrs + ' h' : '\u2014'],
        ['Net Payable', su.net], ['Incidents', String(su.incidents || 0), su.incidents ? '#b42318' : null],
        ['Deficiencies', String(su.deficiencies || 0), su.deficiencies ? '#b54708' : null], ['Checklists', ck.done + ' of ' + ck.total + ' complete']])),
      this.rpSection('Step-by-Step Activity Log', this.h('div', {}, t.timeline.map((st, i) => {
        const meta = this.PT_STEP_META[st.k] || [st.k];
        const v = this.ptVis(st.st);
        return this.h('div', { key: i, className: 'tcg-pbreak', style: { borderLeft: '2px solid ' + (st.st === 'pending' ? '#e2e8f0' : v.c), paddingLeft: '.5rem', margin: '0 0 .5rem' } },
          this.h('div', { style: { display: 'flex', alignItems: 'baseline', gap: '.4rem', flexWrap: 'wrap' } },
            this.h('span', { style: { fontSize: '9px', fontWeight: 800, color: '#94a3b8' } }, 'STEP ' + (i + 1)),
            this.h('span', { style: { fontSize: '11px', fontWeight: 800, color: '#101828' } }, meta[0]),
            this.h('span', { style: { fontSize: '9px', fontWeight: 800, letterSpacing: '.05em', textTransform: 'uppercase', color: st.st === 'pending' ? '#94a3b8' : v.c } }, st.st === 'pending' ? 'Not reached' : (v.label || st.st)),
            st.time ? this.h('span', { style: { fontSize: '9.5px', fontWeight: 700, color: '#64748b', marginLeft: 'auto' } }, st.time) : null),
          this.h('div', { style: { fontSize: '10px', color: '#344054', marginTop: '.15rem' } }, this.ptStepDetail(t, st)));
      })), doneCount + ' of ' + t.timeline.length + ' steps recorded'),
      this.rpSection('Checklists Captured In-Flow', this.h('div', {}, this.PT_CK_DEFS.map(def => {
        const stats = this.ptCkStats(def, ans[def.key]);
        const complete = stats.started && stats.answered === stats.total;
        return this.h('div', { key: def.key, className: 'tcg-pbreak', style: { marginBottom: '.7rem' } },
          this.h('div', { style: { display: 'flex', alignItems: 'baseline', gap: '.5rem', background: '#f8fafc', border: '1px solid #e2e8f0', borderRadius: '6px', padding: '.3rem .5rem' } },
            this.h('span', { style: { fontSize: '10.5px', fontWeight: 800, color: '#0f2851' } }, def.name),
            this.h('span', { style: { fontSize: '9.5px', fontWeight: 700, color: '#64748b' } }, stats.answered + ' / ' + stats.total + ' answered'),
            this.h('span', { style: { marginLeft: 'auto', fontSize: '9px', fontWeight: 800, letterSpacing: '.05em', textTransform: 'uppercase', color: complete ? '#067647' : '#b54708' } }, complete ? 'Complete' : stats.started ? 'Partial' : 'Not started')),
          this.rpChecklist(t, def, ans[def.key]));
      })), ck.done + ' of ' + ck.total + ' complete'),
      Object.keys(defects).length ? this.rpSection('Deficiencies Logged', this.h('div', {}, Object.entries(defects).map(([k, d]) => this.h('div', { key: k, className: 'tcg-pbreak', style: { borderLeft: '2px solid #b42318', paddingLeft: '.5rem', marginBottom: '.4rem' } },
        this.h('div', { style: { fontSize: '10.5px', fontWeight: 800, color: '#912018' } }, k.replace(/:/g, ' \u00b7 ') + ' \u2014 ' + d.priority),
        this.h('div', { style: { fontSize: '10px', color: '#344054', lineHeight: 1.4 } }, d.desc),
        this.h('div', { style: { fontSize: '9px', color: '#64748b' } }, d.ts + ' \u00b7 GPS ' + d.gps + (d.photo ? ' \u00b7 photo attached' : ''))))), String(Object.keys(defects).length) + ' logged') : null,
      info.comments && info.comments.length ? this.rpSection('Comments', this.h('div', {}, info.comments.map((c, i) => this.h('div', { key: i, style: { fontSize: '10px', color: '#344054', borderBottom: '1px dotted #e2e8f0', padding: '.22rem 0' } }, this.h('strong', {}, c.name), ' \u00b7 ' + c.time + ' \u2014 ' + c.text)))) : null,
      info.files && info.files.length ? this.rpSection('Attachments', this.h('div', { style: { fontSize: '10px', color: '#344054' } }, info.files.join(' \u00b7 '))) : null,
      this.h('div', { style: { display: 'flex', justifyContent: 'space-between', gap: '1rem', marginTop: '1.3rem', paddingTop: '.4rem', borderTop: '1px solid #cbd5e1', fontSize: '8.5px', color: '#94a3b8' } },
        this.h('span', {}, 'Generated from TCG Platform \u00b7 Daily Progress Tracking'),
        this.h('span', {}, 'Ticket ' + t.id + ' \u00b7 ' + (info.date || '') + ' \u00b7 Page 1')));
    return this.h('div', { onClick: () => this.setState({ ptReport: null }), style: { position: 'fixed', inset: 0, zIndex: 90, background: 'rgba(8,20,45,.55)', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '1.5rem' } },
      this.h('div', { onClick: e => e.stopPropagation(), style: { display: 'flex', flexDirection: 'column', gap: '.6rem', alignItems: 'center' } },
        this.h('div', { className: 'tcg-noprint', style: { display: 'flex', alignItems: 'center', gap: '.5rem', width: '7.5in', maxWidth: '100%' } },
          this.h('span', { style: { fontSize: '13px', fontWeight: 700, color: '#fff' } }, 'Ticket report \u00b7 ' + t.id),
          this.h('div', { style: { flex: 1 } }),
          this.h('button', { onClick: () => window.print(), style: { display: 'inline-flex', alignItems: 'center', gap: '.4rem', height: '36px', padding: '0 .9rem', borderRadius: '9px', border: 'none', background: 'var(--blue)', color: '#fff', fontSize: '13px', fontWeight: 700, cursor: 'pointer' } }, this.icon('download', 15, '#fff'), 'Save as PDF'),
          this.h('button', { onClick: () => this.setState({ ptReport: null }), style: { height: '36px', padding: '0 .9rem', borderRadius: '9px', border: '1px solid rgba(255,255,255,.3)', background: 'transparent', color: '#fff', fontSize: '13px', fontWeight: 700, cursor: 'pointer' } }, 'Close')),
        doc));
  }
  ptStepDetail(t, st) {
    const wrap = kids => this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.85rem', marginTop: '.85rem' } }, kids);
    if (st.st === 'pending') return wrap([this.h('div', { style: { fontSize: '13px', color: 'var(--text3)', fontStyle: 'italic' } }, 'Not reached this shift.')]);
    if (st.k === 'openTicket') {
      return wrap([this.ptGrid([['Opened', st.time || '\u2014'], ['Device', st.device || 'TCG Field App'], ['Acknowledged', 'Yes', '#067647']])]);
    }
    if (st.k === 'leftYard' || st.k === 'leftJob' || st.k === 'arriveYard') {
      const pairs = [['Time', st.time || '\u2014'], ['Est.', st.est || '\u2014']].concat(st.meta || []);
      return wrap([this.ptGrid(pairs),
        st.gps ? this.ptGpsRow(st.gps, st.gpsLabel || 'GPS verified') : null,
        st.overdue ? this.h('div', { style: { display: 'flex', alignItems: 'flex-start', gap: '.5rem', borderRadius: '10px', border: '1px solid #fecdca', background: '#fffbfa', padding: '.65rem .85rem', fontSize: '12.5px', fontWeight: 600, color: '#912018' } }, this.icon('alert', 14, '#b42318'), st.note) : null].filter(Boolean));
    }
    if (st.k === 'driving') {
      return wrap([this.ptGrid([['Departed', st.departed || '\u2014'], ['Drive time', st.driveTime || '\u2014', '#175cd3'], ['ETA', st.eta || '\u2014'], ['Distance', st.distance || '\u2014']]),
        st.dest ? this.h('div', { style: { display: 'flex', alignItems: 'flex-start', gap: '.5rem', fontSize: '13px', color: 'var(--text2)' } }, this.icon('mapPin', 14, '#94a3b8'), st.dest) : null,
        st.geofence ? this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', borderRadius: '10px', border: '1px solid #b2ddff', background: '#eff8ff', padding: '.55rem .75rem', fontSize: '12.5px', fontWeight: 600, color: '#175cd3' } }, this.icon('mapPin', 13, '#175cd3'), 'Geofence detected \u2014 within 500m of the job site') : null].filter(Boolean));
    }
    if (st.k === 'arrivedJob') {
      return wrap([this.ptGrid([['Est. arrival', st.est || '\u2014'], ['Actual arrival', st.time, st.varMin > 0 ? '#b54708' : '#067647'], ['Variance', (st.varMin > 0 ? '+' : '') + (st.varMin || 0) + ' min']]),
        st.gps ? this.ptGpsRow(st.gps, st.gpsLabel || 'GPS verified') : null,
        st.note ? this.h('div', { style: { fontSize: '13px', color: 'var(--text2)' } }, st.note) : null].filter(Boolean));
    }
    if (st.k === 'custFirstSig') {
      if (st.refused) return this.h('div', { style: { marginTop: '.85rem', display: 'flex', alignItems: 'flex-start', gap: '.6rem', borderRadius: '12px', border: '1px solid #fecdca', background: '#fffbfa', padding: '.85rem 1rem' } },
        this.icon('alert', 16, '#b42318'), this.h('div', {}, this.h('div', { style: { fontSize: '13px', fontWeight: 700, color: '#912018' } }, 'First signature not captured'), this.h('div', { style: { fontSize: '12.5px', color: 'var(--text2)', marginTop: '.2rem' } }, st.note)));
      return wrap([this.ptGrid([['Signer', st.signedBy || '\u2014'], ['Captured', st.time || '\u2014']]),
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', fontSize: '12.5px', fontWeight: 700, color: '#067647' } }, this.icon('check', 13, '#12b76a'), 'Terms & Conditions of Service accepted'),
        this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'flex-end', gap: '1rem' } }, this.ptSigBox(st.signedBy), st.identity ? this.ptPhotoTile('Identity photo') : null)]);
    }
    if (st.k === 'preTrip' || st.k === 'afterArr') {
      const ck = st.k === 'preTrip' ? this.ptStepCk(t, 'preTrip') : (st.items ? this.ptCkItems(st.items) : null);
      return wrap([st.time ? this.ptGrid([['Completed', st.time], ['Result', (st.result || '').toUpperCase(), st.result === 'fail' ? '#b42318' : '#067647']]) : null,
        ck,
        st.deficiencies && st.deficiencies.length ? this.ptDefList(st.deficiencies) : null].filter(Boolean));
    }
    if (st.k === 'jsa') {
      return wrap([this.ptGrid([['Completed', st.time || '\u2014'], ['Issues', String(st.issues || 0), st.issues ? '#b54708' : '#067647']]),
        this.ptStepCk(t, 'jsa')].filter(Boolean));
    }
    if (st.k === 'postInsp') {
      return wrap([this.ptGrid([['Completed', st.time || '\u2014'], ['Items passed', st.pass || '\u2014'], ['New deficiencies', String(st.newDef || 0), st.newDef ? '#b54708' : '#067647']]),
        this.ptStepCk(t, 'postTrip'),
        st.deficiencies && st.deficiencies.length ? this.ptDefList(st.deficiencies) : null].filter(Boolean));
    }
    if (st.k === 'compliance') {
      return wrap([this.ptGrid([['Per-diem', st.perDiem || '\u2014']]),
        this.ptStepCk(t, 'compliance'),
        st.flags && st.flags.length ? this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.4rem' } }, st.flags.map((f, i) => this.ptMiniPill(f, 'amber'))) : this.ptMiniPill('No compliance flags', 'green')].filter(Boolean));
    }
    if (st.k === 'startWork') {
      if (st.incidentReported) {
        return wrap([this.h('div', { style: { borderRadius: '12px', border: '1.5px solid #fecdca', background: '#fffbfa', overflow: 'hidden' } },
          this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', padding: '.7rem 1rem', background: '#fef3f2', borderBottom: '1px solid #fecdca' } },
            this.icon('alert', 16, '#b42318'), this.h('span', { style: { fontSize: '13px', fontWeight: 800, color: '#912018' } }, 'Incident Reported')),
          this.h('div', { style: { padding: '.85rem 1rem', display: 'flex', flexDirection: 'column', gap: '.5rem' } },
            this.h('div', { style: { fontSize: '13.5px', fontWeight: 700, color: 'var(--ink)' } }, '“' + st.incidentMessage + '”'),
            this.h('div', { style: { fontSize: '12.5px', color: 'var(--text2)' } }, 'Reported by ', this.h('strong', {}, st.incidentReportedBy), ' via ', st.incidentVia)))]);
      }
      const bd = st.breakdown;
      const lunchCards = this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.5rem' } }, (st.lunches || []).map((l, i) => {
        if (l.locked) return this.h('div', { key: i, style: { flex: '1 1 150px', borderRadius: '9px', border: '1px dashed #cbd5e1', background: '#f8fafc', padding: '.6rem .75rem', display: 'flex', flexDirection: 'column', gap: '.2rem' } },
          this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.35rem', fontSize: '12.5px', fontWeight: 700, color: '#94a3b8' } }, this.icon('lock', 12, '#94a3b8'), 'Lunch Break ' + l.n),
          this.h('span', { style: { fontSize: '11.5px', color: 'var(--text3)' } }, l.note));
        if (l.skipped) return this.h('div', { key: i, style: { flex: '1 1 150px', borderRadius: '9px', border: '1px solid #e2e8f0', background: '#f1f5f9', padding: '.6rem .75rem', display: 'flex', flexDirection: 'column', gap: '.2rem' } },
          this.h('div', { style: { fontSize: '12.5px', fontWeight: 700, color: '#64748b' } }, 'Lunch Break ' + l.n), this.ptMiniPill('Skipped', 'grey'));
        return this.h('div', { key: i, style: { flex: '1 1 150px', borderRadius: '9px', border: '1px solid #abefc6', background: '#f6fef9', padding: '.6rem .75rem', display: 'flex', flexDirection: 'column', gap: '.25rem' } },
          this.h('div', { style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between' } }, this.h('span', { style: { fontSize: '12.5px', fontWeight: 700, color: 'var(--ink)' } }, 'Lunch Break ' + l.n), this.ptMiniPill(l.dur, 'green')),
          this.h('span', { style: { fontSize: '12px', color: 'var(--text2)' } }, l.start + ' \u2013 ' + l.end));
      }));
      let bdBody;
      if (!bd) bdBody = this.h('div', { style: { fontSize: '12.5px', color: 'var(--text3)', fontStyle: 'italic' } }, 'No break-down recorded \u2014 boom ran continuously.');
      else if (!bd.ended) bdBody = this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.5rem' } },
        this.ptGrid([['Started', bd.start], ['Ended', 'Not ended', '#b54708'], ['Paused', 'Ongoing', '#b54708']]),
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', fontSize: '12.5px', fontWeight: 700, color: '#b54708' } }, this.icon('pause', 13, '#b54708'), 'Started ' + bd.start + ' \u00B7 not ended \u2014 boom time still paused'),
        bd.cause ? this.h('div', { style: { fontSize: '12.5px', color: 'var(--text2)' } }, bd.cause) : null);
      else bdBody = this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.5rem' } },
        this.ptGrid([['Started', bd.start], ['Completed', bd.end], ['Paused', bd.pausedMin + ' min']]),
        bd.cause ? this.h('div', { style: { fontSize: '12.5px', color: 'var(--text2)' } }, bd.cause) : null);
      return wrap([this.ptGrid([['Boom time start', st.boomStart, '#175cd3']]),
        this.ptSubSection('coffee', 'Lunch Breaks', '#b54708', lunchCards),
        this.ptSubSection('pause', 'Break-down', bd && !bd.ended ? '#b42318' : '#64748b', bdBody)]);
    }
    if (st.k === 'incident') {
      return this.h('div', { style: { marginTop: '.85rem', borderRadius: '12px', border: '1.5px solid #fecdca', background: '#fffbfa', overflow: 'hidden' } },
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', padding: '.7rem 1rem', background: '#fef3f2', borderBottom: '1px solid #fecdca' } },
          this.icon('alert', 16, '#b42318'), this.h('span', { style: { fontSize: '13px', fontWeight: 800, color: '#912018' } }, 'Mishap Report filed'), this.ptMiniPill(st.severity, 'red')),
        this.h('div', { style: { padding: '.9rem 1rem', display: 'flex', flexDirection: 'column', gap: '.85rem' } },
          this.ptGrid([['Type', st.type], ['Severity', st.severity, '#b42318'], ['Logged', st.time], ['OSHA ref', st.osha]]),
          this.h('div', { style: { fontSize: '13px', color: 'var(--text2)', lineHeight: 1.55 } }, st.desc),
          this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '1.25rem', justifyContent: 'space-between' } },
            this.ptGrid([['Client', st.client], ['Client signature', st.sigStatus, '#067647']]),
            this.h('div', { style: { display: 'flex', gap: '.6rem' } }, this.ptPhotoTile('Site photo'), this.ptPhotoTile('Damage')))));
    }
    if (st.k === 'endWork') {
      return wrap([this.ptGrid([['Boom time', (st.boomStart || '\u2014') + ' \u2192 ' + (st.boomEnd || '\u2014')], ['Est. end', st.est || '\u2014'], ['Elapsed', st.elapsed || '\u2014'], ['Paused (break-down)', (st.pausedMin || 0) + ' min'], ['Total boom hours', (st.boomHrs || '\u2014') + (st.boomHrs ? ' hrs' : ''), '#175cd3']]),
        st.boomHrs ? this.h('div', { style: { fontSize: '12px', color: 'var(--text3)', fontStyle: 'italic' } }, 'Total boom = elapsed \u2212 paused break-down time.') : null,
        st.overdue ? this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', fontSize: '12.5px', fontWeight: 700, color: '#b54708' } }, this.icon('alert', 13, '#b54708'), st.note) : null].filter(Boolean));
    }
    if (st.k === 'custSig') {
      if (st.refused) return this.h('div', { style: { marginTop: '.85rem', display: 'flex', alignItems: 'flex-start', gap: '.6rem', borderRadius: '12px', border: '1px solid #fecdca', background: '#fffbfa', padding: '.85rem 1rem' } },
        this.icon('alert', 16, '#b42318'), this.h('div', {}, this.h('div', { style: { fontSize: '13px', fontWeight: 700, color: '#912018' } }, 'Signature not captured'), this.h('div', { style: { fontSize: '12.5px', color: 'var(--text2)', marginTop: '.2rem' } }, st.note)));
      const confirms = st.confirms || ['No damages to job site', 'Work completed as described', 'No accidents or incidents occurred'];
      return wrap([this.ptGrid([['Signer', st.signedBy || '\u2014'], ['Captured', st.time || '\u2014']]),
        this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.4rem' } }, confirms.map((c, i) => this.h('div', { key: i, style: { display: 'flex', alignItems: 'center', gap: '.45rem', fontSize: '12.5px', fontWeight: 600, color: '#067647' } }, this.icon('check', 13, '#12b76a'), c))),
        this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'flex-end', gap: '1rem' } }, this.ptSigBox(st.signedBy), st.identity ? this.ptPhotoTile('Identity photo') : null)]);
    }
    if (st.k === 'labor') return wrap([this.ptGrid([['Net billable', st.net, '#175cd3'], ['Boom range', st.boomRange || '\u2014']])]);
    if (st.k === 'review') {
      const rows = [['Final submit', st.submitted ? 'Submitted' : 'Not submitted', st.submitted], ['Net billable total', st.net || '\u2014', true], ['All signatures collected', st.sigs ? 'Yes' : 'No', st.sigs]];
      return wrap([this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.5rem' } }, rows.map((r, i) => this.h('div', { key: i, style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '.75rem', fontSize: '13px' } },
        this.h('span', { style: { color: 'var(--text2)' } }, r[0]), this.h('span', { style: { display: 'inline-flex', alignItems: 'center', gap: '.3rem', fontWeight: 700, color: r[2] ? '#067647' : '#b54708' } }, this.icon(r[2] ? 'check' : 'x', 13, r[2] ? '#12b76a' : '#f79009'), r[1])))),
        st.note ? this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', fontSize: '12.5px', fontWeight: 700, color: '#b54708' } }, this.icon('alert', 13, '#b54708'), st.note) : null].filter(Boolean));
    }
    return wrap([this.h('div', { style: { fontSize: '13px', color: 'var(--text3)' } }, 'No details.')]);
  }
  ptStepRow(t, st, i, arr) {
    const meta = this.PT_STEP_META[st.k] || [st.k, 'clock'];
    const v = this.ptVis(st.st);
    const last = i === arr.length - 1;
    const key = t.id + ':' + i;
    const open = !!this.state.ptExpand[key];
    const pending = st.st === 'pending';
    const lineColor = st.st === 'done' ? '#abefc6' : (st.st === 'incident' || st.st === 'incomplete') ? '#fecdca' : '#e2e8f0';
    const node = this.h('div', { style: { display: 'flex', flexDirection: 'column', alignItems: 'center', alignSelf: 'stretch' } },
      this.h('span', { style: { width: '32px', height: '32px', flexShrink: 0, borderRadius: '999px', border: '2px solid ' + (pending ? '#cbd5e1' : v.c), background: pending ? '#fff' : v.bg, display: 'flex', alignItems: 'center', justifyContent: 'center', animation: st.st === 'progress' ? 'tcg-pulse 1.7s infinite' : 'none' } },
        pending ? this.h('span', { style: { width: '8px', height: '8px', borderRadius: '999px', border: '2px solid #cbd5e1' } }) : this.icon(meta[1], 15, v.c)),
      last ? null : this.h('span', { style: { flex: 1, width: '2px', minHeight: '18px', background: lineColor } }));
    const hits = this.ptSubHits(st);
    const header = this.h('button', { onClick: () => this.setState(s => ({ ptExpand: { ...s.ptExpand, [key]: !s.ptExpand[key] } })),
      style: { display: 'flex', alignItems: 'center', gap: '.75rem', width: '100%', textAlign: 'left', background: open ? '#fbfcfe' : '#fff', border: '1px solid ' + (open ? v.bd : 'var(--border)'), borderRadius: open ? '12px 12px 0 0' : '12px', padding: '.75rem 1rem', cursor: 'pointer' } },
      this.h('span', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', flex: 1, minWidth: 0, flexWrap: 'wrap' } },
        this.h('span', { style: { fontSize: '14.5px', fontWeight: 700, color: pending ? 'var(--text3)' : 'var(--ink)' } }, meta[0]),
        st.time && !pending ? this.h('span', { style: { fontSize: '12px', fontWeight: 600, color: 'var(--text3)' } }, st.time) : null,
        ...hits),
      this.ptChip(st.st),
      this.h('span', { style: { display: 'flex', flexShrink: 0, transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .15s' } }, this.icon('chevron', 16, '#94a3b8')));
    const panel = open ? this.h('div', { style: { border: '1px solid ' + v.bd, borderTop: 'none', borderRadius: '0 0 12px 12px', background: '#fff', padding: '0 1rem 1rem' } }, this.ptStepDetail(t, st)) : null;
    return this.h('div', { key: key, style: { display: 'flex', alignItems: 'stretch', gap: '1rem' } },
      node, this.h('div', { style: { flex: 1, minWidth: 0, paddingBottom: last ? 0 : '.85rem' } }, header, panel));
  }
  ptTicketStatus(t) {
    const su = t.summary || {};
    const counts = { done: 0, progress: 0, pending: 0, skipped: 0, flagged: 0, incident: 0, incomplete: 0 };
    t.timeline.forEach(st => { counts[st.st] = (counts[st.st] || 0) + 1; });
    let statusCode, statusLabel;
    if (su.notOpened) { statusCode = 'pending'; statusLabel = 'Not opened'; }
    else if (su.incomplete) { statusCode = 'incomplete'; statusLabel = 'Incomplete'; }
    else if (su.flagged) { statusCode = 'flagged'; statusLabel = 'Flagged'; }
    else if (su.blocked) { statusCode = 'flagged'; statusLabel = 'Review blocked'; }
    else if (counts.incident) { statusCode = 'incident'; statusLabel = 'Incident logged'; }
    else if (counts.progress) { statusCode = 'progress'; statusLabel = 'In progress'; }
    else if (counts.pending === 0) { statusCode = 'done'; statusLabel = 'Completed'; }
    else { statusCode = 'progress'; statusLabel = 'In progress'; }
    const ck = this.ptCkRollup(t);
    // Steps finished but checklists still open → not complete yet.
    if (statusCode === 'done' && !ck.allDone) { statusCode = 'progress'; statusLabel = 'Checklists pending'; }
    const pct = Math.round((su.step / (su.total || 15)) * 100);
    return { statusCode, statusLabel, counts, pct, ck };
  }
  ptTicketSummary(t) {
    const su = t.summary || {};
    const { statusCode, statusLabel, counts, pct } = this.ptTicketStatus(t);
    const sv = this.ptVis(statusCode);
    const kpis = [['pending', 'Not reached'], ['progress', 'In progress'], ['done', 'Completed'], ['skipped', 'Skipped / N/A'], ['flagged', 'Flagged'], ['incident', 'Incident'], ['incomplete', 'Incomplete']];
    const actionBtn = (icon, label, primary, cb) => this.h('button', { onClick: cb, style: { display: 'inline-flex', alignItems: 'center', gap: '.4rem', height: '38px', padding: '0 .95rem', borderRadius: '10px', border: primary ? 'none' : '1px solid var(--border)', background: primary ? 'var(--blue)' : '#fff', color: primary ? '#fff' : 'var(--text2)', fontSize: '13px', fontWeight: 700, cursor: 'pointer', whiteSpace: 'nowrap' } }, this.icon(icon, 15, primary ? '#fff' : '#64748b'), label);
    return this.h('div', { style: { borderRadius: '18px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 3px rgba(15,23,42,.06)', overflow: 'hidden', marginBottom: '1.5rem' } },
      this.h('div', { style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '1rem', flexWrap: 'wrap', padding: '1.15rem 1.4rem', borderBottom: '1px solid var(--border)', background: 'linear-gradient(180deg,#fbfcfe,#fff)' } },
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.65rem', flexWrap: 'wrap' } },
          this.h('span', { style: { fontSize: '11px', fontWeight: 700, letterSpacing: '.04em', color: 'var(--muted)', textTransform: 'uppercase' } }, 'Ticket Summary'),
          this.h('span', { style: { fontSize: '19px', fontWeight: 800, letterSpacing: '-.01em', color: 'var(--ink)', fontFamily: 'ui-monospace,monospace' } }, t.id),
          this.ptChip(statusCode, statusLabel)),
        this.h('button', { onClick: () => this.setState({ ptInfoOpen: t.id }), title: 'Ticket details', style: { width: '38px', height: '38px', flexShrink: 0, borderRadius: '10px', border: '1px solid var(--border)', background: '#fff', color: 'var(--text3)', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer' } }, this.icon('info', 17))),
      this.h('div', { style: { padding: '1.1rem 1.4rem 1.25rem' } },
        this.h('div', { style: { display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(116px,1fr))', gap: '.6rem' } }, kpis.map(k => {
          const v = this.ptVis(k[0]);
          const n = counts[k[0]] || 0;
          const active = n > 0;
          return this.h('div', { key: k[0], style: { position: 'relative', borderRadius: '13px', border: '1px solid ' + (active ? v.bd : '#eef2f7'), background: active ? v.bg : '#fbfcfe', padding: '.7rem .5rem .7rem .85rem', overflow: 'hidden' } },
            this.h('span', { style: { position: 'absolute', left: 0, top: 0, bottom: 0, width: '3px', background: active ? v.c : 'transparent' } }),
            this.h('div', { style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '.4rem' } },
              this.h('span', { style: { fontSize: '24px', fontWeight: 800, letterSpacing: '-.02em', lineHeight: 1, color: active ? v.c : '#cbd5e1' } }, n),
              this.h('span', { style: { width: '26px', height: '26px', flexShrink: 0, borderRadius: '8px', background: active ? '#fff' : 'transparent', display: 'flex', alignItems: 'center', justifyContent: 'center' } }, v.ic ? this.icon(v.ic, 14, active ? v.c : '#cbd5e1') : this.h('span', { style: { width: '9px', height: '9px', borderRadius: '999px', background: active ? v.c : '#cbd5e1' } }))),
            this.h('span', { style: { display: 'block', marginTop: '.35rem', fontSize: '11.5px', fontWeight: 700, color: active ? v.c : 'var(--text3)' } }, k[1]));
        }))));
  }
  PT_TICKET_INFO = {
    'TK-11722': { no: '#11722', quote: 'LEM-11722-A', customer: 'Devon Ridge General Contractors', date: 'Thu, Apr 9, 2026', salesperson: 'Dana Whitlock',
      equipment: 'Liebherr LTM 1300-6.3 · 550-ton', work: 'Set 3 rooftop HVAC units onto a 6-story structure. Tandem pick on unit 2. Customer rigging crew on site.',
      jobSite: '1847 Harbor Blvd, Long Beach, CA 90802', customerPhone: '(562) 555-0173', contact: 'Luis Ramirez', contactPhone: '(562) 555-0199',
      hospital: 'Long Beach Medical Center', hospitalAddr: '2801 Atlantic Ave, Long Beach, CA', hospitalPhone: '(562) 555-2000', files: ['activity log.png', 'lift plan v2.pdf'], comments: [{ name: 'Mike', text: 'jddsdc', time: '08:08 PM' }] },
    'TK-34098': { no: '#34098', quote: 'LEM-34098-A', customer: 'Harbor Point Builders', date: 'Thu, Apr 9, 2026', salesperson: 'Dana Whitlock',
      equipment: 'Grove GMK5250L · 300-ton', work: 'Steel erection support — set precast panels along east elevation. Two-crane day.',
      jobSite: '1847 Harbor Blvd, Long Beach, CA 90802', customerPhone: '(562) 555-0140', contact: 'M. Alvarez', contactPhone: '(562) 555-0155',
      hospital: 'Long Beach Medical Center', hospitalAddr: '2801 Atlantic Ave, Long Beach, CA', hospitalPhone: '(562) 555-2000', files: ['activity log.png'], comments: [{ name: 'Dana Whitlock', text: 'Confirmed tandem pick sequence with customer.', time: '09:14 AM' }] },
    'TK-55310': { no: '#55310', quote: 'LEM-55310-A', customer: 'Pier Front Developers', date: 'Thu, Apr 9, 2026', salesperson: 'Reed Callahan',
      equipment: 'Liebherr LTM 1160-5.1 · 200-ton', work: 'Offload and place generator skids on pier deck. Confined swing radius — spotter required.',
      jobSite: '900 Pier F Ave, Long Beach, CA 90802', customerPhone: '(562) 555-0120', contact: 'D. Cole', contactPhone: '(562) 555-0128',
      hospital: 'Long Beach Medical Center', hospitalAddr: '2801 Atlantic Ave, Long Beach, CA', hospitalPhone: '(562) 555-2000', files: ['site permit.pdf'], comments: [] },
    'TK-12935': { no: '#12935', quote: 'LEM-12935-A', customer: 'Summit Steel & Rigging', date: 'Thu, Apr 9, 2026', salesperson: 'Reed Callahan',
      equipment: 'Tadano ATF 220G-5 · 240-ton', work: 'Tilt-up wall panel setting, north bay. Sequence per erection plan sheet S-4.',
      jobSite: '1847 Harbor Blvd, Long Beach, CA 90802', customerPhone: '(562) 555-0181', contact: 'Not assigned', contactPhone: '\u2014',
      hospital: 'Long Beach Medical Center', hospitalAddr: '2801 Atlantic Ave, Long Beach, CA', hospitalPhone: '(562) 555-2000', files: [], comments: [] },
  };
  PT_CHAT_SEED = {
    default: [
      ['them', '08:12 AM', 'Pre-trip done, everything checks out. Heading out of the yard now.'],
      ['me', '08:14 AM', 'Copy that. Gate code at the site is 4471 — report to Mona at the trailer.'],
      ['them', '09:02 AM', 'On site, setting outriggers. Ground looks soft on the north pad, using extra cribbing.'],
    ],
  };
  ptChatPanel() {
    const name = this.state.ptChat; if (!name) { return null; }
    const t = this.state.ptTicket ? ((this.PT_SCHEDULES.find(x => x.date === this.state.ptSchedule) || { tickets: [] }).tickets.find(x => x.id === this.state.ptTicket) || {}) : {};
    const close = () => this.setState({ ptChat: null, ptChatDraft: '' });
    const log = (this.PT_CHAT_SEED.default).concat(this.state.ptChatLog[name] || []);
    const send = () => {
      const v = this.state.ptChatDraft.trim(); if (!v) { return; }
      const prev = this.state.ptChatLog[name] || [];
      const now = new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' });
      this.setState({ ptChatLog: Object.assign({}, this.state.ptChatLog, { [name]: prev.concat([['me', now, v]]) }), ptChatDraft: '' });
    };
    return this.h('div', { onClick: close, style: { position: 'fixed', inset: 0, zIndex: 94, background: 'rgba(15,23,42,.5)', display: 'flex', justifyContent: 'flex-end' } },
      this.h('div', { onClick: e => e.stopPropagation(), style: { width: '100%', maxWidth: '400px', height: '100%', background: '#fff', display: 'flex', flexDirection: 'column', boxShadow: '-16px 0 40px rgba(15,23,42,.22)' } },
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.7rem', padding: '1rem 1.1rem', borderBottom: '1px solid var(--border)' } },
          this.avatar(name, 0, 36),
          this.h('div', { style: { flex: 1, minWidth: 0 } },
            this.h('div', { style: { fontSize: '14px', fontWeight: 700, color: 'var(--ink)' } }, name),
            this.h('div', { style: { fontSize: '11.5px', color: 'var(--text3)' } }, t.id ? 'Ticket ' + t.id : 'Field crew')),
          this.h('button', { onClick: close, 'aria-label': 'Close chat', style: { width: '30px', height: '30px', borderRadius: '8px', border: '1px solid var(--border)', background: '#fff', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon('close', 15, 'var(--text2)'))),
        this.h('div', { style: { flex: 1, overflowY: 'auto', padding: '1rem 1.1rem', display: 'flex', flexDirection: 'column', gap: '.6rem', background: '#fbfcfe' } },
          log.map((m, i) => this.h('div', { key: i, style: { display: 'flex', flexDirection: 'column', alignItems: m[0] === 'me' ? 'flex-end' : 'flex-start', gap: '2px' } },
            this.h('div', { style: { maxWidth: '82%', borderRadius: '12px', padding: '.55rem .7rem', fontSize: '13px', lineHeight: 1.5, background: m[0] === 'me' ? 'var(--blue)' : '#fff', color: m[0] === 'me' ? '#fff' : 'var(--ink)', border: m[0] === 'me' ? 'none' : '1px solid var(--border)' } }, m[2]),
            this.h('span', { style: { fontSize: '10.5px', color: 'var(--text3)' } }, m[1])))),
        this.h('div', { style: { padding: '.75rem 1.1rem 1rem', borderTop: '1px solid var(--border)', display: 'flex', gap: '.5rem' } },
          this.h('input', { value: this.state.ptChatDraft, onChange: e => this.setState({ ptChatDraft: e.target.value }), onKeyDown: e => { if (e.key === 'Enter') { send(); } }, placeholder: 'Message ' + name.split(' ')[0] + '\u2026', style: { flex: 1, height: '40px', padding: '0 .7rem', borderRadius: '10px', border: '1px solid var(--border)', background: '#fff', fontSize: '13px', color: 'var(--ink)', fontFamily: 'inherit' } }),
          this.h('button', { onClick: send, 'aria-label': 'Send', style: { width: '40px', height: '40px', flexShrink: 0, borderRadius: '10px', border: 'none', background: 'var(--blue)', cursor: 'pointer', display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon('send', 16, '#fff')))));
  }
  ptInfoModal() {
    const t = (this.PT_SCHEDULES.find(x => x.date === this.state.ptSchedule) || { tickets: [] }).tickets.find(x => x.id === this.state.ptInfoOpen);
    const info = this.PT_TICKET_INFO[this.state.ptInfoOpen];
    if (!t || !info) { return null; }
    const close = () => this.setState({ ptInfoOpen: null });
    const kvBlock = (label, ...rows) => this.h('div', { style: { marginBottom: '1.1rem' } },
      this.h('div', { style: { fontSize: '10.5px', fontWeight: 700, letterSpacing: '.06em', color: 'var(--muted)', textTransform: 'uppercase', marginBottom: '.3rem' } }, label),
      ...rows.map((r, i) => this.h('div', { key: i, style: { fontSize: '14px', fontWeight: r[1] ? 700 : 600, color: r[1] ? 'var(--ink)' : 'var(--text2)', lineHeight: 1.45 } }, r[0])));
    const contactRow = (ic, label, value, sub, tone) => this.h('div', { style: { display: 'flex', alignItems: 'flex-start', gap: '.8rem', padding: '.9rem 0', borderTop: '1px solid #f1f5f9' } },
      this.h('span', { style: { width: '36px', height: '36px', flexShrink: 0, borderRadius: '10px', background: (tone || '#eff8ff'), color: (tone ? '#b42318' : '#175cd3'), display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon(ic, 17)),
      this.h('div', { style: { minWidth: 0 } },
        this.h('div', { style: { fontSize: '11px', fontWeight: 600, color: 'var(--text3)', marginBottom: '2px' } }, label),
        this.h('div', { style: { fontSize: '14.5px', fontWeight: 700, color: 'var(--ink)', lineHeight: 1.35 } }, value),
        sub ? this.h('div', { style: { fontSize: '12.5px', color: 'var(--text3)', marginTop: '2px' } }, sub) : null));
    return this.h('div', { onClick: close, style: { position: 'fixed', inset: 0, zIndex: 60, display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'rgba(15,23,42,.5)', padding: '1.5rem' } },
      this.h('div', { onClick: e => e.stopPropagation(), style: { width: '460px', maxWidth: '100%', maxHeight: '88vh', display: 'flex', flexDirection: 'column', background: '#fff', borderRadius: '18px', boxShadow: '0 24px 64px rgba(15,23,42,.35)', overflow: 'hidden' } },
        this.h('div', { style: { display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: '1rem', padding: '1.25rem 1.4rem 1rem' } },
          this.h('div', { style: { minWidth: 0 } },
            this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.55rem', flexWrap: 'wrap' } },
              this.h('span', { style: { fontSize: '20px', fontWeight: 800, color: 'var(--ink)', fontFamily: 'ui-monospace,monospace' } }, info.no),
              this.h('span', { style: { fontSize: '11px', fontWeight: 700, color: '#5925dc', background: '#f4f3ff', border: '1px solid #e0d9ff', borderRadius: '999px', padding: '.15rem .55rem' } }, info.quote)),
            this.h('div', { style: { fontSize: '14px', fontWeight: 600, color: 'var(--text2)', marginTop: '.35rem' } }, info.customer)),
          this.h('button', { onClick: close, style: { width: '32px', height: '32px', flexShrink: 0, borderRadius: '8px', border: '1px solid var(--border)', background: '#fff', color: 'var(--text3)', display: 'flex', alignItems: 'center', justifyContent: 'center', cursor: 'pointer' } }, this.icon('close', 16))),
        this.h('div', { style: { overflowY: 'auto', padding: '.5rem 1.4rem 1.4rem' } },
          this.h('div', { style: { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '0 1rem' } },
            kvBlock('Date', [info.date, true]),
            kvBlock('Salesperson', [info.salesperson, true])),
          kvBlock('Equipment', [info.equipment, true]),
          kvBlock('Work', [info.work]),
          contactRow('mapPin', 'Job site (tap for Maps)', info.jobSite),
          contactRow('phone', 'Customer (tap to call)', info.customerPhone),
          contactRow('user', 'On-site contact', info.contact, info.contactPhone),
          contactRow('plus', 'Nearest hospital', info.hospital, info.hospitalAddr + ' · ' + info.hospitalPhone, '#fef3f2'),
          this.h('div', { style: { marginTop: '1.2rem' } },
            this.h('div', { style: { fontSize: '10.5px', fontWeight: 700, letterSpacing: '.06em', color: 'var(--muted)', textTransform: 'uppercase', marginBottom: '.5rem' } }, 'File Links'),
            (info.files && info.files.length) ? this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.5rem' } }, info.files.map((f, i) =>
              this.h('button', { key: i, onClick: () => this.ping('Opening ' + f), style: { display: 'flex', alignItems: 'center', gap: '.6rem', width: '100%', textAlign: 'left', borderRadius: '11px', border: '1px solid var(--border)', background: '#fbfcfe', padding: '.7rem .85rem', cursor: 'pointer' } },
                this.icon('paperclip', 15, '#64748b'),
                this.h('span', { style: { flex: 1, fontSize: '13.5px', fontWeight: 600, color: 'var(--ink)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' } }, f),
                this.icon('externalLink', 14, '#94a3b8'))))
              : this.h('div', { style: { fontSize: '13px', color: 'var(--text3)', padding: '.4rem 0' } }, 'No files attached.')),
          this.h('div', { style: { marginTop: '1.2rem' } },
            this.h('div', { style: { fontSize: '10.5px', fontWeight: 700, letterSpacing: '.06em', color: 'var(--muted)', textTransform: 'uppercase', marginBottom: '.5rem' } }, 'Comments'),
            (info.comments && info.comments.length) ? this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.5rem' } }, info.comments.map((c, i) =>
              this.h('div', { key: i, style: { borderRadius: '11px', background: '#f6f8fb', padding: '.7rem .85rem' } },
                this.h('div', { style: { display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: '.5rem' } },
                  this.h('span', { style: { fontSize: '13.5px', fontWeight: 700, color: 'var(--ink)' } }, c.name),
                  this.h('span', { style: { fontSize: '11.5px', fontWeight: 500, color: 'var(--text3)' } }, c.time)),
                this.h('div', { style: { fontSize: '13px', color: 'var(--text2)', marginTop: '2px' } }, c.text))))
              : this.h('div', { style: { fontSize: '13px', color: 'var(--text3)', padding: '.4rem 0' } }, 'No comments yet.')))));
  }
  ptSummaryCard(t) {
    const su = t.summary || {};
    const pct = Math.round((su.step / (su.total || 15)) * 100);
    const cells = [['Boom hours', su.boomHrs + (su.boomPaused ? ' \u00B7 paused' : ''), su.boomPaused ? '#b54708' : '#175cd3'], ['Net billable', su.net, '#0f172a'], ['Incidents', String(su.incidents), su.incidents ? '#b42318' : '#067647'], ['Deficiencies', String(su.deficiencies), su.deficiencies ? '#b54708' : '#067647']];
    return this.h('div', { style: { borderRadius: '16px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 2px rgba(15,23,42,.04)', padding: '1.25rem' } },
      this.h('div', { style: { fontSize: '12px', fontWeight: 700, letterSpacing: '.04em', color: 'var(--text2)', marginBottom: '.85rem' } }, 'SHIFT SUMMARY'),
      this.h('div', { style: { display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', gap: '.5rem' } },
        this.h('span', { style: { fontSize: '13.5px', fontWeight: 600, color: 'var(--text2)' } }, su.current),
        this.h('span', { style: { fontSize: '13px', fontWeight: 800, color: 'var(--ink)' } }, 'Step ' + su.step + '/' + su.total)),
      this.h('div', { style: { height: '7px', borderRadius: '999px', background: '#eef2f7', overflow: 'hidden', margin: '.55rem 0 1rem' } },
        this.h('div', { style: { width: pct + '%', height: '100%', borderRadius: '999px', background: su.notOpened ? '#cbd5e1' : su.incomplete ? '#b42318' : (su.flagged || su.blocked) ? '#f79009' : 'var(--blue)' } })),
      this.h('div', { style: { display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '.85rem 1rem' } }, cells.map((c, i) => this.ptKV(c[0], c[1], c[2]))),
      su.incomplete ? this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', marginTop: '.9rem', fontSize: '12px', fontWeight: 700, color: '#b42318' } }, this.icon('alert', 13, '#b42318'), su.incompleteStep + ' not completed') : null,
      su.flagged ? this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', marginTop: '.9rem', fontSize: '12px', fontWeight: 700, color: '#b54708' } }, this.icon('alert', 13, '#b54708'), 'Blocked at ' + su.incidentStep) : null,
      (su.blocked && !su.flagged) ? this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', marginTop: '.9rem', fontSize: '12px', fontWeight: 700, color: '#b54708' } }, this.icon('alert', 13, '#b54708'), 'Review & Complete blocked') : null);
  }
  ptIncompleteBanner(t) {
    const su = t.summary || {};
    if (!su.incomplete) return null;
    return this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '1rem', flexWrap: 'wrap', borderRadius: '16px', border: '1.5px solid #fda29b', background: '#fef3f2', boxShadow: '0 1px 3px rgba(180,35,24,.08)', padding: '1.1rem 1.4rem', marginBottom: '1.25rem' } },
      this.h('div', { style: { width: '40px', height: '40px', flexShrink: 0, borderRadius: '999px', background: '#fee4e2', color: '#b42318', display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon('alert', 20, '#b42318')),
      this.h('div', { style: { flex: '1 1 320px', minWidth: 0 } },
        this.h('div', { style: { fontSize: '15px', fontWeight: 800, color: '#912018' } }, 'Ticket Incomplete \u2014 Allocated Time Expired'),
        this.h('div', { style: { fontSize: '13px', color: '#912018', marginTop: '.25rem', lineHeight: 1.5 } },
          'The shift window ended (' + (su.expiredAt || 'scheduled end time') + ') before ', this.h('strong', {}, su.incompleteStep || 'the final step'), ' was completed by ', t.name, '. This ticket is automatically marked Incomplete and excluded from completed-ticket totals until resolved.')),
      this.h('button', { onClick: () => this.ping('Reminder sent to ' + t.name + ' to complete ' + (su.incompleteStep || 'the remaining step')), style: { flexShrink: 0, display: 'inline-flex', alignItems: 'center', gap: '.5rem', height: '40px', padding: '0 1.1rem', borderRadius: '10px', border: 'none', background: '#b42318', color: '#fff', fontSize: '13.5px', fontWeight: 700, cursor: 'pointer' } }, this.icon('send', 15, '#fff'), 'Send Reminder'));
  }
  ptIncidentBanner(t) {
    const su = t.summary || {};
    if (!su.flagged || !su.incidentMessage) return null;
    return this.h('div', { style: { display: 'flex', alignItems: 'flex-start', gap: '1rem', flexWrap: 'wrap', borderRadius: '16px', border: '1.5px solid #fedf89', background: '#fffaeb', boxShadow: '0 1px 3px rgba(181,71,8,.08)', padding: '1.1rem 1.4rem', marginBottom: '1.25rem' } },
      this.h('div', { style: { width: '40px', height: '40px', flexShrink: 0, borderRadius: '999px', background: '#fef0c7', color: '#b54708', display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon('alert', 20, '#b54708')),
      this.h('div', { style: { flex: '1 1 320px', minWidth: 0, display: 'flex', flexDirection: 'column', gap: '.4rem' } },
        this.h('div', { style: { fontSize: '15px', fontWeight: 800, color: '#93370d' } }, 'Ticket Flagged \u2014 Incident Reported'),
        this.h('div', { style: { fontSize: '13.5px', fontWeight: 700, color: '#93370d' } }, '\u201c' + su.incidentMessage + '\u201d'),
        this.h('div', { style: { fontSize: '13px', color: '#93370d', lineHeight: 1.5 } },
          'Reported by ', this.h('strong', {}, su.incidentReportedBy), ' through the ', this.h('strong', {}, su.incidentVia), '. Ticket is currently blocked at ', this.h('strong', {}, su.incidentStep), '.')),
      this.h('button', { onClick: () => this.go('daily-allocation-system'), style: { flexShrink: 0, display: 'inline-flex', alignItems: 'center', gap: '.5rem', height: '40px', padding: '0 1.1rem', borderRadius: '10px', border: 'none', background: '#b54708', color: '#fff', fontSize: '13.5px', fontWeight: 700, cursor: 'pointer' } }, this.icon('arrowRight', 15, '#fff'), 'Go to Daily Resource Allocation'));
  }
  ptDetail(t) {
    const su = t.summary || {};
    const timeline = this.h('div', { style: { flex: '3 1 440px', minWidth: '340px', display: 'flex', flexDirection: 'column', maxHeight: 'calc(100vh - 13rem)', overflowY: 'auto', paddingRight: '.75rem' } },
      this.h('div', { style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '.75rem', marginBottom: '1.1rem' } },
        this.h('div', { style: { fontSize: '13px', fontWeight: 700, letterSpacing: '.04em', color: 'var(--text2)' } }, 'ACTIVITY TIMELINE \u00B7 15-STEP FIELD FLOW'),
        this.h('div', { style: { display: 'flex', gap: '.4rem' } },
          this.h('button', { onClick: () => this.setState(s => { const e = { ...s.ptExpand }; t.timeline.forEach((_, i) => e[t.id + ':' + i] = true); return { ptExpand: e }; }), style: { fontSize: '12px', fontWeight: 700, color: 'var(--blue)', background: 'none', border: 'none', cursor: 'pointer' } }, 'Expand all'),
          this.h('span', { style: { color: '#cbd5e1' } }, '\u00B7'),
          this.h('button', { onClick: () => this.setState(s => { const e = { ...s.ptExpand }; t.timeline.forEach((_, i) => delete e[t.id + ':' + i]); return { ptExpand: e }; }), style: { fontSize: '12px', fontWeight: 700, color: 'var(--text3)', background: 'none', border: 'none', cursor: 'pointer' } }, 'Collapse all'))),
      su.notOpened ? this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.6rem', borderRadius: '12px', border: '1px solid #fecdca', background: '#fffbfa', padding: '.85rem 1rem', marginBottom: '1rem' } },
        this.icon('alert', 16, '#b42318'), this.h('span', { style: { fontSize: '13px', color: '#912018', fontWeight: 600 } }, 'Operator has not opened this ticket \u2014 no shift activity recorded yet.')) : null,
      this.h('div', { style: { display: 'flex', flexDirection: 'column' } }, t.timeline.map((st, i) => this.ptStepRow(t, st, i, t.timeline))),
      this.ptChecklistsSection(t));
    const side = this.h('div', { style: { flex: '1 1 300px', minWidth: '280px', maxWidth: '22rem', display: 'flex', flexDirection: 'column', gap: '1rem', position: 'sticky', top: '0', alignSelf: 'flex-start', maxHeight: 'calc(100vh - 13rem)', overflowY: 'auto' } },
      this.h('div', { style: { borderRadius: '16px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 2px rgba(15,23,42,.04)', padding: '1.25rem' } },
        this.h('div', { style: { fontSize: '12px', fontWeight: 700, letterSpacing: '.04em', color: 'var(--text2)', marginBottom: '.9rem' } }, 'EMPLOYEE DETAILS'),
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.75rem', marginBottom: '1rem' } }, this.avatar(t.name, t.idx, 44),
          this.h('div', { style: { flex: 1, minWidth: 0 } }, this.h('div', { style: { fontSize: '15px', fontWeight: 700, color: 'var(--ink)' } }, t.name), this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', marginTop: '2px' } }, this.h('span', { style: { width: '4px', height: '13px', borderRadius: '2px', background: t.roleTone } }), this.h('span', { style: { fontSize: '13px', color: 'var(--text2)' } }, t.role))),
          this.ptStatusBadge(t)),
        !t.opened ? this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.4rem', borderRadius: '10px', background: '#fffaeb', border: '1px solid #fedf89', padding: '.5rem .7rem', marginBottom: '.75rem', fontSize: '12px', fontWeight: 600, color: '#b54708' } }, this.icon('clock', 13, '#b54708'), 'Awaiting operator — send a reminder.') : null,
        this.h('button', { onClick: () => this.ping('Reminder email sent to ' + t.name), style: { display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '.5rem', width: '100%', height: '44px', borderRadius: '10px', border: 'none', background: 'var(--blue)', color: '#fff', fontSize: '13.5px', fontWeight: 700, cursor: 'pointer', marginBottom: '.6rem' } }, this.icon('send', 15, '#fff'), 'Send Reminder via Email'),
        this.h('button', { onClick: () => this.ping('Calling ' + t.name), style: { display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '.5rem', width: '100%', height: '44px', borderRadius: '10px', border: '1px solid var(--border)', background: '#fff', color: 'var(--text2)', fontSize: '13.5px', fontWeight: 700, cursor: 'pointer' } }, this.icon('phone', 15), 'Contact ' + t.role),
        this.h('button', { onClick: () => this.setState({ ptChat: t.name }), style: { display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '.5rem', width: '100%', height: '44px', borderRadius: '10px', border: '1px solid var(--border)', background: '#fff', color: 'var(--text2)', fontSize: '13.5px', fontWeight: 700, cursor: 'pointer', marginTop: '.6rem' } }, this.icon('chat', 15), 'Chat with ' + t.role.split(' ')[0])),
      this.ptSummaryCard(t),
      this.h('div', { style: { borderRadius: '16px', border: '1px solid var(--border)', background: '#fff', overflow: 'hidden' } },
        this.h('div', { style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between', padding: '.85rem 1.1rem' } },
          this.h('span', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', fontSize: '14px', fontWeight: 700, color: 'var(--ink)' } }, this.h('span', { style: { width: '9px', height: '9px', borderRadius: '999px', background: t.opened ? '#22c55e' : '#cbd5e1' } }), 'Live Tracking'),
          this.h('span', { style: { fontSize: '11.5px', fontWeight: 600, color: t.opened ? '#067647' : 'var(--text3)' } }, t.opened ? 'On site' : 'Offline')),
        this.h('div', { style: { position: 'relative', height: '150px', background: 'linear-gradient(135deg,#eaf1fb 0%,#dfeaf7 100%)', borderTop: '1px solid var(--border)' } },
          this.h('div', { style: { position: 'absolute', inset: 0, backgroundImage: 'linear-gradient(#cdddef 1px,transparent 1px),linear-gradient(90deg,#cdddef 1px,transparent 1px)', backgroundSize: '26px 26px', opacity: .6 } }),
          this.h('div', { style: { position: 'absolute', top: '38%', left: '-5%', width: '110%', height: '10px', background: '#f4b93f', transform: 'rotate(-8deg)' } }),
          this.h('div', { style: { position: 'absolute', top: '62%', left: '-5%', width: '110%', height: '6px', background: '#fff', transform: 'rotate(6deg)' } }),
          t.opened ? this.h('div', { style: { position: 'absolute', top: '46%', left: '54%', transform: 'translate(-50%,-50%)', display: 'flex', flexDirection: 'column', alignItems: 'center', gap: '.2rem' } },
            this.h('span', { style: { width: '34px', height: '34px', borderRadius: '999px', background: 'var(--blue)', border: '3px solid #fff', boxShadow: '0 2px 8px rgba(37,99,235,.5)', display: 'flex', alignItems: 'center', justifyContent: 'center', animation: 'tcg-pulse 1.7s infinite' } }, this.icon('truck', 16, '#fff'))) : null)));
    return this.h('div', {}, this.ptIncompleteBanner(t), this.ptIncidentBanner(t),
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '1.5rem', alignItems: 'flex-start' } }, timeline, side));
  }
  progressTracking() {
    const s = this.state;
    const sc = this.PT_SCHEDULES.find(x => x.date === s.ptSchedule);
    let right;
    if (!sc || !sc.tickets.length) {
      right = this.h('div', { style: { borderRadius: '16px', background: '#f0f6ff', border: '1px solid #dbeafe', minHeight: '18rem', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: '1rem', padding: '2rem' } },
        this.icon('file', 44, '#93c5fd'),
        this.h('div', { style: { fontSize: '15px', color: 'var(--text2)' } }, 'No data found ', this.h('button', { onClick: () => this.setState({ ptSchedule: this.PT_SCHEDULES[0].date }), style: { border: 'none', background: 'none', color: 'var(--blue)', fontSize: '15px', fontWeight: 700, cursor: 'pointer', padding: 0 } }, 'Select any date')));
    } else if (!s.ptTicket) {
      right = this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '1.25rem' } }, sc.tickets.map(t => this.ptTicketCard(t, true)));
    } else {
      const t = sc.tickets.find(x => x.id === s.ptTicket) || sc.tickets[0];
      right = this.ptDetail(t);
    }
    return this.h('div', { style: { display: 'flex', gap: '1.75rem', alignItems: 'flex-start' } }, this.ptSidebar(), this.h('div', { style: { flex: 1, minWidth: 0 } }, right),
      this.state.ptInfoOpen ? this.ptInfoModal() : null, this.ptChatPanel());
  }
  // ── job detail: hero, cards, quick access ────────────────────
  jdHero(p, d, j, src) {
    const meta = [['Customer', d.customer], ['Job Site', p.site], ['Billing Type', src ? src.billingType : null], ['Salesperson', src ? src.salesperson : j.foreman]]

// Section B: top-level Daily Progress Tracking module — template.html lines 12078-12664
  DPT_DATE_MAP = { '04/09/2026': [
    { pIdx: 0, jobs: { 0: ['TK-11722'] } },
    { pIdx: 1, jobs: { 0: ['TK-34098'], 1: ['TK-55310'] } },
    { pIdx: 2, jobs: { 0: ['TK-12935'] } },
  ] };
  // DPT_DATE_MAP is keyed by position within the SEEDED projects, so resolve it
  // against those only — projects created from a quotation must never inherit
  // another project's field activity.
  dptSeedProject(idx) {
    return (this.DATA.projects || []).filter(p => !p.fromQuote)[idx] || null;
  }
  dptBucket(statusCode) {
    if (statusCode === 'done') return 'completed';
    if (statusCode === 'progress') return 'progress';
    if (statusCode === 'incomplete') return 'incomplete';
    if (statusCode === 'flagged' || statusCode === 'incident') return 'flagged';
    return 'pending';
  }
  dptBucketCounts(tickets) {
    const b = { completed: 0, progress: 0, incomplete: 0, flagged: 0, pending: 0 };
    tickets.forEach(t => { b[this.dptBucket(this.ptTicketStatus(t).statusCode)]++; });
    return b;
  }
  dptHealth(tickets) {
    if (!tickets.length) return { code: 'none', label: 'No Activity', color: '#94a3b8', bg: '#f8fafc', bd: '#e2e8f0', icon: 'clock' };
    const b = this.dptBucketCounts(tickets);
    if (b.flagged) return { code: 'blocked', label: 'Blocked', color: '#b42318', bg: '#fef3f2', bd: '#fecdca', icon: 'alert' };
    if (b.incomplete || b.pending) return { code: 'atrisk', label: 'At Risk', color: '#b54708', bg: '#fffaeb', bd: '#fedf89', icon: 'clock' };
    return { code: 'healthy', label: 'Healthy', color: '#067647', bg: '#ecfdf3', bd: '#abefc6', icon: 'checkCircle' };
  }
  dptBuildDashboard(dateStr) {
    const sc = this.PT_SCHEDULES.find(x => x.date === dateStr) || { tickets: [] };
    const byId = {}; sc.tickets.forEach(t => { byId[t.id] = t; });
    const map = this.DPT_DATE_MAP[dateStr] || [];
    const projects = map.map(m => {
      const p = this.dptSeedProject(m.pIdx);
      if (!p) return null;
      const d = this.projDetails(p);
      const jobs = d.jobs.map((job, ji) => ({ job, tickets: ((m.jobs || {})[ji] || []).map(id => byId[id]).filter(Boolean) }));
      const tickets = jobs.flatMap(j => j.tickets);
      return { project: p, details: d, jobs, activeJobs: jobs.filter(j => j.tickets.length), tickets };
    }).filter(pr => pr && pr.tickets.length);
    return { projects, allTickets: sc.tickets };
  }
  dptKpiChip(label, value, tone) {
    const m = { slate: ['var(--ink)', '#f8fafc', '#e2e8f0'], blue: ['#175cd3', '#eff8ff', '#b2ddff'], green: ['#067647', '#ecfdf3', '#abefc6'], amber: ['#b54708', '#fffaeb', '#fedf89'], red: ['#b42318', '#fef3f2', '#fecdca'] };
    const c = m[tone] || m.slate;
    return this.h('div', { style: { flex: '1 1 100px', minWidth: '92px', borderRadius: '12px', border: '1px solid ' + c[2], background: c[1], padding: '.6rem .75rem' } },
      this.h('div', { style: { fontSize: '19px', fontWeight: 800, color: c[0], lineHeight: 1 } }, String(value)),
      this.h('div', { style: { fontSize: '10.5px', fontWeight: 700, color: 'var(--text3)', textTransform: 'uppercase', letterSpacing: '.03em', marginTop: '.3rem' } }, label));
  }
  dptProgressBar(pct, color) {
    return this.h('div', { style: { flex: '1 1 auto', width: '100%', minWidth: 0, height: '6px', borderRadius: '999px', background: '#eef2f7', overflow: 'hidden' } },
      this.h('div', { style: { width: Math.max(3, pct) + '%', height: '100%', borderRadius: '999px', background: color || 'var(--blue)' } }));
  }
  dptOpenTicket(dateStr, projId, jobId, ticketId) {
    this.setState({ dptView: 'detail', dptProjectId: projId, dptJobId: jobId, ptSchedule: dateStr, ptTicket: ticketId || null, ptExpand: {} });
  }
  dptJobPct(jw) {
    if (!jw.tickets.length) return 0;
    return Math.round(jw.tickets.reduce((s, t) => s + this.ptTicketStatus(t).pct, 0) / jw.tickets.length);
  }
  dptJobRow(dateStr, pr, jw) {
    const pct = this.dptJobPct(jw);
    const health = this.dptHealth(jw.tickets);
    return this.h('button', { key: jw.job.id, onClick: () => this.dptOpenProject(dateStr, pr.project.id, jw.job.id), style: { display: 'flex', alignItems: 'center', gap: '.75rem', width: '100%', textAlign: 'left', borderRadius: '10px', border: '1px solid var(--border)', background: '#fff', padding: '.65rem .85rem', cursor: 'pointer' } },
      this.h('div', { style: { flex: 1, minWidth: 0 } },
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', flexWrap: 'wrap' } },
          this.h('span', { style: { fontSize: '13px', fontWeight: 700, color: 'var(--ink)' } }, jw.job.name),
          this.ptMiniPill(jw.tickets.length ? jw.tickets.length + ' ticket' + (jw.tickets.length === 1 ? '' : 's') : 'No tickets', jw.tickets.length ? 'blue' : 'grey')),
        this.h('div', { style: { marginTop: '.35rem' } }, this.dptProgressBar(pct, health.color))),
      this.h('span', { style: { fontSize: '11.5px', fontWeight: 700, color: 'var(--text3)' } }, jw.tickets.length ? pct + '%' : '\u2014'),
      this.icon('chevron', 14, '#94a3b8'));
  }
  dptProjectCard(dateStr, pr) {
    const b = this.dptBucketCounts(pr.tickets);
    const health = this.dptHealth(pr.tickets);
    const avgPct = Math.round(pr.tickets.reduce((s, t) => s + this.ptTicketStatus(t).pct, 0) / (pr.tickets.length || 1));
    const kpiFilter = (bucket) => { const match = pr.tickets.find(t => this.dptBucket(this.ptTicketStatus(t).statusCode) === bucket); if (!match) return;
      const jw = pr.jobs.find(j => j.tickets.some(x => x.id === match.id)); this.dptOpenProject(dateStr, pr.project.id, jw.job.id, jw.job.id + ':' + match.id); };
    return this.h('div', { key: pr.project.id, style: { borderRadius: '16px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 2px rgba(15,23,42,.04)', overflow: 'hidden' } },
      this.h('button', { onClick: () => this.dptOpenProject(dateStr, pr.project.id, (pr.activeJobs[0] || pr.jobs[0]).job.id), style: { display: 'block', width: '100%', textAlign: 'left', border: 'none', background: 'none', cursor: 'pointer', padding: '1.1rem 1.25rem .9rem' } },
        this.h('div', { style: { display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: '.75rem' } },
          this.h('div', { style: { minWidth: 0 } },
            this.h('div', { style: { fontSize: '15.5px', fontWeight: 800, color: 'var(--ink)' } }, pr.project.site),
            this.h('div', { style: { fontSize: '12px', color: '#94a3b8', marginTop: '3px' } }, this.h('span', { style: { fontFamily: 'ui-monospace,monospace' } }, pr.project.id), ' \u00b7 ' + pr.details.customer),
            this.h('div', { style: { fontSize: '12px', color: 'var(--text3)', marginTop: '2px' } }, pr.activeJobs.length + ' of ' + pr.jobs.length + ' jobs active \u00b7 ' + pr.tickets.length + ' ticket' + (pr.tickets.length === 1 ? '' : 's'))),
          this.h('span', { style: { display: 'inline-flex', alignItems: 'center', gap: '.35rem', flexShrink: 0, borderRadius: '999px', border: '1px solid ' + health.bd, background: health.bg, color: health.color, padding: '.25rem .65rem', fontSize: '11.5px', fontWeight: 700 } }, this.icon(health.icon, 12, health.color), health.label)),
        this.h('div', { style: { marginTop: '.75rem', display: 'flex', alignItems: 'center', gap: '.6rem' } },
          this.dptProgressBar(avgPct, health.color), this.h('span', { style: { fontSize: '11.5px', fontWeight: 700, color: 'var(--text2)', flexShrink: 0 } }, avgPct + '%'))),
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.5rem', padding: '0 1.25rem .9rem' } },
        [['completed', 'Done', b.completed, 'green'], ['progress', 'Active', b.progress, 'blue'], ['pending', 'Not opened', b.pending, 'grey'], ['incomplete', 'Incomplete', b.incomplete, 'amber'], ['flagged', 'Flagged', b.flagged, 'red']].map(k =>
          this.h('button', { key: k[0], onClick: () => kpiFilter(k[0]), disabled: !k[2], style: { display: 'inline-flex', alignItems: 'center', gap: '.3rem', border: 'none', cursor: k[2] ? 'pointer' : 'default', borderRadius: '8px', padding: '.2rem .55rem', fontSize: '11.5px', fontWeight: 700, background: k[2] ? this.PT_TONE_BG[k[3]] : '#f8fafc', color: k[2] ? this.PT_TONE_FG[k[3]] : '#cbd5e1' } }, k[2], ' ', k[1]))),
      this.h('div', { style: { borderTop: '1px solid var(--border)', padding: '.9rem 1.25rem 1.1rem', display: 'flex', flexDirection: 'column', gap: '.5rem' } },
        pr.jobs.slice(0, 3).map(jw => this.dptJobRow(dateStr, pr, jw)),
        this.h('button', { onClick: () => this.dptOpenProject(dateStr, pr.project.id, (pr.activeJobs[0] || pr.jobs[0]).job.id), style: { display: 'inline-flex', alignItems: 'center', justifyContent: 'center', gap: '.4rem', marginTop: '.25rem', height: '36px', borderRadius: '9px', border: 'none', background: '#f1f5f9', color: 'var(--blue)', fontSize: '12.5px', fontWeight: 700, cursor: 'pointer' } }, 'Open project workspace', this.icon('arrowRight', 13, 'var(--blue)'))));
  }
  dptOpenProject(dateStr, projId, jobId, ticketKey) {
    this.setState({ dptView: 'project', dptProjectId: projId, dptJobId: jobId || null, ptSchedule: dateStr, dptTicketOpen: ticketKey || null });
  }
  dptOpenFullTicket(dateStr, projId, jobId, ticketId) {
    this.setState({ dptView: 'ticket', dptProjectId: projId, dptJobId: jobId, dptJobOpen: jobId, dptDateOpen: { [jobId + '|' + dateStr]: true }, ptSchedule: dateStr, ptTicket: ticketId, ptExpand: {} });
  }
  dptFact(label, value, color) {
    return this.h('div', { key: label, style: { minWidth: 0 } },
      this.h('div', { style: { fontSize: '10.5px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '.04em', color: 'var(--muted)' } }, label),
      this.h('div', { style: { fontSize: '13px', fontWeight: 600, color: color || 'var(--ink)', marginTop: '3px', overflow: 'hidden', textOverflow: 'ellipsis' } }, value));
  }
  dptStepStrip(t) {
    return this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.3rem' } }, t.timeline.map((st, i) => {
      const v = this.ptVis(st.st);
      const meta = this.PT_STEP_META[st.k] || [st.k, 'clock'];
      return this.h('span', { key: i, title: meta[0] + ' \u2014 ' + v.label, style: { display: 'inline-flex', alignItems: 'center', gap: '.25rem', borderRadius: '6px', border: '1px solid ' + v.bd, background: v.bg, color: v.c, padding: '.2rem .45rem', fontSize: '10.5px', fontWeight: 700, whiteSpace: 'nowrap' } },
        v.ic ? this.icon(v.ic, 10, v.c) : this.h('span', { style: { width: '5px', height: '5px', borderRadius: '999px', background: v.c } }), meta[0]);
    }));
  }
  dptTicketRow(dateStr, pr, jw, t) {
    const s = this.state;
    const st = this.ptTicketStatus(t);
    const v = this.ptVis(st.statusCode);
    const su = t.summary || {};
    const key = jw.job.id + ':' + t.id;
    const open = s.dptTicketOpen === key;
    const btn = (label, iconName, primary, cb) => this.h('button', { key: label, onClick: cb, style: { display: 'inline-flex', alignItems: 'center', gap: '.4rem', height: '36px', padding: '0 .9rem', borderRadius: '9px', border: primary ? 'none' : '1px solid var(--border)', background: primary ? 'var(--blue)' : '#fff', color: primary ? '#fff' : 'var(--text2)', fontSize: '12.5px', fontWeight: 700, cursor: 'pointer' } }, this.icon(iconName, 14, primary ? '#fff' : undefined), label);
    return this.h('div', { key: t.id, style: { borderRadius: '12px', border: '1px solid ' + (open ? v.bd : 'var(--border)'), background: '#fff', overflow: 'hidden' } },
      this.h('button', { onClick: () => this.setState({ dptTicketOpen: open ? null : key }), style: { display: 'flex', alignItems: 'center', gap: '.85rem', flexWrap: 'wrap', width: '100%', textAlign: 'left', border: 'none', background: open ? '#fbfcfe' : '#fff', cursor: 'pointer', padding: '.8rem 1rem' } },
        this.avatar(t.name, t.idx, 36),
        this.h('div', { style: { flex: '2 1 150px', minWidth: 0 } },
          this.h('div', { style: { fontSize: '13.5px', fontWeight: 700, color: 'var(--ink)' } }, t.name),
          this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.35rem', marginTop: '2px' } },
            this.h('span', { style: { width: '4px', height: '11px', borderRadius: '2px', background: t.roleTone } }),
            this.h('span', { style: { fontSize: '12px', color: 'var(--text3)' } }, t.role),
            this.h('span', { style: { fontSize: '11.5px', fontFamily: 'ui-monospace,monospace', color: '#94a3b8' } }, '\u00b7 ' + t.id))),
        this.h('div', { style: { flex: '1 1 140px', minWidth: '120px' } },
          this.dptProgressBar(st.pct, v.c),
          this.h('div', { style: { fontSize: '11px', fontWeight: 600, color: 'var(--text3)', marginTop: '.3rem' } }, 'Step ' + (su.step || 0) + ' of ' + (su.total || t.timeline.length) + ' \u00b7 ' + st.pct + '%')),
        this.ptChip(st.statusCode, st.statusLabel),
        this.h('span', { style: { display: 'flex', flexShrink: 0, transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .15s' } }, this.icon('chevron', 16, '#94a3b8'))),
      open ? this.h('div', { style: { borderTop: '1px solid var(--border)', padding: '.9rem 1rem 1rem', display: 'flex', flexDirection: 'column', gap: '.9rem' } },
        this.h('div', { style: { display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(130px,1fr))', gap: '.75rem' } },
          this.dptFact('Current step', su.current || '\u2014'),
          this.dptFact('Boom hours', su.boomHrs ? su.boomHrs + ' h' : '\u2014'),
          this.dptFact('Net payable', su.net || '\u2014'),
          this.dptFact('Deficiencies', String(su.deficiencies || 0), su.deficiencies ? '#b54708' : 'var(--ink)'),
          this.dptFact('Incidents', String(su.incidents || 0), su.incidents ? '#b42318' : 'var(--ink)')),
        this.h('div', {},
          this.h('div', { style: { fontSize: '10.5px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '.04em', color: 'var(--muted)', marginBottom: '.45rem' } }, 'Step progress \u00b7 15-step field flow'),
          this.dptStepStrip(t)),
        this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.5rem' } },
          btn('Open full progress', 'externalLink', true, () => this.dptOpenFullTicket(dateStr, pr.project.id, jw.job.id, t.id)),
          btn('Send reminder', 'send', false, () => this.ping('Reminder email sent to ' + t.name)),
          btn('Chat', 'chat', false, () => this.setState({ ptChat: t.name })))) : null);
  }
  dptProjectView() {
    const s = this.state;
    const dates = this.PT_SCHEDULES.map(x => x.date);
    const dateStr = dates[s.dptDashDateIdx];
    const { projects } = this.dptBuildDashboard(dateStr);
    const pr = projects.find(x => x.project.id === s.dptProjectId) || projects[0];
    if (!pr) return this.dptDashboard();
    const p = pr.project, d = pr.details;
    const health = this.dptHealth(pr.tickets);
    const b = this.dptBucketCounts(pr.tickets);
    const avgPct = Math.round(pr.tickets.reduce((sum, t) => sum + this.ptTicketStatus(t).pct, 0) / (pr.tickets.length || 1));
    const jw = pr.jobs.find(j => j.job.id === s.dptJobId) || pr.activeJobs[0] || pr.jobs[0];
    const jobNav = pr.jobs.map(x => {
      const sel = x.job.id === jw.job.id;
      const pct = this.dptJobPct(x);
      const jh = this.dptHealth(x.tickets);
      return this.h('button', { key: x.job.id, onClick: () => this.setState({ dptJobId: x.job.id, dptTicketOpen: null }), style: { display: 'flex', flexDirection: 'column', gap: '.45rem', width: '100%', textAlign: 'left', borderRadius: '12px', border: '1px solid ' + (sel ? '#b2ddff' : 'var(--border)'), background: sel ? '#f5faff' : '#fff', padding: '.75rem .85rem', cursor: 'pointer' } },
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem' } },
          this.h('span', { style: { flex: 1, minWidth: 0, fontSize: '13px', fontWeight: 700, color: sel ? 'var(--blue)' : 'var(--ink)' } }, x.job.name),
          this.pill(x.job.status)),
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.35rem', fontSize: '11.5px', lineHeight: 1.5, color: 'var(--text3)', whiteSpace: 'nowrap', overflow: 'hidden' } },
          this.h('span', { style: { fontFamily: 'ui-monospace,monospace' } }, x.job.id),
          this.h('span', {}, '\u00b7'),
          this.h('span', { style: { fontWeight: 700, color: x.tickets.length ? 'var(--text2)' : '#cbd5e1' } }, x.tickets.length ? x.tickets.length + ' ticket' + (x.tickets.length === 1 ? '' : 's') : 'No tickets')),
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem' } },
          this.h('div', { style: { flex: 1 } }, this.dptProgressBar(pct, jh.color)),
          this.h('span', { style: { fontSize: '11px', fontWeight: 700, color: 'var(--text3)' } }, x.tickets.length ? pct + '%' : '\u2014')));
    });
    const header = this.h('div', { style: { borderRadius: '16px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 2px rgba(15,23,42,.04)', overflow: 'hidden' } },
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'flex-start', justifyContent: 'space-between', gap: '1rem', padding: '1.1rem 1.35rem' } },
        this.h('div', { style: { minWidth: 0 } },
          this.h('button', { onClick: () => this.setState({ dptView: 'dashboard', dptTicketOpen: null }), style: { display: 'inline-flex', alignItems: 'center', gap: '.35rem', border: 'none', background: 'none', cursor: 'pointer', fontSize: '12px', fontWeight: 700, color: 'var(--blue)', padding: 0, marginBottom: '.5rem' } }, this.icon('arrowLeft', 13), 'All projects \u00b7 ' + dateStr),
          this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.6rem', flexWrap: 'wrap' } },
            this.h('h1', { style: { margin: 0, fontSize: '1.3rem', fontWeight: 800, color: 'var(--ink)' } }, p.site),
            this.pill(p.status),
            this.h('span', { style: { display: 'inline-flex', alignItems: 'center', gap: '.35rem', borderRadius: '999px', border: '1px solid ' + health.bd, background: health.bg, color: health.color, padding: '.2rem .6rem', fontSize: '11.5px', fontWeight: 700 } }, this.icon(health.icon, 12, health.color), health.label)),
          this.h('div', { style: { fontSize: '12px', color: '#94a3b8', marginTop: '.3rem', fontFamily: 'ui-monospace,monospace' } }, p.id)),
        this.dptDatePill()),
      this.h('div', { style: { display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(150px,1fr))', gap: '.9rem', padding: '0 1.35rem 1.1rem' } },
        this.dptFact('Customer', d.customer), this.dptFact('Equipment', p.equip), this.dptFact('Foreman', p.foreman),
        this.dptFact('Schedule', d.startDate + ' \u2013 ' + d.endDate), this.dptFact('PO / Quote', d.poNo + ' \u00b7 ' + d.quoteNo), this.dptFact('Site address', d.address)),
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '.6rem', borderTop: '1px solid var(--border)', background: '#fbfcfe', padding: '.85rem 1.35rem' } },
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.6rem', flex: '1 1 240px', minWidth: '200px' } },
          this.h('span', { style: { fontSize: '11px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '.04em', color: 'var(--muted)', whiteSpace: 'nowrap' } }, 'Day progress'),
          this.h('div', { style: { flex: 1 } }, this.dptProgressBar(avgPct, health.color)),
          this.h('span', { style: { fontSize: '12px', fontWeight: 800, color: 'var(--ink)' } }, avgPct + '%')),
        this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.4rem' } },
          [[pr.activeJobs.length + '/' + pr.jobs.length + ' jobs active', 'grey'], [pr.tickets.length + ' tickets', 'blue'], [b.completed + ' done', 'green'], [b.progress + ' in progress', 'blue'], [b.pending + ' not opened', 'grey'], [b.incomplete + ' incomplete', 'amber'], [b.flagged + ' flagged', 'red']].map(x => this.h('span', { key: x[0] }, this.ptMiniPill(x[0], x[1]))))));
    const jobPanel = this.h('div', { style: { flex: '1 1 260px', minWidth: '240px', maxWidth: '20rem', display: 'flex', flexDirection: 'column', gap: '.6rem' } },
      this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem' } },
        this.h('span', { style: { fontSize: '11px', fontWeight: 700, textTransform: 'uppercase', letterSpacing: '.04em', color: 'var(--muted)' } }, 'Jobs in this project'),
        this.h('span', { style: { fontSize: '11px', fontWeight: 700, color: 'var(--text3)', background: '#f1f5f9', borderRadius: '999px', padding: '.1rem .45rem' } }, String(pr.jobs.length))),
      jobNav);
    const ticketPanel = this.h('div', { style: { flex: '3 1 460px', minWidth: '320px', borderRadius: '16px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 2px rgba(15,23,42,.04)', overflow: 'hidden' } },
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', justifyContent: 'space-between', gap: '.75rem', padding: '1rem 1.25rem', borderBottom: '1px solid var(--border)' } },
        this.h('div', { style: { minWidth: 0 } },
          this.h('div', { style: { fontSize: '15px', fontWeight: 800, color: 'var(--ink)' } }, jw.job.name),
          this.h('div', { style: { fontSize: '12px', color: 'var(--text3)', marginTop: '2px' } }, jw.job.id + ' \u00b7 ' + jw.job.equip + ' \u00b7 Foreman ' + jw.job.foreman)),
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem' } }, this.pill(jw.job.status), this.ptMiniPill(jw.tickets.length + ' ticket' + (jw.tickets.length === 1 ? '' : 's'), jw.tickets.length ? 'blue' : 'grey'))),
      jw.tickets.length
        ? this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.6rem', padding: '1rem 1.25rem 1.25rem' } }, jw.tickets.map(t => this.dptTicketRow(dateStr, pr, jw, t)))
        : this.h('div', { style: { display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: '.5rem', padding: '3rem 1.25rem' } },
          this.icon('file', 32, '#cbd5e1'),
          this.h('div', { style: { fontSize: '13.5px', fontWeight: 700, color: 'var(--text2)' } }, 'No field tickets on ' + dateStr),
          this.h('div', { style: { fontSize: '12.5px', color: 'var(--text3)' } }, 'This job has no allocation for the selected day.')));
    return this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '1.1rem', padding: '.5rem 2.25rem 2.5rem' } },
      header,
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '1.1rem', alignItems: 'flex-start' } }, jobPanel, ticketPanel),
      this.ptChatPanel());
  }
  dptTicketFullView() {
    const s = this.state;
    const dates = this.PT_SCHEDULES.map(x => x.date);
    const dateStr = dates[s.dptDashDateIdx];
    const { projects } = this.dptBuildAll();
    const pr = projects.find(x => x.project.id === s.dptProjectId) || projects[0];
    if (!pr) return this.dptWorkspace();
    const jw = pr.jobs.find(j => j.tickets.some(x => x.id === s.ptTicket)) || pr.jobs.find(j => j.job.id === s.dptJobId) || pr.jobs[0];
    const t = (jw.tickets.find(x => x.id === s.ptTicket) || jw.tickets[0]);
    if (!t) return this.dptProjectView();
    const crumb = (label, cb) => this.h('button', { key: label, onClick: cb, style: { border: 'none', background: 'none', cursor: cb ? 'pointer' : 'default', padding: 0, fontSize: '12.5px', fontWeight: 700, color: cb ? 'var(--blue)' : 'var(--text2)' } }, label);
    const complete = this.ptTicketStatus(t).statusCode === 'done';
    return this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '1rem', padding: '.5rem 2.25rem 2.5rem' } },
      this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.6rem', flexWrap: 'wrap' } },
        this.h('button', { onClick: () => this.ptReportOpen(t.id), title: complete ? 'Download the completed ticket report' : 'Report will be marked in progress', style: { display: 'inline-flex', alignItems: 'center', gap: '.45rem', height: '38px', padding: '0 1rem', borderRadius: '10px', border: complete ? 'none' : '1px solid var(--border)', background: complete ? '#067647' : '#fff', color: complete ? '#fff' : 'var(--text2)', fontSize: '13px', fontWeight: 700, cursor: 'pointer', boxShadow: complete ? '0 1px 3px rgba(6,118,71,.3)' : 'none' } },
          this.icon('download', 15, complete ? '#fff' : '#64748b'), 'Download PDF'),
        complete ? this.h('span', { style: { fontSize: '12px', color: 'var(--text3)' } }, 'Full ticket record \u2014 every step, checklist item and deficiency') : this.h('span', { style: { fontSize: '12px', color: 'var(--text3)' } }, 'Ticket still in progress \u2014 report will be stamped as incomplete')),
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '.5rem', borderRadius: '12px', border: '1px solid var(--border)', background: '#fbfcfe', padding: '.6rem .9rem' } },
        this.h('span', { style: { display: 'flex' } }, this.icon('arrowLeft', 14, 'var(--blue)')),
        crumb('All projects', () => this.setState({ dptView: 'workspace' })),
        this.h('span', { style: { color: '#cbd5e1' } }, '/'),
        crumb(pr.project.site, () => this.setState({ dptView: 'workspace' })),
        this.h('span', { style: { color: '#cbd5e1' } }, '/'),
        crumb(jw.job.name, () => this.setState({ dptView: 'workspace', dptJobOpen: jw.job.id })),
        this.h('span', { style: { color: '#cbd5e1' } }, '/'),
        crumb(t.id + ' \u00b7 ' + t.name, null),
        this.h('span', { style: { marginLeft: 'auto', fontSize: '12px', color: 'var(--text3)' } }, dateStr)),
      this.h('div', {}, this.ptDetail(t)),
      this.state.ptReport === t.id ? this.ptTicketReport(t) : null,
      this.state.ptInfoOpen ? this.ptInfoModal() : null, this.ptChatPanel());
  }
  PT_SYNTH_STEP_KEYS = ['preTrip', 'leftYard', 'driving', 'arrivedJob', 'custFirstSig', 'jsa', 'startWork', 'endWork', 'custSig', 'leftJob', 'arriveYard', 'postInsp', 'compliance', 'labor', 'review'];
  PT_SYNTH_TIMES = ['5:40 AM', '5:55 AM', '6:10 AM', '8:45 AM', '8:55 AM', '9:05 AM', '9:20 AM', '2:40 PM', '2:55 PM', '3:10 PM', '4:15 PM', '4:30 PM', '4:45 PM', '4:55 PM', '5:05 PM'];
  PT_ROLE_TONES = { Operator: '#d1218b', Oiler: '#4338ca', Rigger: '#0e7490', 'Third Man': '#b45309' };
  ptSynthTicket(cfg) {
    const keys = this.PT_SYNTH_STEP_KEYS, times = this.PT_SYNTH_TIMES;
    const step = cfg.step, mode = cfg.mode || 'done';
    const timeline = keys.map((k, i) => {
      if (i < step - 1) return { k, st: 'done', time: times[i] };
      if (i === step - 1) return mode === 'pending' ? { k, st: 'pending' } : { k, st: mode, time: times[i] };
      return { k, st: 'pending' };
    });
    const stepLabel = (this.PT_STEP_META[keys[Math.max(0, Math.min(14, step - 1))]] || ['Step'])[0];
    const notOpened = mode === 'pending' && step <= 1;
    const doneSteps = mode === 'pending' ? step - 1 : step;
    const su = { step: doneSteps, total: 15,
      current: notOpened ? 'Not opened' : stepLabel + (mode === 'done' ? (step === 15 ? ' \u2014 ticket complete' : ' \u2014 complete') : mode === 'flagged' ? ' \u2014 flagged' : mode === 'incomplete' ? ' \u2014 incomplete' : mode === 'incident' ? ' \u2014 incident logged' : ' \u2014 in progress'),
      boomHrs: doneSteps >= 8 ? (doneSteps * 0.52).toFixed(1) : '0.0',
      net: doneSteps >= 8 ? (doneSteps * 0.55).toFixed(1) + ' hrs' : '\u2014',
      incidents: mode === 'incident' ? 1 : 0, deficiencies: mode === 'flagged' ? 1 : 0 };
    if (notOpened) su.notOpened = true;
    if (mode === 'incomplete') { su.incomplete = true; su.incompleteStep = stepLabel; }
    if (mode === 'flagged') su.flagged = true;
    return { id: cfg.id, name: cfg.name, role: cfg.role, roleTone: this.PT_ROLE_TONES[cfg.role] || '#4338ca', opened: !notOpened, idx: cfg.idx || 1, summary: su, timeline };
  }
  DPT_SEED_SPEC = {
    '04/09/2026': [
      { pIdx: 0, jobs: [
        { keep: ['TK-11722'], add: [['Dana Whitfield', 'Oiler', 15, 'done'], ['Curtis Vega', 'Operator', 9, 'progress'], ['Alicia Moore', 'Rigger', 6, 'progress']] },
        { add: [['Owen Brady', 'Operator', 15, 'done'], ['Peter Nunes', 'Oiler', 13, 'flagged'], ['Sasha Kim', 'Rigger', 8, 'progress'], ['Neil Barros', 'Third Man', 1, 'pending']] },
      ] },
      { pIdx: 1, jobs: [
        { keep: ['TK-34098'], add: [['Grant Ito', 'Operator', 15, 'done'], ['Rosa Delgado', 'Oiler', 12, 'progress'], ['Lee Chambers', 'Rigger', 5, 'progress']] },
        { keep: ['TK-55310'], add: [['Marcus Rivera', 'Operator', 15, 'done'], ['Tina Alvarez', 'Oiler', 10, 'progress'], ['Devin Brooks', 'Third Man', 7, 'progress']] },
      ] },
      { pIdx: 2, jobs: [
        { keep: ['TK-12935'], add: [['Hugo Salas', 'Operator', 15, 'done'], ['Bianca Ford', 'Oiler', 15, 'done'], ['Derek Poole', 'Rigger', 11, 'progress']] },
        { add: [['Ivan Petrov', 'Operator', 6, 'progress'], ['Nora Haddad', 'Oiler', 4, 'progress'], ['Chris Boone', 'Third Man', 2, 'progress']] },
      ] },
    ],
    '04/10/2026': [
      { pIdx: 0, jobs: [{ add: [['Dana Whitfield', 'Oiler', 1, 'pending'], ['Curtis Vega', 'Operator', 1, 'pending'], ['Alicia Moore', 'Rigger', 1, 'pending']] }] },
      { pIdx: 1, jobs: [{ add: [['Grant Ito', 'Operator', 1, 'pending'], ['Rosa Delgado', 'Oiler', 1, 'pending'], ['Lee Chambers', 'Rigger', 1, 'pending'], ['Tina Alvarez', 'Oiler', 1, 'pending']] }] },
    ],
    '04/11/2026': [
      { pIdx: 1, jobs: [{ add: [['Owen Brady', 'Operator', 1, 'pending'], ['Sasha Kim', 'Rigger', 1, 'pending'], ['Neil Barros', 'Third Man', 1, 'pending']] }] },
      { pIdx: 2, jobs: [{ add: [['Hugo Salas', 'Operator', 1, 'pending'], ['Bianca Ford', 'Oiler', 1, 'pending'], ['Derek Poole', 'Rigger', 1, 'pending']] }] },
    ],
  };
  DPT_SEEDED = this.dptSeedData();
  dptSeedData() {
    let n = 0;
    const map = {};
    Object.keys(this.DPT_SEED_SPEC).forEach(date => {
      const sc = this.PT_SCHEDULES.find(x => x.date === date);
      if (!sc) return;
      map[date] = this.DPT_SEED_SPEC[date].map(spec => {
        const jobs = {};
        spec.jobs.forEach((j, ji) => {
          const ids = (j.keep || []).slice();
          (j.add || []).forEach(a => {
            n++;
            const id = 'TK-' + (60100 + n * 37);
            sc.tickets.push(this.ptSynthTicket({ id, name: a[0], role: a[1], step: a[2], mode: a[3], idx: n }));
            ids.push(id);
          });
          jobs[ji] = ids;
        });
        return { pIdx: spec.pIdx, jobs };
      });
    });
    this.DPT_DATE_MAP = map;
    return true;
  }
  dptJobStatus(jw) {
    if (!jw.tickets.length) return 'OPEN';
    const b = this.dptBucketCounts(jw.tickets);
    if (b.flagged) return 'ON HOLD';
    if (b.incomplete) return 'IN REVIEW';
    if (b.progress) return 'IN PROGRESS';
    if (b.completed === jw.tickets.length) return 'COMPLETED';
    return 'SCHEDULED';
  }
  dptBuildAll() {
    const byDate = {};
    this.PT_SCHEDULES.forEach(sc => { const m = {}; sc.tickets.forEach(t => { m[t.id] = t; }); byDate[sc.date] = m; });
    const acc = {}, order = [];
    this.PT_SCHEDULES.forEach(sc => {
      (this.DPT_DATE_MAP[sc.date] || []).forEach(spec => {
        const p = this.dptSeedProject(spec.pIdx);
        if (!p) return;
        if (!acc[p.id]) { acc[p.id] = { project: p, details: this.projDetails(p), jobsById: {}, jobOrder: [] }; order.push(p.id); }
        const e = acc[p.id];
        Object.keys(spec.jobs).forEach(ji => {
          const job = e.details.jobs[ji];
          if (!job) return;
          const tickets = spec.jobs[ji].map(id => byDate[sc.date][id]).filter(Boolean);
          if (!tickets.length) return;
          if (!e.jobsById[job.id]) { e.jobsById[job.id] = { job, dates: [], tickets: [] }; e.jobOrder.push(job.id); }
          const jr = e.jobsById[job.id];
          jr.dates.push({ date: sc.date, status: sc.status, tone: sc.tone, tickets });
          jr.tickets = jr.tickets.concat(tickets);
        });
      });
    });
    const projects = order.map(id => {
      const e = acc[id];
      const jobs = e.jobOrder.map(jid => e.jobsById[jid]);
      return { project: e.project, details: e.details, jobs, activeJobs: jobs, tickets: jobs.reduce((a, j) => a.concat(j.tickets), []) };
    });
    return { projects, allTickets: projects.reduce((a, p) => a.concat(p.tickets), []) };
  }
  dptDateGroup(pr, jw, dg, focus) {
    const pct = Math.round(dg.tickets.reduce((s, t) => s + this.ptTicketStatus(t).pct, 0) / (dg.tickets.length || 1));
    const health = this.dptHealth(dg.tickets);
    const key = jw.job.id + '|' + dg.date;
    const map = this.state.dptDateOpen || {};
    const open = map[key] === undefined ? dg.date === focus : !!map[key];
    return this.h('div', { key: dg.date, style: { borderTop: '1px solid var(--border)' } },
      this.h('button', { onClick: () => this.setState(st => ({ dptDateOpen: { ...(st.dptDateOpen || {}), [key]: !open } })), style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '.7rem', width: '100%', textAlign: 'left', border: 'none', cursor: 'pointer', padding: '.6rem 1.1rem', background: open ? '#f5faff' : '#fbfcfe' } },
        this.h('span', { style: { display: 'flex', flexShrink: 0, transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .15s' } }, this.icon('chevron', 14, '#94a3b8')),
        this.icon('calendar', 14, open ? 'var(--blue)' : '#94a3b8'),
        this.h('span', { style: { fontSize: '12.5px', fontWeight: 800, color: open ? 'var(--blue)' : 'var(--ink)', fontFamily: 'ui-monospace,monospace' } }, dg.date),
        this.auditBadge(dg.tone, dg.status),
        this.h('span', { style: { fontSize: '11.5px', fontWeight: 600, color: 'var(--text3)' } }, dg.tickets.length + ' ticket' + (dg.tickets.length === 1 ? '' : 's')),
        this.h('div', { style: { flex: '1 1 90px', minWidth: '80px', display: 'flex', alignItems: 'center', gap: '.5rem' } },
          this.dptProgressBar(pct, health.color),
          this.h('span', { style: { flexShrink: 0, fontSize: '11.5px', fontWeight: 800, color: 'var(--text2)' } }, pct + '%'))),
      open ? dg.tickets.map((t, i) => this.dptTicketLine(dg.date, pr, jw, t, i === dg.tickets.length - 1)) : null);
  }
  dptKpiPanel(o) {
    const total = o.tickets || 1;
    const segs = [['Done', o.done, '#12b76a'], ['Active', o.progress, '#2e90fa'], ['Incomplete', o.incomplete, '#f79009'], ['Flagged', o.flagged, '#f04438'], ['Pending', o.pending, '#cbd5e1']];
    const counter = (label, value, first) => this.h('div', { key: label, style: { flex: '1 1 90px', padding: first ? '0 1.1rem 0 0' : '0 1.1rem', borderLeft: first ? 'none' : '1px solid var(--border)' } },
      this.h('div', { style: { fontSize: '22px', fontWeight: 800, lineHeight: 1, color: 'var(--ink)' } }, String(value)),
      this.h('div', { style: { fontSize: '10.5px', fontWeight: 700, letterSpacing: '.04em', textTransform: 'uppercase', color: 'var(--text3)', marginTop: '.35rem' } }, label));
    return this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '1.25rem', borderRadius: '16px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 2px rgba(15,23,42,.04)', padding: '1.15rem 1.4rem' } },
      this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '1rem', flexShrink: 0 } },
        this.h('div', { style: { width: '68px', height: '68px', flexShrink: 0, borderRadius: '999px', background: 'conic-gradient(var(--blue) ' + o.pct + '%, #eef2f7 0)', display: 'flex', alignItems: 'center', justifyContent: 'center' } },
          this.h('div', { style: { width: '54px', height: '54px', borderRadius: '999px', background: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center', fontSize: '15px', fontWeight: 800, color: 'var(--ink)' } }, o.pct + '%')),
        this.h('div', {},
          this.h('div', { style: { fontSize: '13.5px', fontWeight: 800, color: 'var(--ink)' } }, 'Overall progress'),
          this.h('div', { style: { fontSize: '11.5px', color: 'var(--text3)', marginTop: '2px' } }, o.done + ' of ' + o.tickets + ' tickets complete'))),
      this.h('div', { style: { flex: '2 1 300px', minWidth: '260px', display: 'flex', flexDirection: 'column', justifyContent: 'center', gap: '.6rem' } },
        this.h('div', { style: { display: 'flex', height: '10px', borderRadius: '999px', overflow: 'hidden', background: '#eef2f7' } },
          segs.filter(x => x[1]).map(x => this.h('div', { key: x[0], style: { width: (x[1] / total * 100) + '%', background: x[2] } }))),
        this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.35rem .9rem' } },
          segs.map(x => this.h('span', { key: x[0], style: { display: 'inline-flex', alignItems: 'center', gap: '.35rem', fontSize: '11.5px', fontWeight: 600, color: x[1] ? 'var(--text2)' : '#cbd5e1' } },
            this.h('span', { style: { width: '8px', height: '8px', borderRadius: '2px', background: x[1] ? x[2] : '#e2e8f0' } }),
            this.h('span', { style: { fontWeight: 800, color: x[1] ? 'var(--ink)' : '#cbd5e1' } }, String(x[1])), x[0])))),
      this.h('div', { style: { display: 'flex', flex: '1 1 260px', minWidth: '230px', alignItems: 'center', borderLeft: '1px solid var(--border)', paddingLeft: '1.1rem' } },
        counter('Projects', o.projects, true), counter('Jobs', o.jobs), counter('Tickets', o.tickets)));
  }
  dptKpiStrip(items) {
    return this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', borderRadius: '14px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 2px rgba(15,23,42,.04)', padding: '.9rem 1.25rem' } },
      items.map((it, i) => this.h('div', { key: it[0], style: { padding: i ? '0 1.15rem' : '0 1.15rem 0 0', borderLeft: i ? '1px solid var(--border)' : 'none' } },
        this.h('div', { style: { fontSize: '20px', fontWeight: 800, lineHeight: 1, color: it[2] || 'var(--ink)' } }, String(it[1])),
        this.h('div', { style: { fontSize: '10.5px', fontWeight: 700, letterSpacing: '.04em', textTransform: 'uppercase', color: 'var(--text3)', marginTop: '.35rem', whiteSpace: 'nowrap' } }, it[0]))));
  }
  dptProjectRail(dateStr, projects) {
    const s = this.state;
    const selId = (projects.find(x => x.project.id === s.dptProjectId) || projects[0] || {}).project;
    return this.h('div', { style: { flex: '1 1 250px', minWidth: '240px', maxWidth: '21rem', alignSelf: 'flex-start', borderRadius: '16px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 2px rgba(15,23,42,.04)', overflow: 'hidden' } },
      this.h('div', { style: { display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '.5rem', padding: '.85rem 1.1rem', borderBottom: '1px solid var(--border)' } },
        this.h('span', { style: { fontSize: '11px', fontWeight: 700, letterSpacing: '.05em', textTransform: 'uppercase', color: 'var(--text2)' } }, 'Projects'),
        this.h('span', { style: { fontSize: '11.5px', fontWeight: 700, color: 'var(--text3)', background: '#f1f5f9', borderRadius: '999px', padding: '.1rem .5rem' } }, String(projects.length))),
      projects.map((pr, i) => {
        const sel = selId && pr.project.id === selId.id;
        const health = this.dptHealth(pr.tickets);
        const pct = Math.round(pr.tickets.reduce((sum, t) => sum + this.ptTicketStatus(t).pct, 0) / (pr.tickets.length || 1));
        return this.h('button', { key: pr.project.id, onClick: () => this.setState({ dptProjectId: pr.project.id, dptJobOpen: null }), style: { display: 'flex', flexDirection: 'column', gap: '.45rem', width: '100%', textAlign: 'left', cursor: 'pointer', border: 'none', borderTop: i ? '1px solid var(--border)' : 'none', borderLeft: '3px solid ' + (sel ? 'var(--blue)' : 'transparent'), background: sel ? '#f5faff' : '#fff', padding: '.85rem 1.1rem' } },
          this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', minWidth: 0 } },
            this.h('span', { style: { width: '8px', height: '8px', flexShrink: 0, borderRadius: '999px', background: health.color } }),
            this.h('span', { style: { flex: 1, minWidth: 0, fontSize: '13.5px', fontWeight: 700, color: 'var(--ink)', overflow: 'hidden', textOverflow: 'ellipsis', whiteSpace: 'nowrap' } }, pr.project.site)),
          this.h('div', { style: { fontSize: '11.5px', fontFamily: 'ui-monospace,monospace', color: '#94a3b8', paddingLeft: '1rem' } }, pr.project.id),
          this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.55rem' } },
            this.dptProgressBar(pct, health.color),
            this.h('span', { style: { flexShrink: 0, fontSize: '11.5px', fontWeight: 700, color: 'var(--text2)' } }, pct + '%')),
          this.h('div', { style: { fontSize: '11.5px', color: 'var(--text3)' } }, pr.jobs.length + ' job' + (pr.jobs.length === 1 ? '' : 's') + ' \u00b7 ' + pr.tickets.length + ' ticket' + (pr.tickets.length === 1 ? '' : 's')));
      }));
  }
  dptTicketLine(dateStr, pr, jw, t, last) {
    const st = this.ptTicketStatus(t);
    const v = this.ptVis(st.statusCode);
    const su = t.summary || {};
    return this.h('div', { key: t.id, style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '.85rem', padding: '.75rem 1.1rem', borderTop: '1px solid var(--border)' } },
      this.h('span', { style: { width: '30px', height: '30px', flexShrink: 0, borderRadius: '9px', border: '1px solid ' + v.bd, background: v.bg, color: v.c, display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon(v.ic || 'clock', 14, v.c)),
      this.h('div', { style: { flex: '2 1 150px', minWidth: 0 } },
        this.h('div', { style: { fontSize: '13px', fontWeight: 700, fontFamily: 'ui-monospace,monospace', color: 'var(--ink)' } }, t.id),
        this.h('div', { style: { fontSize: '12px', color: 'var(--text3)', marginTop: '2px' } }, t.name + ' \u00b7 ' + t.role)),
      this.h('div', { style: { flex: '2 1 160px', minWidth: '120px', display: 'flex', alignItems: 'center', gap: '.6rem' } },
        this.dptProgressBar(st.pct, v.c),
        this.h('span', { style: { flexShrink: 0, fontSize: '12px', fontWeight: 800, color: v.c } }, st.pct + '%')),
      this.h('span', { style: { flexShrink: 0, fontSize: '12px', fontWeight: 600, color: 'var(--text2)', whiteSpace: 'nowrap' } }, 'Step ' + (su.step || 0) + ' / ' + (su.total || t.timeline.length)),
      this.ptChip(st.statusCode, st.statusLabel),
      this.h('button', { onClick: () => this.dptOpenFullTicket(dateStr, pr.project.id, jw.job.id, t.id), style: { display: 'inline-flex', alignItems: 'center', gap: '.35rem', flexShrink: 0, height: '34px', padding: '0 .8rem', borderRadius: '9px', border: '1px solid var(--border)', background: '#fff', color: 'var(--blue)', fontSize: '12.5px', fontWeight: 700, cursor: 'pointer' } }, 'Timeline', this.icon('arrowRight', 13, 'var(--blue)')));
  }
  dptJobAccordion(dateStr, pr, jw, open) {
    const pct = this.dptJobPct(jw);
    const health = this.dptHealth(jw.tickets);
    return this.h('div', { key: jw.job.id, style: { borderRadius: '14px', border: '1px solid var(--border)', background: '#fff', overflow: 'hidden' } },
      this.h('button', { onClick: () => this.setState({ dptJobOpen: open ? '' : jw.job.id }), style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '.85rem', width: '100%', textAlign: 'left', border: 'none', background: open ? '#fbfcfe' : '#fff', cursor: 'pointer', padding: '.85rem 1.1rem' } },
        this.h('span', { style: { display: 'flex', flexShrink: 0, transform: open ? 'rotate(180deg)' : 'none', transition: 'transform .15s' } }, this.icon('chevron', 16, '#94a3b8')),
        this.h('div', { style: { flex: '2 1 180px', minWidth: 0 } },
          this.h('div', { style: { fontSize: '14px', fontWeight: 800, color: 'var(--ink)' } }, jw.job.name),
          this.h('div', { style: { fontSize: '11.5px', fontFamily: 'ui-monospace,monospace', color: '#94a3b8', marginTop: '2px' } }, jw.job.id + '  \u00b7  ' + jw.job.equip)),
        this.h('span', { style: { flexShrink: 0, fontSize: '12px', fontWeight: 600, color: 'var(--text2)' } }, jw.dates.length + ' schedule' + (jw.dates.length === 1 ? '' : 's') + ' \u00b7 ' + jw.tickets.length + ' ticket' + (jw.tickets.length === 1 ? '' : 's')),
        this.h('div', { style: { flex: '1 1 120px', minWidth: '90px', display: 'flex', alignItems: 'center', gap: '.55rem' } },
          this.dptProgressBar(pct, health.color),
          this.h('span', { style: { flexShrink: 0, fontSize: '12px', fontWeight: 800, color: 'var(--text2)' } }, pct + '%')),
        this.h('span', { style: { flexShrink: 0 } }, this.pill(this.dptJobStatus(jw))),
        this.h('span', { style: { display: 'inline-flex', alignItems: 'center', gap: '.3rem', flexShrink: 0, borderRadius: '999px', border: '1px solid ' + health.bd, background: health.bg, color: health.color, padding: '.2rem .6rem', fontSize: '11.5px', fontWeight: 700 } }, this.icon(health.icon, 11, health.color), health.label)),
      open ? (jw.dates.length
        ? jw.dates.map(dg => this.dptDateGroup(pr, jw, dg, dateStr))
        : this.h('div', { style: { borderTop: '1px solid var(--border)', padding: '1.25rem 1.1rem', fontSize: '12.5px', color: 'var(--text3)' } }, 'No schedules allocated to this job.')) : null);
  }
  dptWorkspace() {
    const s = this.state;
    const dates = this.PT_SCHEDULES.map(x => x.date);
    const dateStr = dates[s.dptDashDateIdx];
    const { projects, allTickets } = this.dptBuildAll();
    const b = this.dptBucketCounts(allTickets);
    const runningJobs = projects.reduce((n, p) => n + p.jobs.length, 0);
    const avgPct = Math.round(allTickets.reduce((sum, t) => sum + this.ptTicketStatus(t).pct, 0) / (allTickets.length || 1));
    const head = this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', justifyContent: 'space-between', gap: '1rem' } },
      this.h('div', {},
        this.h('h1', { style: { margin: 0, fontSize: '1.375rem', fontWeight: 800, color: 'var(--ink)' } }, 'Daily Progress Tracking'),
        this.h('p', { style: { margin: '.3rem 0 0', fontSize: '13px', color: 'var(--text3)' } }, 'Project \u2192 jobs \u2192 schedule dates \u2192 tickets \u2014 live field progress.')),
      this.dptDatePill());
    if (!projects.length) {
      return this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '1.25rem', padding: '.5rem 2.25rem 2.5rem' } }, head,
        this.h('div', { style: { borderRadius: '16px', border: '1px dashed var(--border-strong)', background: '#fbfcfe', minHeight: '16rem', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: '.6rem', padding: '2rem' } },
          this.icon('calendar', 36, '#cbd5e1'),
          this.h('div', { style: { fontSize: '14px', fontWeight: 700, color: 'var(--text2)' } }, 'No projects running on ' + dateStr),
          this.h('div', { style: { fontSize: '12.5px', color: 'var(--text3)' } }, 'Pick a different date to see active field tickets.')));
    }
    const pr = projects.find(x => x.project.id === s.dptProjectId) || projects[0];
    const p = pr.project, d = pr.details;
    const health = this.dptHealth(pr.tickets);
    const pb = this.dptBucketCounts(pr.tickets);
    const projPct = Math.round(pr.tickets.reduce((sum, t) => sum + this.ptTicketStatus(t).pct, 0) / (pr.tickets.length || 1));
    const openJob = s.dptJobOpen === null || s.dptJobOpen === undefined ? (pr.activeJobs[0] || pr.jobs[0]).job.id : s.dptJobOpen;
    const projHeader = this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '.9rem', borderRadius: '14px', border: '1px solid var(--border)', background: '#fff', boxShadow: '0 1px 2px rgba(15,23,42,.04)', padding: '.8rem .95rem' } },
      this.h('div', { style: { flexShrink: 0, width: '58px', height: '58px', borderRadius: '11px', background: 'linear-gradient(140deg,#0f2f6b 0%,#1a4fa0 100%)', color: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'center' } }, this.icon('building', 24, '#fff')),
      this.h('div', { style: { flex: '2 1 200px', minWidth: 0 } },
        this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', flexWrap: 'wrap' } },
          this.h('h2', { style: { margin: 0, fontSize: '15.5px', fontWeight: 800, color: 'var(--ink)', letterSpacing: '-.01em' } }, p.site),
          this.h('span', { style: { display: 'inline-flex', alignItems: 'center', gap: '.3rem', borderRadius: '999px', border: '1px solid ' + health.bd, background: health.bg, color: health.color, padding: '.15rem .55rem', fontSize: '11px', fontWeight: 700 } }, this.icon(health.icon, 11, health.color), health.label)),
        this.h('div', { style: { marginTop: '.2rem', fontSize: '11.5px', fontFamily: 'ui-monospace,monospace', color: 'var(--text3)' } }, p.id + '  \u00b7  ' + d.customer),
        this.h('div', { style: { marginTop: '.35rem', display: 'flex', flexWrap: 'wrap', gap: '.35rem' } },
          [['Done', pb.completed, 'green'], ['Active', pb.progress, 'blue'], ['Incomplete', pb.incomplete, 'amber'], ['Flagged', pb.flagged, 'red'], ['Pending', pb.pending, 'grey']].map(k =>
            this.h('span', { key: k[0], style: { display: 'inline-flex', alignItems: 'center', gap: '.3rem', borderRadius: '7px', padding: '.15rem .5rem', fontSize: '11px', fontWeight: 700, background: k[1] ? this.PT_TONE_BG[k[2]] : '#f8fafc', color: k[1] ? this.PT_TONE_FG[k[2]] : '#cbd5e1' } }, k[1] + ' ' + k[0])))),
      this.h('div', { style: { flexShrink: 0, textAlign: 'right' } },
        this.h('div', { style: { fontSize: '1.25rem', fontWeight: 800, color: 'var(--ink)', lineHeight: 1 } }, projPct + '%'),
        this.h('div', { style: { marginTop: '.25rem', fontSize: '10px', fontWeight: 700, letterSpacing: '.05em', textTransform: 'uppercase', color: 'var(--text3)' } }, 'Progress')));
    return this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '1.25rem', padding: '.5rem 2.25rem 2.5rem' } }, head,
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '1.1rem', alignItems: 'flex-start' } },
        this.dptProjectRail(dateStr, projects),
        this.h('div', { style: { flex: '3 1 480px', minWidth: '320px', display: 'flex', flexDirection: 'column', gap: '1rem' } },
          projHeader,
          this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '.7rem' } },
            pr.jobs.map(jw => this.dptJobAccordion(dateStr, pr, jw, openJob === jw.job.id))))),
      this.ptChatPanel());
  }
  PT_TONE_BG = { green: '#ecfdf3', blue: '#eff8ff', amber: '#fffaeb', red: '#fef3f2', grey: '#f1f5f9' };
  PT_TONE_FG = { green: '#067647', blue: '#175cd3', amber: '#b54708', red: '#b42318', grey: '#475467' };
  dptDatePill() {
    const s = this.state;
    const dates = this.PT_SCHEDULES.map(x => x.date);
    const idx = s.dptDashDateIdx;
    const change = ni => { this.setState({ dptDashDateIdx: ni, dptLoading: true }); clearTimeout(this._dptT); this._dptT = setTimeout(() => this.setState({ dptLoading: false }), 350); };
    return this.h('div', { style: { display: 'flex', alignItems: 'center', gap: '.75rem', borderRadius: '12px', background: 'var(--ink)', padding: '.5rem .75rem', width: 'fit-content' } },
      this.h('button', { onClick: () => change(Math.max(0, idx - 1)), style: { display: 'flex', border: 'none', background: 'none', cursor: 'pointer', color: '#fff' } }, this.icon('arrowLeft', 16)),
      this.h('span', { style: { display: 'flex', alignItems: 'center', gap: '.5rem', fontSize: '14.5px', fontWeight: 700, color: '#fff', whiteSpace: 'nowrap' } }, this.icon('calendar', 15, '#fff'), dates[idx]),
      this.h('button', { onClick: () => change(Math.min(dates.length - 1, idx + 1)), style: { display: 'flex', border: 'none', background: 'none', cursor: 'pointer', color: '#fff' } }, this.icon('arrowRight', 16)));
  }
  dptSkeletonCard() {
    const bar = (w, h) => this.h('div', { style: { width: w, height: h || '10px', borderRadius: '6px', background: '#eef2f7' } });
    return this.h('div', { style: { borderRadius: '16px', border: '1px solid var(--border)', background: '#fff', padding: '1.25rem', display: 'flex', flexDirection: 'column', gap: '.75rem' } },
      bar('55%', '15px'), bar('35%'), bar('100%', '6px'), bar('80%'), bar('100%', '48px'), bar('100%', '48px'));
  }
  dptDashboard() {
    const s = this.state;
    const dates = this.PT_SCHEDULES.map(x => x.date);
    const dateStr = dates[s.dptDashDateIdx];
    const { projects, allTickets } = this.dptBuildDashboard(dateStr);
    const b = this.dptBucketCounts(allTickets);
    const runningJobs = projects.reduce((n, p) => n + p.activeJobs.length, 0);
    const avgPct = Math.round(allTickets.reduce((sum, t) => sum + this.ptTicketStatus(t).pct, 0) / (allTickets.length || 1));
    return this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '1.25rem', padding: '.5rem 2.25rem 2.5rem' } },
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', justifyContent: 'space-between', gap: '1rem' } },
        this.h('div', {}, this.h('h1', { style: { margin: 0, fontSize: '1.375rem', fontWeight: 800, color: 'var(--ink)' } }, 'Daily Progress Tracking'), this.h('p', { style: { margin: '.3rem 0 0', fontSize: '13px', color: 'var(--text3)' } }, 'Field ticket progress across all running projects and jobs.')),
        this.dptDatePill()),
      s.dptLoading ? this.h('div', { style: { display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(280px,1fr))', gap: '1rem' } }, [0, 1, 2].map(i => this.h(React.Fragment, { key: i }, this.dptSkeletonCard()))) :
      this.h(React.Fragment, {},
        this.h('div', { style: { display: 'flex', flexWrap: 'wrap', gap: '.75rem' } },
          this.dptKpiChip('Active Projects', projects.length, 'slate'), this.dptKpiChip('Running Jobs', runningJobs, 'slate'),
          this.dptKpiChip('Total Tickets', allTickets.length, 'blue'), this.dptKpiChip('Completed', b.completed, 'green'),
          this.dptKpiChip('In Progress', b.progress, 'blue'), this.dptKpiChip('Not Opened', b.pending, 'slate'), this.dptKpiChip('Incomplete', b.incomplete, 'amber'),
          this.dptKpiChip('Flagged / Blocked', b.flagged, 'red'), this.dptKpiChip('Overall Progress', avgPct + '%', 'slate')),
        projects.length
          ? this.h('div', { style: { display: 'grid', gridTemplateColumns: 'repeat(auto-fit,minmax(320px,1fr))', gap: '1.1rem' } }, projects.map(pr => this.dptProjectCard(dateStr, pr)))
          : this.h('div', { style: { borderRadius: '16px', border: '1px dashed var(--border-strong)', background: '#fbfcfe', minHeight: '14rem', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: '.6rem', padding: '2rem' } },
            this.icon('calendar', 36, '#cbd5e1'), this.h('div', { style: { fontSize: '14px', fontWeight: 700, color: 'var(--text2)' } }, 'No projects running on ' + dateStr), this.h('div', { style: { fontSize: '12.5px', color: 'var(--text3)' } }, 'Pick a different date to see active field tickets.'))));
  }
  dptSelect(value, options, onChange) {
    return this.h('select', { value, onChange: e => onChange(e.target.value), style: { height: '34px', padding: '0 .6rem', borderRadius: '8px', border: '1px solid var(--border)', background: '#fff', fontSize: '12.5px', fontWeight: 600, color: 'var(--ink)', cursor: 'pointer' } },
      options.map(o => this.h('option', { key: o[0], value: o[0] }, o[1])));
  }
  dptDetailView() {
    const s = this.state;
    const projects = this.DATA.projects;
    const projId = s.dptProjectId || projects[0].id;
    const proj = projects.find(p => p.id === projId) || projects[0];
    const d = this.projDetails(proj);
    const jobId = s.dptJobId || d.jobs[0].id;
    const job = d.jobs.find(j => j.id === jobId) || d.jobs[0];
    return this.h('div', { style: { display: 'flex', flexDirection: 'column', gap: '1rem', padding: '.5rem 2.25rem 2.5rem' } },
      this.h('div', { style: { display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '.6rem', borderRadius: '10px', border: '1px solid var(--border)', background: '#fbfcfe', padding: '.55rem .75rem' } },
        this.h('button', { onClick: () => this.setState({ dptView: 'dashboard' }), style: { display: 'inline-flex', alignItems: 'center', gap: '.35rem', border: 'none', background: 'none', cursor: 'pointer', fontSize: '12.5px', fontWeight: 700, color: 'var(--blue)', padding: 0 } }, this.icon('arrowLeft', 14), 'Back to Progress Overview'),
        this.h('span', { style: { color: '#cbd5e1' } }, '/'),
        this.h('span', { style: { fontSize: '12px', fontWeight: 700, color: 'var(--text2)' } }, 'Project'),
        this.dptSelect(proj.id, projects.map(p => [p.id, p.site]), v => this.setState({ dptProjectId: v, dptJobId: null, ptSchedule: null, ptTicket: null })),
        this.h('span', { style: { color: '#cbd5e1' } }, '/'),
        this.h('span', { style: { fontSize: '12px', fontWeight: 700, color: 'var(--text2)' } }, 'Job'),
        this.dptSelect(job.id, d.jobs.map(j => [j.id, j.name]), v => this.setState({ dptJobId: v, ptSchedule: null, ptTicket: null })),
        this.h('span', { style: { marginLeft: 'auto', fontSize: '12px', color: 'var(--text3)' } }, 'Global progress tracking \u2014 all jobs share today\u2019s field activity feed')),
      this.progressTracking());
  }
  dailyProgressTracking() {
    const v = this.state.dptView;
    if (v === 'ticket') return this.dptTicketFullView();
    return this.dptWorkspace();
  }

// Section C: nav entry + job-detail tab list
      this.navBtn({ iconName: 'flow', label: 'Daily Progress Tracking', active: v === 'daily-progress-tracking', onClick: () => { this.go('daily-progress-tracking'); this.setState({ dptView: 'workspace', dptProjectId: null, dptJobOpen: null }); } }),
    const tabs = ['Main', 'Resources', 'Schedule', 'Tool/Rigging', 'Permits / Plans' + (artCount ? ' (' + artCount + ')' : ''), 'Additional Info', 'Progress Tracking', 'Attachments', 'Activity Log'];
    } else if (jt === 'Progress Tracking') {
      content = this.progressTracking();
    if (v === 'daily-progress-tracking') return this.dailyProgressTracking();
