# Decision: Job Walk Saved Signature Presigned URL Read Alignment

- **Date:** 2026-11-04
- **Status:** decided
- **Context:** Mobile presigned S3 URL unification audit

## Context & Finding

An audit across all file/image viewing and downloading surfaces in `apps/mobile/` verified that 11 of 12 surfaces had migrated to the unified presigned S3 URL approach (`openStoredAttachment` via `expo-file-system` and `AttachmentImage` via `expo-image`).

The single remaining outlier was the saved signature preview in the Job Walk report editor:
- [`apps/mobile/app/(sales)/job-walk.tsx`](file:///home/codingcops/craneguys-platform/apps/mobile/app/%28sales%29/job-walk.tsx) (`SavedSignature`) called `useJobWalkSignatureImage(attachmentId)`.
- [`apps/mobile/data/hooks/use-job-walk-reports.ts`](file:///home/codingcops/craneguys-platform/apps/mobile/data/hooks/use-job-walk-reports.ts) called `services.jobWalkReports.downloadSignature(attachmentId)`.
- [`apps/mobile/data/services/job-walk-reports/job-walk-reports.http.ts`](file:///home/codingcops/craneguys-platform/apps/mobile/data/services/job-walk-reports/job-walk-reports.http.ts) requested `GET /attachments/${attachmentId}/download` with `{ responseType: 'arraybuffer' }`.
- Mobile manually iterated over the ArrayBuffer in 32 KB chunks using `String.fromCharCode` and `btoa` to build a `data:image/png;base64,...` data URI in React Native heap memory.

## Decision

1. **Migrate `downloadSignature` to Presigned Links:**
   - [`job-walk-reports.http.ts`](file:///home/codingcops/craneguys-platform/apps/mobile/data/services/job-walk-reports/job-walk-reports.http.ts): Calls `GET /attachments/:id/links` with `suppressGlobalLoader: true` and returns `data.previewUrl ?? data.url`.
   - Eliminates `responseType: 'arraybuffer'` and binary byte streaming through NestJS.

2. **Remove `toPngDataUri` Base64 Construction:**
   - [`use-job-walk-reports.ts`](file:///home/codingcops/craneguys-platform/apps/mobile/data/hooks/use-job-walk-reports.ts): `useJobWalkSignatureImage` resolves and caches the presigned S3 URL directly (`staleTime: 5 min`).

3. **Direct S3 Rendering with Expiry Refetch:**
   - [`job-walk.tsx`](file:///home/codingcops/craneguys-platform/apps/mobile/app/%28sales%29/job-walk.tsx): Passes the presigned URL directly to `<Image source={{ uri }} />` with `onError={() => void refetch()}` for automatic refresh on link expiry.
