# State — TCG-241

- **Intent:** done (intent.md, 2026-10-20)
- **Spec:** signed off 2026-10-20 by Akif; all §12 questions resolved (Q13 → A); decisions D1–D13, D1a, D1a-null, D8b, G-A…G-G recorded
- **Units:** done, 10 units (units.md, 2026-10-20)
- **U1:** built 2026-10-20 on `feat/TCG-241-u1-entity-image-schema` (enum renamed `ImageOwnerType`, D1a-enum); gates green (lint, api+shared build, prisma.service spec 6/6, api tests 3167/3167, migration = schema diff); guardian on real diff: no leak, no deviation; 100 source lines / 4 files; uncommitted
- **U1 analyst (2026-10-20):** ship with follow-ups — ready to commit; follow-ups: MB vs MiB reading of limits (asked Akif), api test baseline on clean main not recorded (post-change run 3167/3167 green)
- **Stack:** linear U1→U10 (Akif 2026-10-20)
- **U1 committed:** client `68b9296bd` on `feat/TCG-241-u1-entity-image-schema` (not pushed); limits stay MiB (Akif 2026-10-20, option A)
- **Next:** U2 `feat/TCG-241-u2-upload-asset-photo` stacked on U1
