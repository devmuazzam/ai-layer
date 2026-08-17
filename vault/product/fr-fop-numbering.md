# FR-FOP requirement numbering — the two sets are NOT the same

Moved out of `INDEX.md` 2026-08-17 so the index stays a routing table. Referenced from caveat 3 there.

**`product/field-ops-frd/08-functional-requirements/` — FOP-002 v2.0 DRAFT, 30 reqs**

```
001 Bottom Navigation · 002 Home Dashboard · 003 Jobs List · 004 Ticket Details
005 Ticket Acceptance · 006 Ticket Rejection · 007 Ticket Draft Management · 008 Pre-Trip Checklist
009 Leave Yard · 010 Arrive Job Site · 011 Job Safety Analysis (JSA) · 012 Start Work
013 Lunch Monitoring · 014 Lunch Recording · 015 Work Through Lunch · 016 End Work
017 Compliance Checklist · 018 Customer Signatures · 019 Leave Job Site · 020 Arrive Yard
021 Post-Trip Checklist · 022 Submit Ticket · 023 Labor Details · 024 Downtime Management
025 Deficiency Reporting · 026 Escalation Handling · 027 Notification Center · 028 Certifications
029 Tasks · 030 Inspection History
```

**`product/frd-new-format-draft/05-functional-requirements/` — FOP-001 v1.1 REVIEWED, 40 reqs**

```
001 Bottom Navigation · 002 Home Dashboard · 003 Jobs List · 004 Ticket Notification
005 Accept / Reject Ticket · 006 Ticket Detail View · 007 Guided Ticket Workflow · 008 Leave Yard
009 Pre-Trip Checklist · 010 Arrive Job · 011 JSA / Safety Checklist · 012 Start Work
013 Lunch Timer and Alerts · 014 Start / End Lunch · 015 Work-Through-Lunch Authorization · 016 Initial Customer Signature
017 Final Customer Signature · 018 Signature Quality / Fraud Prevention · 019 End Work · 020 Leave Job
021 Arrive Yard · 022 Compliance Checklist · 023 Labor Detail Entry · 024 Boom Pay / Craft Modifier Selection
025 Submit Ticket · 026 Incomplete Ticket Handling · 027 Deficiency Capture · 028 Blocking Issue / Emergency Escalation
029 Notification Center · 030 Downtime and Delay Capture · 031 Live Ticket Visibility · 032 View Certifications
033 Certification Expiry Notification and Upload · 034 Field Task List · 035 Labor History and Audit · 036 Field User Profile
037 Emergency Contacts · 038 Time Rounding · 039 Auto-Save · 040 Audit Trail
```

Filenames are `fr-fop-NNN-<slug>.md` inside the folder above. Only 001, 002, 003, 008/009 (Leave Yard), 012 (Start Work) and 021/020 (Arrive Yard) describe roughly the same thing in both sets — everything else diverges.
