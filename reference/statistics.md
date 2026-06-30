# Website Statistics (สถิติการเข้าชมเว็บไซต์)

## What it does
Shows self-collected traffic stats for the current domain — visitor counts over a date range, broken down by device type and by referral source — rendered as Kendo charts plus tables. The backend landing (Home / CMS Home) embeds a compact version of the same stats card alongside the 3-step setup guide.

## How to get there
- **Sidebar:** Website Settings (ตั้งค่าเว็บไซต์) > Website Statistics (สถิติการเข้าชมเว็บไซต์) — sidebar key `menuSlideBarName.webStatistics`, in `_SlideBarHomeNew.cshtml`.
- **Route (full Statistics page):** `https://demo110.itopplus.com/?manage=true#!/Stats`
  (renders `Management/ViewStatic.cshtml` via `FilesRender/RenderPartial`)
- **Backend landing / Dashboard:** `https://demo110.itopplus.com/?manage=true#!/Dashboard` renders `MainBackend/DashBoard.cshtml`, but that file is only an empty styled card (its `DashBoardController` is a no-op). The real "landing" is the CMS Home (`MainBackend/NewUI/index.cshtml`), reached by clicking CMS Home (`{{menuSettingGereneral.cmsHome}}`) in the top navigator. That landing embeds `viewStat.cshtml` — a compact stats card with the same three tabs.
- The compact home card also has a chart-glyph button that jumps to the full page: `onclick="window.location='./?manage=true/#!/Stats'"`.

## Fields on the screen
There are no editable/save fields — this is a read-only reporting screen. The "fields" are the controls and the data columns shown.

### Controls
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Traffic Acquisition / Website Visit Statistics (สถิติการเข้าชมเว็บไซต์) — tab 1 | Tab (ng-click `ChangeStats(1)`) | Shows a line chart of total visitors per day over the range (`#lineChart`, Kendo). | Home card label is `trafficAcquisition` ("Traffic Acquisition" EN); full-page label is "Website Visit Statistics". Same data either way. |
| Device Traffic / Device Visit Statistics (สถิติอุปกรณ์ที่เข้าชม) — tab 2 | Tab (ng-click `ChangeStats(2)`) | Shows a pie chart (`#PieChart`) + table of visitors by device. | If no data for the range, toastr error "No data recorded for the selected date" (ไม่มีค่าที่ถูกเก็บในวันที่เลือก) and zeroed rows. |
| Referral Traffic / Referral Visit Statistics (สถิติการเข้าชมจากการอ้างอิง) — tab 3 | Tab (ng-click `ChangeStats(3)`) | Shows a table of referrer URLs and their visit counts (each row has an external-link icon to open the referrer). | Donut chart in this tab is commented out; only the table renders. |
| Calendar icon | Image button (ng-click `toggleDatePicker()`) | Toggles the date-range picker box. | — |
| Start Date (วันเริ่มต้น) | Date picker (Kendo `kendo-date-picker`, `k-max="today"`) | Lower bound of the range. | Cannot pick a future date (`k-max="today"`). Default range = last 30 days. |
| End Date (วันสิ้นสุด) | Date picker (Kendo `kendo-date-picker`, `k-max="today"`) | Upper bound of the range. | — |
| Select (เลือก) | Button (ng-click `startPerDate()`) | Re-queries the currently active tab for the chosen range. | Errors via toastr if a date wasn't picked. |
| Close (ปิด) | Button (ng-click `toggleDatePicker()`) | Hides the date picker. | — |

### Device Traffic table columns (tab 2)
| Column (EN / TH) | Notes |
|---|---|
| No. | Row index. |
| Device | Fixed buckets: PC / Windows, PC / Mac, Mobile / iOS, Mobile / Android, Mobile / Windows Phone, Others (อื่นๆ). |
| Total Visitors (ผู้เข้าชมทั้งหมด) | `Device.TotalVisited`; footer row = Total (รวม). New/Returning ("ผู้เข้าชมใหม่/เก่า") columns exist in data but are commented out in the view. |

### Referral Traffic table columns (tab 3)
| Column (EN / TH) | Notes |
|---|---|
| No. | Row index. |
| Referance | Referrer URL (`link.Name`) with an external-link icon. (Header is spelled "Referance" in source.) |
| Total Visitors / Grand Total (รวมทั้งหมด) | `link.New + link.Old`; footer = Total (รวม) from `LinkReferrance.Total.TotalVisited`. |

### Date display
- Default range on open: last 30 days (`moment().subtract(30,'days')` → today).
- Year is shown as Buddhist Era (+543) in Thai mode, Gregorian in English mode. Month names are localized (Thai month array vs. English).
- Language is read from cookie `<DomainID>languageManageBackend` (`'eng'` → English).

## Common tasks

### View visitor traffic for the last 30 days
1. Open `?manage=true#!/Stats` (or click Website Statistics in the sidebar).
2. The Traffic / Website Visit Statistics tab is selected by default and the line chart loads for the last 30 days.

### Change the date range
1. Click the calendar icon (top-right of the stats panel).
2. Pick Start Date and End Date (future dates are blocked).
3. Click Select (เลือก). The currently selected tab re-queries for that range; click Close (ปิด) to hide the picker.

### See device breakdown or referrers
1. Click the Device Traffic tab (pie chart + table) or the Referral Traffic tab (referrer table).
2. Adjust the date range as above if needed.

## Wired in (for developers)
- **View(s):**
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Management/ViewStatic.cshtml` — full `#!/Stats` page (3 tabs + tab 4 hidden Google Ads remnant)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/MainBackend/NewUI/viewStat.cshtml` — compact stats card on the CMS Home landing
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/MainBackend/NewUI/index.cshtml` — CMS Home landing (embeds `viewStat.cshtml`)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/MainBackend/DashBoard.cshtml` — `#!/Dashboard` target; CSS-only empty card, no fields
- **Controller / script:**
  - `ScriptRequire/System/Stats/Controller.js` (`StatsController`) — tabs, date picker, Kendo chart wiring
  - `ScriptRequire/System/Stats/Service.js` (`StatsService`) — `$http` calls to `Stats/*`
  - `ScriptRequire/System/Stats/index.js` — exports controller + service
  - `ScriptRequire/System/DashBoard/Controller.js` (`DashBoardController`) — empty: `App.controller('DashBoardController', function () {})`
  - `Controllers/StatsController.cs` (`StatsController`) — C# endpoints
  - Route registration: `ScriptRequire/MainSystem/Routing/Server.js` (`.when('/Stats', ...)` and `.when('/Dashboard', ...)`)
- **Data endpoints (read-only; AJAX URLs):**
  - `Stats/getstat` (POST) — daily totals for the line chart → `webStatRepo.get30Day`
  - `Stats/getstatPerdate` (POST) — device + referrer breakdown for the range → `webStatRepo.getstatPerdate`
  - `Stats/getCount`, `Stats/GetmaxData`, `Stats/get30` — count/max helpers
  - `Stats/sendStats` (POST) — `webStatRepo.sendAds` (Google Ads tab; tab 4 is commented out in both views)
  - All take a `WebStat` model (`startdate`, `enddate`, `DomainID`), validate the antiforgery token, and require login (`[RequireLogin]`).
- **No save endpoint** — there is nothing to save on this screen.

## Gotchas / multi-tenant notes
- Stats are **self-collected**, not Google Analytics or any external analytics SDK. Data comes from the `WebStat` repository → PoolNode → MongoDB, always scoped to `HtmlHelperExtensions.DomainID` server-side, so the screen is per-tenant by construction. No hardcoded-domain logic was found in this feature.
- The full page (`ViewStatic.cshtml`) and the home card (`viewStat.cshtml`) share the same `StatsController` and the same three tabs, but use different labels for tab 1: home card binds `{{menuSettingGereneral.trafficAcquisition}}` ("Traffic Acquisition"), full page hardcodes Razor `isThaiLanguage ? "สถิติการเข้าชมเว็บไซต์" : "Website Visit Statistics"`.
- A 4th tab `setting4` ("Google Ads" / Advert summary, `bindStatHistory`/`sendAds`) exists in markup but its tab trigger is commented out in both views — it is not reachable from the UI.
- `#!/Dashboard` is effectively dead UI: it renders an empty styled card and an empty controller. There is no sidebar link to it; the practical landing page is CMS Home (`index.cshtml`). Treat "the dashboard" as the CMS Home landing with the embedded stats card, not the `/Dashboard` route.
- Thai labels mix two sources: the sidebar/home-card labels come from `ScriptRequire/domains/language/menu-by-language/menu-setting-gerenal.js` (`settingGeneralMenu`) and `menuSlideBarNameByLanguage.js` (`webStatistics`); the full-page labels are inline Razor `isThaiLanguage ? ... : ...` ternaries in `ViewStatic.cshtml`. Note the English label for the home card's tab 1 ("Traffic Acquisition") differs from the full-page tab 1 ("Website Visit Statistics") even though both show the same data.
