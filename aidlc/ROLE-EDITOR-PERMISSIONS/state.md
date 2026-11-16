# State — ROLE-EDITOR-PERMISSIONS Role editor rework and hiding controls a role does not grant

**Path:** C (no ticket, no Jira id) · **Branch(es):** `feat/hide-actions-without-permission` (local, not pushed, no PR) · **Last updated:** 2026-11-13 (end-to-end pass) by Claude Code session (jahanzaib)

**Status: INCOMPLETE.** The role editor and the control-hiding work are built and checked, but
three things are deferred and the client-facing behaviour is unconfirmed (below).

## Phases

- [S] Intent — path C, no ticket
- [S] Spec — path C
- [S] Sign-off — path C
- [S] Units — path C
- [-] Build — role editor rework and web control hiding done; three items deferred (see Resume)
- [ ] Analyse — `review-pr` not run
- [ ] Merged — PR #…, not opened
- [ ] Reflect — not run
- [ ] Closed — `close-ticket` not run

## Resume

Built on the branch: the role editor as module rows with View / Create / Edit / Archive toggles,
settings as inline toggles and cards, one-hop linked View grants, only enforced modules and actions
offered, grant limits, web portal access derived from permissions (web and API), and hiding
create, edit, archive and upload controls the role does not grant across the web modules. Checked:
web typecheck, API build typecheck, eslint on touched files, `jest src/utility/seed-data` (14/14),
role editor on screen. Not run: the other API and web test suites, the e2e suite, a role without
access in the browser (the restricted-role check was never done), mobile.

**End-to-end verification, 2026-11-13 (local TCG-DEFAULT tenant, 13 QA personas `qa-access-*@e2e.craneguys.test`
in department `QA Access` and the Sales, Dispatch, Accounting, HR and Management departments; seed script and
generated password in the session scratchpad, not in the repo):**
- API: all 13 personas log in and `/users/me` returns exactly the stored permissions; the no-access role is
  refused at signin; a role promoted or demoted in the DB changes on the same token (live role); `PATCH` role
  merges a partial permissions map and `[]` removes; web portal access follows permissions.
- Browser, per persona (View, Create, Edit, Archive, Full, Customers Only, Accounting, HR, Roles Admin, No
  Access): the controls shown match the grants on lists, detail pages and direct create/edit URLs; sidebar
  and "No access" pages follow the role; the editor's linked grants, implied View, header column box, limited
  actions, dispatch / quote approval settings and grant limits all behave as designed.
- Three ungated spots found and fixed in this pass: Departments (New Department, department and role cards,
  linked-user actions), quotation detail actions (Duplicate, Mark Won / Lost, Reactivate, Archive / Restore,
  Convert), asset and tool detail (Edit, Add photos; read-only photo card), yard operations (Add New Tool,
  Add to job).
- Role approvals (fixtures: role `QA Gated` needs approval from role `QA Approver`; user
  `qa-access-approver@…`; subjects EMP-QA-92 / 93): a non-approver's request is held PENDING; a
  non-approver sees an empty queue and gets 403 on approve; changing your own role is refused; the approver
  sees Approve and Reject (no Cancel) on both requests, Approve applied the role (RCR-00005, EMP-QA-93 now
  holds it), Reject left the employee without it and stored the note (RCR-00004). Not run: the requester's
  Cancel, the History and My requests tabs, an approver refused for a role beyond their own access.
- Permits and plans (isolated headless Chrome, real login form, profiles view / create / edit / archive / full /
  dispatcher / salescoord / customersonly): permit list and detail controls and the create / edit URLs match the
  grants; a pending permit's workflow buttons (Edit, Mark Application Submitted, Upload Approved Permit) show
  only to edit and full; plans in Draft, Pending and Approved show Edit and Upload Approved Plan only to edit
  and full (Download shows to everyone who can open the plan); the plan create and edit URLs are blocked for
  roles without jobs create / edit; customersonly gets "No access" everywhere. No defects found. Not covered:
  plan Submit / Approve / Reject buttons (none rendered on these plans for any profile), plan comments, the
  Planning Tracker row actions, the plan edit page with a real plan code.
- Re-checked in Claude in Chrome (profiles view / create / edit / archive / full / customersonly): permit and
  plan controls and URLs, same results as the headless run.
- Employee picture: the web form shows "Upload photo" to anyone who can open the employee form, but the API
  allowed only portal admins, so an Edit-only user got a 403 on upload (seen in Chrome). Changed the API
  (`attachment-photos.service.ts`) so a role with employees Create or Edit, or a portal admin, may change an
  employee's picture. Checked with a corrupt PNG (no S3 write): view and archive-only users 403, edit and
  create users pass the access check; in Chrome the edit user now gets the file-type error instead of the 403,
  the view-only user cannot open the edit form and the detail page has no upload. A real upload (a write to
  the S3 bucket named in the local env) was not run. `contexts/patterns.md` P3 still says employee photos are
  "ADMIN only": Haris to update.
- Found by the developer on local testing and fixed (2026-11-13): project Quotations "New Quotation", job
  Schedule "Edit" and "Make Holdover", job and project Attachments (upload, delete, set expiry), job Additional
  Info save, notes tabs "Add note" on Customers, Employees and Projects. Causes: the job page's edit mode
  depended only on the job's status, not on jobs Edit; `AttachmentsSection` `readOnly` hid only the upload
  zone, so every read-only caller (customers, yards, quotations, employees, jobs, projects) still showed
  delete and set expiry; the shared notes grid had no read-only mode. All three are now permission-aware.
  Checked in headless Chrome across every project and job tab for view / edit / create / dispatcher.
  Project detail and job routes take codes (PROJ-00057, JOB-00067), not UUIDs: earlier project-page scans that
  used UUIDs were 404 pages and did not count.
- Gates: web typecheck, eslint (0 errors), web tests 1053/1053, shared tests 249/249, API departments + utility
  specs 247/247.
- Not covered: mobile; the Playwright suite; drag-and-drop on the DAS and yard boards for a role without edit
  (the API refuses it); the Owner
  "last few modules" question from 2026-11-10.

**Deferred, to do:**
1. **Notifications setting in the role editor.** No section exists. `1b4fb4474` had removed it and
   granted all four `notify-*` groups to every role, which sent payroll admin alerts to every
   user, against Corrina's verified 2026-09-29 decision. This branch stops that (a save leaves the
   groups as the role has them; the seed derives them from permissions as before), but a role
   created in the editor starts with none of the four. The Notifications section was restored and
   then removed again at the developer's request, so the setting still needs building.
2. **Hidden fields (field-level access).** Nothing grants per field: SSN, payroll information and
   "numbers" are visible to any role that opens the module. TCG gave no field list and
   CodingCops called it a later layer. Asked in `vault/admin/gaps.md` → *Field-level access
   inside a module*; the asset equivalent (VIN, plate) is in `vault/assets/gaps.md`. Not started.
3. ~~Restricted-role check~~ — done 2026-11-13 with the QA personas (see above).

**Waiting on TCG (G1):** three behaviours nobody specified — linked View grants, hiding modules
and actions nothing enforces, per-action toggles instead of the four levels shown on 2026-10-21.
Entry: `vault/admin/gaps.md` → *Role editor behaviour nobody specified*. What each role may do
(TCG-237 Q5) is still unwritten, so seeded defaults are a labelled workaround.

**Not swept:** ungated write controls on other detail pages and inline controls (plan approval
actions, tool activity card, dylen-dashboard "Add New Tool", payroll managers, department role
cards, quotation sales actions, inner form rows). Open decision: add `purchase-orders` to the
API's `ASSET_CATEGORIES_READ`, then drop the Purchase Orders → Asset Management link.

Next: build item 1 or 2 when picked up; run `review-pr`; open the PR with the AI-decisions table.
