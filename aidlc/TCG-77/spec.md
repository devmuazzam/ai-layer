# TCG-77 Ticket emails: job site address missing or may pick the wrong one

## 12. Open Questions

- **Status:** open
  **Question:** Can a job site actually hold more than one address?
  **Context:** Currently, the system doesn't allow it. If the answer is "no," the long-term correct fix might be adding a unique constraint on `jobSiteId` in the database, instead of just an `isPrimary` flag.

- **Status:** open
  **Question:** Should the job-site address follow the agency precedent?
  **Context:** For agencies, the address fields were moved directly onto the `Agency` entity instead of using the polymorphic `Address` table. Should we do this for `JobSite` as well?

- **Status:** open
  **Question:** Are we adding an `isPrimary` flag for Job Sites?
  **Context:** If yes, we need to update the creation code to set `isPrimary: true, addressType: 'JOB_SITE'` and write a backfill. If not, the `isPrimary` check is technically a no-op, and the oldest-created address (via our new `orderBy`) will be the deterministic fallback doing all the work.

- **Status:** open
  **Question:** Address Formatting (Email vs. Mobile)
  **Context:** The email currently emits `street, city, stateProvince` and drops `zipCode`, while the mobile payload uses a formatter that includes `street2` and `zipCode`. Should we update the email to perfectly match the mobile formatting?
