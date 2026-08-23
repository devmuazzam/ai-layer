---
run: 2026-08-24-bootstrap
tier: CLEAN
pageId: "136740865"
page_title: Sprint 8 report
page_lastModified: 2026-08-19
target: meetings/2026-07-30-sprint-8-report.md
target_status: unverified
target_conflicts_with: []
staged: 2026-08-24
promoted: false
---

# Staged change — Sprint 8 report (CLEAN)

The vault copy ends at "List of Items to do :  83 work items" (captured 2026-08-13, page
state of 2026-08-10). Upstream was edited 2026-08-19. Everything before that line is
unchanged. The addition, verbatim after conversion:

```markdown
Completed work items  :

https://the-crane-guys.atlassian.net/issues/?jql=project%20%3D%20TCG%20AND%20Sprint%20%3D%20233%20AND%20statusCategory%20%3D%20Done%20ORDER%20BY%20resolved%20DESC

62 work items were spilled over to 9th sprint
```

## For the promote step

Two different things arrived in one edit, and the vault's own policy treats them differently:

1. **The "completed work items" is a saved Jira JQL link, not a list.** This is the exact
   defect for which the migration's exclusion policy dropped the Sprint 3–7 reports
   (README → *What this vault does not contain*), and which this file's own migration note
   already flags. Promoting the link adds nothing citable.
2. **"62 work items were spilled over to 9th sprint" is a real, dated fact** and the only
   place it is recorded. It is worth promoting even if the link is not.

Suggested promote: append the spillover sentence (attributed, dated), skip or annotate the
JQL link, keep the existing migration note. Promote as `unverified` per §5.1.1.
