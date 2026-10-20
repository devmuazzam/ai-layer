# State — TCG-241

- **Intent:** done (intent.md, 2026-10-20)
- **Spec:** signed off 2026-10-20 by Akif; all §12 questions resolved (Q13 → A); decisions D1–D13, D1a, D1a-null, D8b, G-A…G-G recorded
- **Units:** done, 10 units (units.md, 2026-10-20)
- **U1:** built 2026-10-20 on `feat/TCG-241-u1-entity-image-schema` (enum renamed `ImageOwnerType`, D1a-enum); gates green (lint, api+shared build, prisma.service spec 6/6, api tests 3167/3167, migration = schema diff); guardian on real diff: no leak, no deviation; 100 source lines / 4 files; uncommitted
- **U1 analyst (2026-10-20):** ship with follow-ups — ready to commit; follow-ups: MB vs MiB reading of limits (asked Akif), api test baseline on clean main not recorded (post-change run 3167/3167 green)
- **Stack:** linear U1→U10 (Akif 2026-10-20)
- **U1 committed:** client `68b9296bd` on `feat/TCG-241-u1-entity-image-schema` (not pushed); limits stay MiB (Akif 2026-10-20, option A)
- **U2 build:** [x] built 2026-10-20 on `feat/TCG-241-u2-upload-asset-photo` (stacked on U1), uncommitted. Q14/D14 A (photo `UPDATED` log + web sentence branch), Q15 (timeout 300 s), Q16 `{ id }` applied. Gates: lint 0 errors (api/web/shared), shared+api+web build pass, web typecheck pass, api tests 3193/3193, web 956/0, shared 174/0. Size 598 source lines / 21 files vs U1 — D16 A, Akif adds `size-exception`.
- **U2 (2026-10-20):** built; analyst F1 fixed by Akif's D17 (cap 25 MB), F2 fixed (asset's tenant used for upload, D18); gates green after fixes (build api/web/shared, lint, web typecheck, api 3193/3193, web 956/0, shared 174/0); uncommitted; PR needs `size-exception` (D16)
- **U2 committed:** client `82aa45630` on `feat/TCG-241-u2-upload-asset-photo` (not pushed)
- **Next:** U3 `feat/TCG-241-u3-asset-photo-tiles` stacked on U2
