---
title: "Brian's post-demo note on craft codes, Samsara, quotes-to-jobs and Oiler/Operator rate derivation — with CodingCops' reply (16 September 2026)"
source: teams-messages/client — Brian Petros to ehtesham.anwar (CodingCops), 2026-09-16 03:37 PKT, after the 2026-09-15 ERP live demo; CodingCops reply by Syed Haris the same day, 19:09 PKT. Two screenshots of Brian's recommended design included
migrated: 2026-09-19
updated: 2026-09-19
status: unverified
conflicts_with: []
jira: []
tags: [module/payroll, module/dispatch, module/assets, module/quotations, kind/source, craft-code, craft-modifier, oiler, operator, union-agreement, samsara, relief, higher-rate, boom, lattice]
entities: [employee, craft-code, craft-modifier, allocation, crew-ticket, asset, quotation, job]
meeting_date: 2026-09-15
---

# Brian's post-demo note and the reply — 16 September 2026

Brian Petros wrote this after the 2026-09-15 ERP live demo
([../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md](../meetings/2026-09-15-erp-live-demo-01-config-to-das-and-quote-vs-dispatch-resources.md)).
It is the note several entries in [gaps.md](gaps.md) cite as *"Brian's written note after the
2026-09-15 demo"*; stored here in full so those entries have a source.

> **Nothing here is decided.** Brian's note is a client's written thinking and his own reading of
> the MLA; the reply is CodingCops describing the build and committing to one small change. The
> five questions at the end are addressed to Corrina Bustos, for the union rep. Open items are
> registered in [gaps.md](gaps.md) — *Higher rate for the day (MLA Art. IV-C)*, *Relief employee
> paid at the relieved employee's rate (MLA Art. III-H.1(a))*, *Same pay as the craft worked with
> (MLA Art. III-C)*, *Is a secondary craft paid only when it is higher than the primary?* and the
> craft-modifier/union update.

## Brian Petros → Ehtesham, 2026-09-16 03:37 PKT

> Hi Ehtesham,
> Things/questions I was thinking about during our meeting today...
>
> **Craft Codes & Craft Modifier Codes**
> Are these created/assigned/associated with a specific Union?
> We only have one Union right now, but I'm thinking would be good to have these codes "tied" to a
> Union... for when/if there is more than one Union.
>
> (Note: there is another thing I would like to mention about these Craft Codes, but will leave to
> the end of this message because it's a long one.)
>
> **Samsara matching with Assets in ERP**
> I think this might be okay, but just checking...
> You mentioned there is a 1-to-1 relationship for "assigning/matching" an asset in the ERP with the
> asset in Samsara...
> ... and then some of the Samsara information gets "pulled" into the ERP.
> A couple of our main cranes do not have the Samsara tracking device installed... the tracking
> device for those cranes are actually installed on the support vehicle that always travels with
> that crane. The tracking device is not installed on those main cranes because it interferes with
> that particular model of crane's electrical system.
> So, not sure how we will do this... just want to get more clarification on what fields/data (that
> is getting "pulled" in from other systems, like Samsara, ADP, etc.)... what fields are "owned" by
> the other systems?... or if there is some type of two-way sync going on.
>
> **Relationship between Quotes and Jobs**
> You mentioned that in the ERP, we could have multiple Quotes for a single Job.
> Currently, in FCC we have the opposite happening...
> ... we don't currently have multiple Quotes for a single Job, but I do see several where there are
> multiple Jobs for the same Quote.
>
> **Operator Craft Code for Oiler**
> Need to clarify the functionality exactly needed for Corrina on this, but these are my thoughts so
> far...
> You showed us that an Operator code can be selected on the Oiler employee screen.
> However, I'm thinking that is not the ideal design/placement for the alternative code/rate to be
> used.
>
> This is really getting into the details of the Labor Union requirements.
> Below are more details in the Labor Union contract that specify these types of "rate changes".
>
> The agreement has several different higher-rate rules, some of which apply to Oilers and some of
> which can apply to other employee types.
>
> **1. The normal Oiler and Operator rates are intentionally different**
> Article IV establishes separate classifications:
>
> Group 1: Oiler, 80 tons and under.
> Group 2: Oiler, over 80 tons.
> Groups 3–9: Operator rates based primarily on crane capacity/type.
>
> So under the normal classification table, the Oiler does not automatically inherit the Operator's
> wage group.
> Article IV-B also explicitly describes the crew as an Engineer-Operator and Engineer-Oiler, with
> the Oiler under the Operator's direct supervision.
>
> **2. The Oiler's rate can depend on the particular job**
> There are definitely job-specific relationships between the Operator and Oiler.
>
> For example, the long-boom provision says that when the Operator receives the $0.75 long-boom
> increment, the Oiler receives $0.25.
> For Group 6-and-above lattice-boom cranes, the Operator receives an additional $1.00/hour and the
> Oiler receives $0.50/hour.
>
> That means the ERP needs to understand something like:
> Job → Crane → Operator assignment → Oiler assignment
>
> rather than merely:
> Employee → permanent Operator wage code
>
> You may still want the actual Operator employee linked to the Oiler because the agreement
> explicitly treats them as an operating crew, and certain relief or crew-specific situations depend
> on who is actually performing which role.
>
> **3. There is one very clear "same rate as another employee" rule**
> Article III-H.1(a) contains a much more explicit rate-matching requirement.
>
> When an employee has worked more than 16 hours without an 8-hour break and the Employer determines
> that continuing creates a safety issue, a replacement employee may be called in.
>
> The agreement says the relieving employee(s):
>    *"shall be paid at the same rate of pay as the relieved employees at the time of relief for all
>    hours worked on the job."*
>
> That rule is not limited to Oilers. It says employee(s).
>
> So the ERP really needs a generalized concept such as:
>
> RateSourceType
> ---------------------------
> STANDARD_CLASSIFICATION
> RELIEVED_EMPLOYEE_RATE
> HIGHER_JOB_RATE
> CRAFT_RATE
> MANUAL_CONTRACT_RATE
>
> rather than a single special-purpose OilerGetsOperatorRate checkbox.
>
> **4. There are other employees besides Oilers who can be at higher classifications/rates**
> Based on the agreement, I would not design this functionality as an "Oiler only" feature.
>
> Several other scenarios/examples exist...
>
> Mobile tower cranes require an operating crew of two Journeyman Engineer-Operators. So the second
> crew member isn't an Oiler being bumped to Operator pay... contractually, that person is an
> Operator.
> (special note... What is "Journeyman"?... all field employees are considered "Journeyman" except
> for the "Apprentice"... so a field employee who is not a "Journeyman" is an "Apprentice".)
>
> The agreement also allows covered employees to be temporarily used to operate certain equipment.
> Their appropriate classification/rate therefore needs to follow the work they are actually assigned
> to perform rather than simply their normal employee classification.
>
> And, as noted above, relief employees can inherit the relieved employee's rate.
>
> (I think this particular rule below is related to our employees working with a crew member that is
> covered under another Labor Union contract, but not sure...)
> There's also Article III-C, which says employees covered by this agreement receive the same pay as
> the craft they are working with if that craft's agreement is more advantageous. That appears to
> address work with another building-trades craft rather than the normal Operator/Oiler pairing, so I
> would implement that as a separate craft-rate override, not as the basis for Oiler-to-Operator
> matching.
>
> **5. Another important rule: higher rate can follow the employee for the day**
> Article IV-C states:
>    *"When employees ... are employed at a higher rate of pay than the minimums established herein,
>    during any one calendar day, the higher rate of pay shall apply on all time worked during that
>    day..."*
>
> with the stated exception for the long-boom provision in IV-B-2. Article III-I.5 contains similar
> higher-rate language concerning time worked on that job during the day.
>
> Suppose an employee normally earns an Oiler classification rate but legitimately performs
> higher-classification work on part of the day.
> You may need a daily higher-rate propagation step after determining the underlying job assignments.
>
> In other words:
> Step 1: Determine correct classification for each labor/job segment.
> Step 2: Determine contractual premiums/overrides.
> Step 3: Determine highest applicable contractual rate reached that day.
> Step 4: Apply the higher-day rule where required.
> Step 5: Apply ST / OT / DT classification and payroll multipliers.
>
> Long-boom needs special treatment because the agreement specifically says that telescopic long-boom
> pay applies to time actually worked at the higher rate, subject to the four-hour guarantee, rather
> than automatically converting the entire day.
>
> Some ideas of what this might look like...
> *(two screenshots — transcribed below)*
>
> Basically...
> Ideally, we would have a generalized job-level Crew Assignment + Rate Derivation system, where the
> ERP can determine:
>
> employee's normal classification → role on this job → equipment classification → associated crew
> member where relevant → contractual rate override → daily higher-rate rule.
>
> That structure matches the agreement much better and accommodates Oilers, second Operators, relief
> employees, temporary higher classifications, and future rate-matching rules without creating a
> separate hard-coded exception every time.
>
> And these are some questions for Corrina to consider asking our Labor Union rep to help us make
> sure we implement properly...
>
> Exactly when is an Engineer-Oiler entitled to the Operator's rate instead of the Group 1/Group 2
> Oiler rate?
> Is the Oiler supposed to receive the contractual Operator classification rate for that crane, or
> the actual Operator employee's individually higher wage?
> If the Operator has long-boom, shift, hazard, or another premium, does "same rate" include those
> premiums or only the Operator's base classification?
> Does the rule apply for the entire job, the entire calendar day, or only the hours performing the
> qualifying work?
> Are there any other classifications (assembly employees, additional Operating Engineers, relief
> crew, second Operator, etc.) that must similarly inherit another employee's rate?

## Brian's screenshots — "My recommended ERP design"

[Screenshot 1](assets/2026-09-16-brian-recommended-erp-design-crew-assignment.png) ·
[Screenshot 2](assets/2026-09-16-brian-primary-operator-assignment-id.png). Transcribed:

> **My recommended ERP design**
>
> I would keep the employee screen, but change the meaning of the current **Operator Code**.
>
> At the **Employee level**, maintain qualifications/defaults:
> - Normal classification: Operator, Oiler, Repairman, etc.
> - Operator certifications.
> - Crane types/capacities employee is qualified to operate.
> - Normal/default wage classification.
> - Union/local.
>
> That information answers **"What is this employee qualified to do?"**
>
> Then put the payroll-driving information on the **job/crew assignment**:

| Field | Example |
| --- | --- |
| Job | 12345 |
| Crane | Liebherr LTM 1350 |
| Crane capacity | 350 ton |
| Employee | John Smith |
| Crew role | Oiler |
| Primary Operator | Bob Jones |
| Contract classification | Oiler Group 2 |
| Operator classification | Group 7 |
| Rate-source rule | Standard Oiler |
| Long boom | Yes |
| Lattice boom | Yes |
| Relief assignment | No |
| Higher-rate override | None |

> The payroll calculation should then derive the rate from that information.

And the second screenshot:

> I would make `PrimaryOperatorAssignmentID` available for an Oiler because that creates a clean,
> auditable pairing:
>
> ```
> Job
>  └── Equipment
>       ├── Operator Assignment
>       │     └── Operator wage classification
>       │
>       └── Oiler Assignment
>             └── linked to Operator Assignment
> ```
>
> That will also help you with other ERP functionality beyond payroll—crew requirements,
> qualifications, dispatch, crane setup, safety, and reporting.

## CodingCops reply — Syed Haris, 2026-09-16 19:09 PKT

> Hi Brian Petros,
> Thanks for the detailed write-up. Quick clarification on the Operator code you saw on the Oiler
> screen, because I think the demo only showed half of it.
>
> That code is not a permanent Operator wage code on the employee, and it is not an Oiler-only
> feature. It works the way you described in your note:
>
> At the employee level we only store qualifications. The primary craft is the normal classification
> (Oiler Group 1 or 2). The Operator code is a secondary craft, which just means this Oiler is
> allowed to be seated as an Operator. By itself it has no effect on payroll.
>
> The rate is decided on the job assignment. When dispatch seats the employee in an Operator slot,
> that allocation is paid under the secondary craft. Seated as an Oiler, it is paid under the
> primary. The employee never picks this. This follows the rule you and Kyle agreed on the 13 Aug
> call: the secondary applies when it is the higher rate, so there is a floor at the employee's own
> rate and never a step down.
>
> The same mechanism covers any employee working at a higher classification. A second Operator on a
> tower crane is just two Operator seats, and a covered employee temporarily on other equipment is
> paid under whatever craft that seat carries.
>
> Long boom and lattice are configured on the job with separate Operator and Oiler amounts (lattice
> gated to Group 6 and above, long boom on boom hours only with the 4-hour minimum). The Oiler and
> Operator also share one crew ticket, so the Job to Crane to Operator to Oiler chain is already
> there in the data.
>
> There are three items in your feedback that we have not discussed in any of our sessions yet, and
> all three need Corrina Bustos read before we scope them:
>
> Higher rate for the day (IV-C). It is on our rule list from the contract but we never walked
> through it. Your 5-step ordering matches how we would build it, with the true-up after premiums and
> long boom excluded.
> Relief employee paid at the relieved employee's rate (III-H). Not discussed before.
> Same pay as the craft worked with (III-C). Not discussed before, and I agree it should be a
> separate override.
>
> Can we put these as well on the next payroll call?
>
> Also craft codes are already tied to a union. Every craft code carries a required union code, and
> that union code decides where the base rate comes from (union crafts read the union rate table,
> non-union crafts read the employee's own hourly rate). So a second union would get its own set of
> craft codes with their own rate tables, and nothing on the employee or the job would need to
> change.
> Craft modifiers are not tied to a union today. They are one table per company. You are right that
> they should follow the union the same way the craft codes do, since a second agreement would almost
> certainly have its own brackets and amounts. It is a small change and we will add the union link on
> the modifiers.

## Points in the note with no entry of their own

Recorded here so they are not lost; none is registered as an open question yet.

- **Samsara ownership and two-way sync.** Brian asks which fields the ERP pulls from Samsara and
  ADP, which system owns them, and whether anything syncs both ways. He also reports that **a
  couple of main cranes have no tracker** — it sits on the support vehicle that always travels with
  the crane, because the device interferes with that crane model's electrical system. A reply was
  drafted on 2026-09-17 with the Samsara-side counts (79 tracked units; 11 cranes matched) and four
  questions back about which cranes and which support vehicles. Not yet a gaps entry.
- **Quotes and jobs, which way the many-to-one runs.** The demo said many quotes → one job. Brian
  says FCC shows the opposite: **several jobs against one quote**, and no case of many quotes on one
  job. Nobody has said which the ERP should support.
- **"Journeyman" defined by Brian:** every field employee is a Journeyman except an Apprentice.
- **The employee-level qualification set** in his screenshot (certifications, crane
  types/capacities an employee may operate) is a dispatch/compliance concept the vault has not
  scoped.
