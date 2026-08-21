---
title: Boom/craft-modifier pay defaults from crane job configuration, field can override with a flagged reason
source: meeting transcripts "TCG ERP System" 2026-08-04 (lattice/boom origin discussion) and 2026-08-13 (craft-modifier configuration walkthrough)
decided: 2026-08-13 (building on the 2026-08-04 discussion)
decided_by: Joe Schacatano (TCG) set the core principle on 2026-08-04 ("it should be tied to the asset... not triggered from the salesperson"); Corrina Bustos, Kyle Harlow and Melissa McNutt confirmed the crane-configuration + override flow on 2026-08-13; Ehtesham Anwar (Codingcops) confirmed the ERP design.
status: verified
resolves: []
topics: [payroll, boom, craft-code, craft-modifier, crane-configuration, dispatch]
entities: [craft-modifier, crane-unit, job-ticket, dispatch]
---

# Decision

**Boom/craft-modifier eligibility is driven by what the job's crane is configured to support,
not by what the salesperson types in.** The available modifier options for a job are constrained
by the crane's own configuration; the modifier defaulted onto a ticket comes from the job setup;
a field employee can change it, but a change is flagged for payroll/crane-super review rather
than accepted silently.

## Why "tied to the asset," not the salesperson (2026-08-04)

The original ambiguity: should boom/lattice eligibility be set by the salesperson at quote time,
or derived from what crane gets dispatched? Joe Schacatano settled it
(`.ai/vault/meetings/transcripts/2026-08-04-payroll-process.md`, ~55:45):

> "It should be tied to the asset that's selected to the job, and then that would trigger this.
> You do not want it triggered from the salesperson on the information they put in. It should be
> what they're dispatched to, which is tied to the asset."

He drew the corresponding boundary for **boom pay** (footage-based, distinct from the
lattice/crawler-crane premium) in the same breath (~56:06):

> "Boom pay is different. If boom pay is set in a job and a salesperson puts 100 foot of boom,
> and then the employee fills out a time sheet and they're clicking boom pay, whatever, they're
> putting 120 feet, at that point it should ping an alert that there's a 20 foot discrepancy, and
> then we look at it. ... However, if there's never a discrepancy, then it would process normal."

Melissa McNutt confirmed the crane configuration is where this originates (~53:11): "when we set
up the job, the crane configuration, the salesman will put if it's if we're using lattice or
not," and that eligibility is further gated by the person's role on the job, not just the crane:
"I think if they're qualified or defined as a third man, that the boom pay doesn't become an
option for them on the labor side."

## The configure-then-override flow (2026-08-13)

Ehtesham described the mechanic the ERP implements
(`.ai/vault/meetings/transcripts/2026-08-13-payroll-process.md`, ~1:00:19):

> "My idea is that we configure it beforehand and then field employees can change it. That way,
> for example, field employees will see the same, like for example, someone selected one-on-one.
> In the job, it was configured, field employees see automatically filled in 101, and if the
> configuration changed on the job, this change, they give us the reason it gets flagged so that
> Corrina can review and maybe Crane Super can review as well."

Corrina confirmed the crane itself bounds the option set (~59:53):

> "And is it also set in the cranes in the crane configuration that they'll only have the options
> for as big as their crane allows?" — Ehtesham: "Yeah." Corrina: "Okay, perfect."

Kyle Harlow located this in the unit/asset setup specifically, because crew composition can
change independently of the crane (~1:00:00): "You'd have to do that in the unit type for the
job because the crane crew can, the people can move around."

## What this means for the build

1. **Crane/unit configuration** defines the full set of modifier options a given crane can ever
   support (e.g. the boom-length brackets applicable to that unit).
2. **Job setup** picks a default modifier value from that set (what the salesperson/dispatcher
   configures, e.g. planned boom length or lattice use).
3. **The ticket** is pre-filled with the job's configured value.
4. **The field employee can change it**, but any change from the configured default is flagged
   for review by payroll and/or crane super — it is not auto-accepted.
5. Modifier eligibility is also gated by the **role the person is dispatched as on that job**
   (operator/oiler qualify; third man does not) — a rule separately confirmed in the 2026-08-04
   meeting (Corrina, ~52:15: "it might need to be even more granular... only the oiler and the
   operator qualify for it. The third man does not.").

## Where the legacy code stands today (for contrast, not as the design)

The legacy payroll app has none of this structure. Per
`.ai/vault/payroll/legacy-payroll-app-db-extract/calculations.md` §B3.4: "Boom length (feet):
present only as the modifier-code bracket → `PayRateChange` lookup. There is no numeric feet
computation, jib logic, or lattice-specific branch anywhere in the priced path." There is no
crane-configuration source, no default-then-override flow, and no discrepancy-flagging
mechanism — boom eligibility today is simply "does this labor row have a non-empty
`CraftModifierCode`" (§B3.2). The flow described above is new ERP design, not a port.
