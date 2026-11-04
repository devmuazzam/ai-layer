---
title: Folder map — TCG Project Repository (live SharePoint), 2026-10-20
source: sharepoint/craneguys.sharepoint.com/sites/TCGCodingCopsERPTeam — Documents/Project Repository (the Teams channel's Shared tab)
migrated: 2026-10-20
updated: 2026-10-20
status: reference
conflicts_with: []
jira: []
tags: [module/all, kind/reference, provenance]
entities: []
---

# Folder map — Project Repository, 2026-10-20

**What this is.** The client's live **Project Repository** folder tree (Teams → *TCG CodingCops ERP
Team* → *Project Repository* → *Shared*). It records **folder names only**, with the number of files
sitting directly in each folder. Use it to find where something lives on SharePoint, or to cite a
location. **No file was read, downloaded or migrated in this capture.** What happened to the files
from the earlier drop is in [project-repository-2026-09-04.md](project-repository-2026-09-04.md),
and their names are in [project-repository-2026-09-04-file-inventory.md](project-repository-2026-09-04-file-inventory.md).

**How it was captured.** 2026-10-20, an AI session run for Syed Haris, through read-only SharePoint REST calls
(`GetFolderByServerRelativePath` → `Folders`, `Files`) from a signed-in browser. Every
folder's subfolder count was checked against the children captured: 0 mismatches. SharePoint's
library-level `Forms` folder is excluded, as Teams hides it.

**Totals.** 27 top-level folders · 331 folders including the root · 1658 files.
The 2026-09-04 drop was 17 archives and 1,446 files. Folders added since then include
`__Job Schedule Master (from Ryan 2026-08-11)`, `PayrollAPP_2026-09-07` and the two
`CC_FRD-Field-Ops-Mobile-App_*` folders. **This is a snapshot**: anything uploaded after
2026-10-20 is not here.

**Search tips.** `grep -n '<name>'` this file. The city-permit library is under
`3.1.1_MODULE-CRM-SALES-QUOTES/__CITY_PERMIT/copy of all files/<City>/`. A second, partial copy of
it (Oxnard → Upland, one file each) is under `__Job Schedule Master (from Ryan 2026-08-11)/__CITY_PERMIT/`.

## Top-level folders

| Folder | Subfolders (all levels) | Files (all levels) |
| --- | --- | --- |
| `0.0.1_PROJECT-ADMIN` | 0 | 4 |
| `0.1.1_PROJECT-SCHEDULES` | 0 | 1 |
| `0.2.1_MEETING-NOTES` | 0 | 158 |
| `0.3.1_BUDGET-INVOICES` | 0 | 0 |
| `1.0.1_BUSINESS-REQUIREMENTS` | 11 | 76 |
| `1.0.2_FCC-RESOURCES-GUIDES` | 7 | 49 |
| `1.1.1_UX-UI-DESIGN` | 6 | 46 |
| `1.2.1_TECHNICAL-SPECS` | 0 | 4 |
| `2.0.1_DATABASE-SCHEMA` | 1 | 5 |
| `2.1.1_DATA-MIGRATION` | 7 | 39 |
| `2.2.1_QA-TESTING-UAT` | 0 | 1 |
| `2.3.1_RELEASE-NOTES` | 0 | 2 |
| `3.0.1_MODULE-MINDMAP-PLANNING` | 0 | 0 |
| `3.1.1_MODULE-CRM-SALES-QUOTES` | 227 | 1017 |
| `3.2.1_MODULE-WAREHOUSE-STORAGE` | 1 | 13 |
| `3.3.1_MODULE-DISPATCH-JOBS` | 2 | 10 |
| `3.4.1_MODULE-FLEET-MAINTENANCE` | 2 | 37 |
| `3.5.1_MODULE-FIELD-OPERATIONS` | 0 | 0 |
| `3.6.1_MODULE-SAFETY-COMPLIANCE` | 6 | 28 |
| `3.7.1_MODULE-HR-LABOR-PAYROLL` | 12 | 51 |
| `3.8.1_MODULE-ACCOUNTING-AP-AR` | 8 | 30 |
| `3.9.1_MODULE-REPORTING-BI` | 0 | 0 |
| `9.0.1_ARCHIVE` | 0 | 0 |
| `9.9.9_SHARED-RESOURCES` | 0 | 0 |
| `CC_FRD-Field-Ops-Mobile-App_2026-06-11` | 2 | 8 |
| `CC_FRD-Field-Ops-Mobile-App_DEMOs` | 0 | 2 |
| `TCG_Value_Engine_SAMPLES-ONLY` | 11 | 74 |

## Full tree

Each folder shows the files directly inside it. *(empty)* means no files and no subfolders.

```text
Project Repository/ (3 files)
  0.0.1_PROJECT-ADMIN/ (4 files)
  0.1.1_PROJECT-SCHEDULES/ (1 file)
  0.2.1_MEETING-NOTES/ (158 files)
  0.3.1_BUDGET-INVOICES/ (empty)
  1.0.1_BUSINESS-REQUIREMENTS/ (5 files)
    Customer Packet and Labor Compliance Forms/ (2 files)
    FCC_NexGen_MENUS/ (7 files)
    job ticket - time card - equipment checklists/ (3 files)
    TCG_ACCTG_PURCHASE_ORDERS (draft SOPs)/ (7 files)
    TCG_FORMS_(paper_and_electronic)/ (21 files)
      from Melissa 2026-04-02/ (9 files)
    TCG_PRICE_LISTS/ (1 file)
    TCG_QUOTES/ (3 files)
      SAMPLE_QUOTE/ (3 files)
    WORKFLOWS_VALUE_ENGINES/ (9 files)
      IMAGES_OF_NOTES/ (6 files)
  1.0.2_FCC-RESOURCES-GUIDES/ (2 files)
    FCC_YouTube/ (5 files)
    FCC-IMPORT-Templates/ (5 files)
    FCC-USER-GUIDES/ (15 files)
      OneDrive_2025-10-29/ (14 files)
    QB_Connector/ (6 files)
      QB Table Audit Reports/ (2 files)
    TCG-Purchase Orders/ (empty)
  1.1.1_UX-UI-DESIGN/ (2 files)
    Figma Designs as of 2026-03-16/ (4 files)
      FCC_NexGen_MENUS/ (7 files)
    Logos-Pictures-Icons/ (15 files)
      TCG Virtual Backgrounds/ (9 files)
        TCG Virtual Backgrounds Reversed/
          TCG Virtual Backgrounds Reversed/ (9 files)
  1.2.1_TECHNICAL-SPECS/ (4 files)
  2.0.1_DATABASE-SCHEMA/ (4 files)
    FCC-NexGen SCHEMA/ (1 file)
  2.1.1_DATA-MIGRATION/ (4 files)
    NexGenFMS_for_ERP/ (5 files)
      __VS_CODE_DataMigration/
        __SQL_FCC_DATABASE/ (7 files)
        SQL_FCC_CORE_TABLES/
          CUSTOMERS/ (8 files)
          EMPLOYEES/ (9 files)
          UNITS-ASSETS/ (6 files)
  2.2.1_QA-TESTING-UAT/ (1 file)
  2.3.1_RELEASE-NOTES/ (2 files)
  3.0.1_MODULE-MINDMAP-PLANNING/ (empty)
  3.1.1_MODULE-CRM-SALES-QUOTES/
    __CITY_PERMIT/ (1 file)
      copy of all files/
        Adelanto/ (10 files)
        Agoura Hills/ (1 file)
        Alhambra/ (17 files)
        Aliso Viejo/ (11 files)
        Anaheim/ (1 file)
        Arcadia/ (3 files)
        Arleta/ (1 file)
        Azusa/ (16 files)
        Bakersfield/ (6 files)
        Banning/ (1 file)
        Barstow/ (2 files)
        Beaumont/ (2 files)
        Bell/ (2 files)
        Bell Gardens/ (1 file)
        Bellflower/ (3 files)
        Bishop/ (1 file)
        Brea/ (12 files)
        Buena Park/ (11 files)
        Burbank/ (10 files)
        Buttonwillow/ (1 file)
        Calabasas/ (2 files)
        Caltrans/ (1 file)
        Camarillo/ (3 files)
        Cathedral City/ (11 files)
        Chino/ (1 file)
        Chino Hills/ (2 files)
        Colton/ (8 files)
        Compton/ (12 files)
        Corona/ (14 files)
          Claremont/ (10 files)
        Costa Mesa/ (15 files)
        Covina/ (11 files)
        Culver City/ (12 files)
        Cypress/ (1 file)
        Dana Point/ (1 file)
        Diamond Bar/ (10 files)
        Downey/ (10 files)
        Duarte/ (10 files)
        Eastvale/ (2 files)
        El Cajon/ (3 files)
        El Centro/ (1 file)
        El monte/ (1 file)
        Fillmore/ (1 file)
        Fontana/ (2 files)
        Fountain Valley/ (7 files)
        Fullerton/ (18 files)
        Garden Grove/ (4 files)
        Gardena/ (9 files)
          140 ton crane/ (2 files)
          200 ton crane/ (1 file)
          265 ton crane/ (1 file)
          40 ton Crane/ (2 files)
          60 Ton crane/ (1 file)
          90-100 ton crane/ (2 files)
        Glendale/ (1 file)
        Glendora/ (1 file)
          140 ton/ (2 files)
          200 ton/ (1 file)
          265 ton/ (1 file)
          40 ton/ (1 file)
          60 ton/ (1 file)
          90-100 ton/ (1 file)
          Glendora permit/ (1 file)
        Goleta/ (3 files)
        Hawthorne/ (1 file)
        Hemet/ (2 files)
          Hemet annual application/ (1 file)
          Hemet single permit/ (2 files)
        Hermosa Beach/ (2 files)
        Hesperia/ (6 files)
        Highland/ (2 files)
        Huntington Beach/ (1 file)
        Huntington park/ (1 file)
        Indian Wells/ (2 files)
        Inglewood/ (10 files)
        Inspection reports for cranes/ (24 files)
        Inyo county/ (4 files)
        Irvine/ (1 file)
        Irwindale/ (6 files)
        Kern County/ (3 files)
        La Canada Flintridge/ (14 files)
        La Habra/ (7 files)
        La Palma/ (2 files)
        La Puente/ (1 file)
        La Quinta/ (1 file)
        La Verne/ (1 file)
        Laguna Beach/ (2 files)
        Laguna Hills/ (4 files)
        Laguna Niguel/ (1 file)
        Laguna Woods/ (3 files)
        Lake arrowhead/ (1 file)
        Lake Elsinore/ (1 file)
        Lake Forest/ (7 files)
        Lake Isabella/ (1 file)
        Loma Linda/ (2 files)
        Los Alamitos/ (23 files)
        Mammoth lakes/ (1 file)
        manhattan Beach/ (1 file)
        mission viejo/ (5 files)
        Monrovia/ (6 files)
        Montebello/ (1 file)
        Montecito/ (1 file)
        Monterey Park/ (10 files)
        Montrose/ (1 file)
        Moreno valley/ (1 file)
        Murrieta/ (1 file)
        Norwalk/ (11 files)
        Ojai/ (1 file)
        Ontario/ (7 files)
        Orange/ (7 files)
        orange county/ (12 files)
        Oxnard/ (12 files)
        Palm Desert/ (10 files)
        Palm Springs/ (10 files)
        Palos Verdes Estates/ (3 files)
          140 Ton crane/ (2 files)
          200 Ton Crane/ (1 file)
          265 Ton Crane/ (empty)
          40 ton crane/ (2 files)
          60 ton crane/ (1 file)
          90 and 100 Ton Crane/ (2 files)
        Pasadena/ (1 file)
        Perris/ (1 file)
        Placentia/ (11 files)
        Pomona/ (13 files)
        Rancho Cucamonga/ (1 file)
        Rancho Mirage/ (10 files)
        Rancho Palos Verdes/ (3 files)
        Rancho Santa Margarita/ (13 files)
        Redlands/ (15 files)
        Redondo Beach/ (2 files)
        Rialto/ (5 files)
        Riverside City/ (17 files)
        Riverside County/ (7 files)
        Rolling hills/ (2 files)
        San Bernardino/ (16 files)
        San Bernardino County/ (2 files)
        San Clemente/ (11 files)
        San Diego/ (1 file)
        San Dimas/ (empty)
        San Gabriel/ (12 files)
        San Jacinto/ (10 files)
        San Juan Capistrano/ (10 files)
        Santa Ana/ (3 files)
        Santa Barbara/ (2 files)
        Santa Clarita/ (12 files)
        Santa Monica/ (1 file)
        Santa Paula/ (10 files)
        Seal Beach/ (12 files)
        Self Loader/ (1 file)
        Self Loader oversize applications/ (5 files)
        Sierra Madre/ (12 files)
        Simi Valley/ (7 files)
        South Pasadena/ (10 files)
        Stanton/ (12 files)
        Temple city/ (2 files)
        Thousand Oaks/ (5 files)
        Torrance/ (1 file)
        Trona/ (1 file)
        Tulare/ (2 files)
        Tustin/ (3 files)
        Upland/ (9 files)
        Ventura/ (1 file)
        Vernon/ (6 files)
        Victorville/ (1 file)
        villa park/ (1 file)
        Visalia/ (1 file)
        Westminster/ (11 files)
        Whittier/ (15 files)
        Windors Hills/ (1 file)
        Yorba Linda/ (9 files)
        Yucaipa/ (2 files)
        Yucca Valley/ (2 files)
          140 ton/ (2 files)
          265/ (1 file)
          40 ton crane/ (2 files)
          60 ton/ (1 file)
          90 &100/ (1 file)
    __ERP_Sales Process (from Ryan 2026-08-06)/ (70 files)
    __Job Schedule Master (from Ryan 2026-08-11)/ (4 files)
      __CITY_PERMIT/
        Oxnard/ (1 file)
        Palm Desert/ (1 file)
        Palm Springs/ (1 file)
        Palos Verdes Estates/ (1 file)
        Pasadena/ (1 file)
        Perris/ (1 file)
        Placentia/ (1 file)
        Pomona/ (1 file)
        Rancho Cucamonga/ (1 file)
        Rancho Mirage/ (1 file)
        Rancho Palos Verdes/ (1 file)
        Rancho Santa Margarita/ (1 file)
        Redlands/ (1 file)
        Redondo Beach/ (1 file)
        Rialto/ (1 file)
        Riverside City/ (1 file)
        Riverside County/ (1 file)
        Rolling hills/ (2 files)
        San Bernardino/ (1 file)
        San Bernardino County/ (1 file)
        San Clemente/ (1 file)
        San Diego/ (1 file)
        San Gabriel/ (1 file)
        San Jacinto/ (1 file)
        San Juan Capistrano/ (1 file)
        Santa Ana/ (1 file)
        Santa Barbara/ (2 files)
        Santa Clarita/ (1 file)
        Santa Monica/ (1 file)
        Santa Paula/ (1 file)
        Seal Beach/ (1 file)
        Sierra Madre/ (1 file)
        Simi Valley/ (1 file)
        South Pasadena/ (1 file)
        Stanton/ (1 file)
        Temple city/ (1 file)
        Thousand Oaks/ (1 file)
        Torrance/ (1 file)
        Trona/ (1 file)
        Tulare/ (1 file)
        Tustin/ (1 file)
        Upland/ (1 file)
    Copy of Sales Commissions Process/ (2 files)
    CraneConfigurationExamples/ (2 files)
  3.2.1_MODULE-WAREHOUSE-STORAGE/ (3 files)
    2026-04-22_videos from Dylan/ (10 files)
  3.3.1_MODULE-DISPATCH-JOBS/ (1 file)
    DISPATCH Crane Configurations/ (5 files)
    DISPATCH Technical Specs/ (4 files)
  3.4.1_MODULE-FLEET-MAINTENANCE/
    CRANE LOAD CHARTS/
      from Ryan (2026-06-30)/ (37 files)
  3.5.1_MODULE-FIELD-OPERATIONS/ (empty)
  3.6.1_MODULE-SAFETY-COMPLIANCE/ (2 files)
    Safety FORMS/ (4 files)
    Safety Module Ideas/ (2 files)
    Safety_Incident Report & Investigation forms/ (4 files)
    Safety-All Operator Job Forms/ (13 files)
    Sample Contract with Safety Items/ (2 files)
    SoCal Edison Contractor Orientation and Safety Plan/ (1 file)
  3.7.1_MODULE-HR-LABOR-PAYROLL/ (10 files)
    __CC_TCG_ERP_PAYROLL_RULES/ (3 files)
    ADP Integration Sync/ (4 files)
    MCOG LABOR UNION L12/ (5 files)
    PAYROLL for ADP v3.0 - old/ (5 files)
    PAYROLL for ADP v5.1 - current/ (3 files)
      __VS_CODE_Payroll for ADP/ (1 file)
    PAYROLL_APP_build/ (5 files)
      ADP-specific_files/ (4 files)
      L12_Union-Labor-Agreements/ (2 files)
      PayrollAPP_2026-06-23/ (4 files)
      PayrollAPP_2026-09-07/ (1 file)
    PAYROLL_CURRENT/ (4 files)
  3.8.1_MODULE-ACCOUNTING-AP-AR/ (20 files)
    AR - Billing Processes/
      Ariba/ (2 files)
      LADWP (LA Dept of Water and Power)/ (1 file)
      LAUSD (LA Unified School District)/ (2 files)
      SCE (SoCal Edison)/ (1 file)
      Standard Billing/ (2 files)
    Bank Deposit/ (1 file)
    PO - AP SOP/ (1 file)
  3.9.1_MODULE-REPORTING-BI/ (empty)
  9.0.1_ARCHIVE/ (empty)
  9.9.9_SHARED-RESOURCES/ (empty)
  CC_FRD-Field-Ops-Mobile-App_2026-06-11/ (3 files)
    BRS References/ (3 files)
      L12_Union-Labor-Agreement/ (2 files)
  CC_FRD-Field-Ops-Mobile-App_DEMOs/ (2 files)
  TCG_Value_Engine_SAMPLES-ONLY/ (2 files)
    2026-06-16 samples/ (5 files)
      TCG Dispatch - VALUE ENGINES and PLAYBOOKS/ (9 files)
      TCG IT - VALUE ENGINES and PLAYBOOKS/ (11 files)
      zzzOTHER/ (5 files)
        FLOWCHARTS_VALUE_ENGINES/ (15 files)
          IMAGES_OF_NOTES/ (6 files)
            VS_CODE/
              AI_GENERATION/ (8 files)
              TEMPLATE/ (1 file)
          zz_ARCHIVE/ (3 files)
    2026-06-23 samples/ (9 files)
```
