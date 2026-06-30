# Specialized per-domain modules (โมดูลเฉพาะแต่ละโดเมน)

These are niche modules that are **off by default** and only appear when a per-domain
admin config flag is on (`bImageSpinner`, `bCustomBookingByDate`, `bDigitalBusinessHub`,
`bJewelryManagement`, `bEsim` on `HtmlHelperExtensions.Config`). When the flag is off, the
sidebar link is not rendered and the AngularJS hash route is effectively unreachable. Each is
covered lightly below: what it is, how to reach it, and its key fields.

---

## 1. 360 Image Presentation (360 Image Presentation)

### What it does
Lets a tenant build a 360-degree image **spinner** — upload a sequence of frames under a named
"spinner", tune frame width and rotation speed, preview the spin, and generate an embed `<script>`
snippet to copy. The spinner can also be used as a product/content cover ("Enable 360-degree Cover"
checkbox in ViewContent.cshtml).

### How to get there
- **Sidebar:** new-UI left slide bar (`_SlideBarHomeNew.cshtml`), shown only when `bImageSpinner` is on; link label `360 Image Presentation` (`menuSlideBarName.image360Presentation`, same EN/TH string).
- **Route:** `https://demo110.itopplus.com/?manage=true#!/ImageSpinnerManage`

### Fields on the screen
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Select spinner (กรุณาเลือก Spinner) | dropdown/select | Load an existing named spinner to edit | Disabled until at least one spinner exists |
| Name the spinner (กรุณาตั้งชื่อ Spinner) + Add (เพิ่ม) | text + button | Creates a new spinner record by name | Duplicate names are rejected with a toastr warning |
| Choose file (เลือกไฟล์...) | file/image upload (multiple) | Uploads the frame images for the spin sequence | Posts to `MainManagefile/UploadMultipleFileSet/` |
| Frame width (ความกว้างกรอบรูป) | text input | Sets the viewer frame width | — |
| Rotation speed (ความเร็วหมุนรูป) | range slider (-199..100) | Sets/preview spin speed | live `onChangeSpeedSpinner` |
| code (code) | textarea | Holds the generated embed snippet | Read via "Copy code" |
| images list | repeater/list (read-only) | Shows uploaded frame names | — |
| Delete (ลบ) | button | `removeSpinner()` removes the current spinner | — |
| Generate Spinner | button | `generateSpinScript()` builds the embed code | — |

### Common tasks
#### Create a 360 spinner
1. Type a name under "Name the spinner" and click Add (เพิ่ม).
2. Click Choose file and select the ordered frame images.
3. Adjust Frame width and Rotation speed.
4. Click Generate Spinner, then Copy code to embed.

### Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Views/MainManagefile/ImageSpinnerConfig.cshtml`
- **Controller / script:** `Boy_Growth_a_Man/ScriptRequire/System/Managefile/Controller.js` (`addNewSpinner`, `generateSpinScript`, `removeSpinner`, `initImageSet`)
- **Save endpoint:** `Managefile/saveImageSetByName` (create named spinner) + image upload `MainManagefile/UploadMultipleFileSet/`

### Gotchas / multi-tenant notes
- Gated by `HtmlHelperExtensions.Config.bImageSpinner`; also surfaced on the public side via `ServerData.bImageSpinner` in `_LayoutServer.cshtml`.
- The viewer DOM uses literal ids `jsv-holder-testitopplusparty` / `jsv-image-testitopplusparty` — a leftover test-domain naming, not a per-tenant value (cosmetic, not gating).

---

## 2. Custom Booking By Date (Custom Booking By Date)

### What it does
A lightweight per-tenant booking manager: define bookable "products"/services with service hours and
service days, then view the resulting booking history and (for solar/DeliSci calculator domains)
calculator subscriber lists.

### How to get there
- **Sidebar:** new-UI left slide bar, shown only when `bCustomBookingByDate` is on; link label `Custom Booking By Date` (`menuSlideBarName.customBookingByDate`, same EN/TH).
- **Route:** `https://demo110.itopplus.com/?manage=true#!/CustomBookingByDate` (renders `CustomBookingManagement.cshtml`). The Add/Edit product form **opens as a modal** (`customBookingModal.cshtml`) via the `newCustomProduct(...)` ng-click trigger ("Add product" / "เพิ่มสินค้า", or the wrench icon per row).

### Fields on the screen
Product list / history page (`CustomBookingManagement.cshtml`) is mostly read-only tables (Image/รูป, Item/รายการ, Date added/วันที่ลง, plus a booking-history table and subscriber tables). The editable fields live in the **product modal**:

| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Upload image (อัพโหลดภาพ) | file/image upload | Product cover image | Posts to `../FilesRender/UploadFileServer/` |
| Name (ชื่อ) | text input | Product/service name | — |
| Details (รายละเอียด) | text input | Product description | — |
| Set service hours (กำหนดช่วงเวลาที่ให้บริการ) | text + text + add | Start/end time pair, added to a repeated time list | `addTimeObj`; each row has Edit (แก้ไข) / Delete (ลบ) |
| Set service days (กำหนดวันที่ให้บริการ) | 7 checkboxes | Mon–Sun availability (จันทร์..อาทิตย์) | Default checked |
| Save (บันทึก) | button | `saveCustomBookingProduct()` | — |

### Common tasks
#### Add a bookable product
1. On the Custom Booking page click Add product (เพิ่มสินค้า).
2. In the modal upload a cover image, enter Name and Details.
3. Add one or more service-hour ranges and tick the service days.
4. Click Save (บันทึก).

### Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Views/Management/CustomBookingManagement.cshtml`, `Boy_Growth_a_Man/Views/Management/CustomBookingByDate/customBookingModal.cshtml` (also public component under `Views/Component/CustomBookingByDate/`)
- **Controller / script:** `Boy_Growth_a_Man/ScriptRequire/Component/CustomBookingByDate/Controller.js` + `Service.js` (controller `CustomBookingController`)
- **Save endpoint:** `CustomBookingByDate/saveCustomBookingProduct` (product), `CustomBookingByDate/saveCustomBookingHistory` (booking), plus `getAllCustomBookingProduct` / `delCustomBookingProductById` / `getCustomBookingHistory` / `getSubscriberEmail`

### Gotchas / multi-tenant notes
- Gated by `HtmlHelperExtensions.Config.bCustomBookingByDate`. Also draggable into the layout as component id `34` (sidebar `Custom Booking`).
- `CustomBookingManagement.cshtml` carries two extra subscriber tables hardwired to specific use-cases ("Online solar calculator user list" / "DeliSci Calculator user list", the latter `display:none`) — content tied to particular tenants, not a generic feature surface.

---

## 3. Digital Business Hub (Digital Business Hub)

### What it does
A standalone "link-tree" / digital business card generator: enter a profile, logo, up to 5
icon+label+URL links, a gradient or image background, pick one of three templates, then generate a
QR code or download a self-contained HTML page. Output is generated **client-side** — there is no
server config-save in its Service.

### How to get there
- **Sidebar:** new-UI left slide bar, shown only when `bDigitalBusinessHub` is on; link label `Digital Business Hub` (`menuSlideBarName.digitalBusinessHub`, same EN/TH).
- **Route:** `https://demo110.itopplus.com/?manage=true#!/DigitalBusinessHub`

### Fields on the screen
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Domain name (ชื่อโดเมน) | text input | `mainUrl` of the card | placeholder "Enter profile name" |
| Upload logo (อัพโหลดโลโก้) | file/image upload | `digibusinessHubLogo` | .png/.jpg/.jpeg only |
| Profile name (ชื่อโปรไฟล์) | text input | `profileName` | — |
| Icon 1–5 (ไอคอน) | file/image upload ×5 | `digibusinessImage1..5` | — |
| Display name 1–5 (ชื่อที่ต้องการแสดงผล) | text input ×5 | `linkName1..5` | — |
| URL 1–5 (URL) | text input ×5 | `linkUrl1..5` | — |
| Gradient stops + percents | color picker ×2 + number ×2 | `backgroundColorObj.colorCode1/2`, `colorPercent1/2` | live `setGradient()` |
| Gradient direction | 8 direction buttons | sets gradient angle (`dir1..dir8`) | — |
| Use background image (ใช้รูปภาพพื้นหลัง) | checkbox + file upload | `bUseImageBackground` + `backgroundImage` | upload appears only when checked |
| Template 1 / 2 / 3 | radio-style selection | `selectedTemplate` | click to choose |
| Render! | button | `renderLinkTreeButton()` builds the preview | — |
| Generate QR Code | button | `generateQRCode()` | uses davidshimjs/qrcodejs CDN |
| Download HTML | button | `CopyREALHTML()` downloads the generated page | — |

### Common tasks
#### Build a digital business card
1. Fill Domain name, upload logo, set Profile name.
2. Add up to 5 links (icon + display name + URL).
3. Choose a gradient/background and a template.
4. Click Render!, then Generate QR Code or Download HTML.

### Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Views/Management/DigitalBusinessHubManagement.cshtml`
- **Controller / script:** `Boy_Growth_a_Man/ScriptRequire/Component/DigitalBusinessHub/Controller.js` + `Service.js` (controller `DigitalBusinessHubController`)
- **Save endpoint:** none persisted server-side — output is generated HTML/QR client-side; image uploads go through `./FilesRender/UploadFileServer/`.

### Gotchas / multi-tenant notes
- Gated by `HtmlHelperExtensions.Config.bDigitalBusinessHub`.
- Fixed page width `1300px` (`style="width:1300px"`), not responsive.

---

## 4. Jewelry Management (Jewelry Management)

### What it does
A jewelry-shop product catalog manager with three product types — **Ring**, **Diamond**, **Jewelry** —
each with its own list view and rich add/edit form (4Cs, certificate, grading, measurement for
diamonds; style/metal/shape/category for rings & jewelry). Diamonds can also be bulk-imported from
an Excel file.

### How to get there
- **Sidebar:** new-UI left slide bar, shown only when `bJewelryManagement` is on; link label `Jewelry Management` (`menuSlideBarName.jewelryManagement`, same EN/TH).
- **Route:** `https://demo110.itopplus.com/?manage=true#!/JewelryManagement`. The left in-page menu (Ring / Diamond / Jewelry) switches `objManagement.ProductType`; each "Add ..." button swaps to the create form (no separate hash route).

### Fields on the screen
Ring create form (`RingManagement.cshtml`):
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Product name * | text input | `ringObject.ringName` | required |
| Description | rich-text editor (Kendo) | `ringObject.textDetail` | — |
| Category | checkbox group | Engagement/Wedding/Men's/Couple Rings | toggle dropdown |
| Style * | dropdown | `ringObject.ringStyle` | required |
| Metal * | dropdown | White/Yellow/Rose/Light Gold | required |
| Top Engagement Rings | dropdown | `ringObject.topEngagementRing` | **domain-gated options** (see notes) |
| Ring's Shape | checkbox group (10 shapes) | `ringObject.ringShape.*` | — |
| Image (n/6) | file/image upload ×6 | `jewelryRingArrayImage` | max 6 |
| Price * | number | `ringObject.ringPrice` | capped at 5,000,000 |

Diamond create form (`DiamondManagement.cshtml`): Product name*, Category* (Fancy Colored / Natural Diamond / Lab Grown — last hidden), Fancy Color* / Color* (D..to Z), Carats* (≤10), Diamond Shape*, Clarity* (FL..I3), Certificate number*, Certificate By* (GIA/HRD/IGI), Cut/Polish/Symmetry* (EX..P), Fluorescence* (Non..Very Strong), Width/Length/Height/Depth%/Table*, Image (n/6), Price* (≤5,000,000). Excel bulk import via Category + Shape selects and "Choose file..." (เลือกไฟล์...).

Jewelry create form (`JewelryManagement.cshtml`): Product name*, Description (Kendo editor), Category* (Earrings/Pendant/Necklace/Bracelet and Bangle/Wedding Ring/Men Ring), Style* (cascades from category), Metal*, Image (n/6), Price*.

### Common tasks
#### Add a ring
1. Open Jewelry Management, pick Ring in the left menu, click Add Ring.
2. Fill Product name, Style, Metal (required), choose categories/shapes, upload images, set Price.
3. Click Save.

#### Bulk-import diamonds from Excel
1. Pick Diamond in the left menu (main list state).
2. Pick Category and Shape, then Choose file (เลือกไฟล์...) and select the spreadsheet.
3. Posts to `JewelryManagement/AddDiamondsFromExcel/`.

### Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Views/Management/JewelryManagementCenter.cshtml` + partials in `Boy_Growth_a_Man/Views/Management/JewelryManagementCenter/` (`RingManagement`, `RingListManagement`, `DiamondManagement`, `DiamondListManagement`, `JewelryManagement`, `JewelryListManagement`)
- **Controller / script:** `Boy_Growth_a_Man/ScriptRequire/Component/JewelryManagement/Controller.js` + `Service.js` (controller `JewelryManagementController`)
- **Save endpoint:** `JewelryManagement/addRing`, `JewelryManagement/addDiamond`, `JewelryManagement/addJewelry` (plus `getAllRing` / `delRingById` etc.); Excel import form posts to `JewelryManagement/AddDiamondsFromExcel/`

### Gotchas / multi-tenant notes
- Gated by `HtmlHelperExtensions.Config.bJewelryManagement`. Also draggable as component id `35` (sidebar `Jewelry Filters`).
- **Hardcoded-domain anti-pattern flagged:** in `RingManagement.cshtml` the "Top Engagement Rings" options are gated by literal DomainIDs — `ng-if="useedDomainID == '666aca655f352318201918e1'"` (Signature GH, Martini, Daisy, Glory) and `ng-if="useedDomainID == '66e02fa262b8772614bd53f7'"` (Solitaire, Charming, Blooming, Simply). This breaks the multi-tenant principle (per-domain whitelist in shared markup); a per-domain config-driven option list would be the correct pattern.
- The "Lab Grown Diamond" category option is present but visually hidden (`visibility:hidden;display:none`).

---

## 5. E-SIM (ระบบ E-SIM)

### What it does
A BillionConnect-backed e-SIM module: configure API credentials, sync countries/continents and map
them to shop categories, create e-SIM "commodities" (packages) as shop products, and view/retry
e-SIM orders.

### How to get there
- **Sidebar:** in `_MainMenu.cshtml`, an "E-SIM System" (ระบบ E-SIM) menu group shown only when `Config.bEsim` is on, with four sub-links.
- **Routes:**
  - Settings: `https://demo110.itopplus.com/?manage=true#!/EsimSettings` — ตั้งค่า E-SIM
  - Countries/Continents: `https://demo110.itopplus.com/?manage=true#!/EsimCountry` — จัดการประเทศ
  - Commodities: `https://demo110.itopplus.com/?manage=true#!/EsimCommodity` — จัดการสินค้า
  - Orders: `https://demo110.itopplus.com/?manage=true#!/EsimOrders` — คำสั่งซื้อ E-SIM

### Fields on the screen
Settings (`ViewEsimSetting.cshtml`):
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Enable E-SIM | checkbox | `config.enabled` | — |
| Environment | dropdown | Test / Production (`config.env`) | — |
| App ID | text input | `config.appId` | — |
| App Key | password | `config.appKey` | "Leave blank to keep existing" |
| Organize by country | checkbox | `config.organizeByCountry` | — |
| Test connection / Save | buttons | `testConnection()` / `save()` | — |

Countries tab (`ViewEsimCountry.cshtml`): continent filter (select), search text, per-row Activate/Deactivate toggle, Code/Name/Continent (read-only), "Linked" label, per-row Save + Save all, "Sync to shop categories" button; a Continents tab mirrors this for continents.

Commodities (`ViewEsimCommodity.cshtml`): Sales method (select), Country (select), Load commodities button, Commodity (select), Name (text), Picture URL (text), Price (number), Create button; results table with editable Name/Picture URL/Price and Save/Delete per row; "Sync to shop products" (ซิงค์เป็นสินค้าในร้าน) button.

Orders (`ViewEsimOrder.cshtml`): Status filter (select: All/Pending/Active/Failed), Filter button; read-only table (Status, Shop Order Ref, Product Code, ICCID, Activation Start/End) with a Retry button on failed orders.

### Common tasks
#### Connect the e-SIM provider
1. Go to E-SIM Settings, tick Enable E-SIM, choose Environment.
2. Enter App ID and App Key, click Test connection, then Save.

#### Publish e-SIM packages as shop products
1. Sync countries (Countries tab) and "Sync to shop categories".
2. On Commodities, pick sales method + country, Load commodities, select one, Create.
3. Click "Sync to shop products".

### Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Views/Management/ViewEsimSetting.cshtml`, `ViewEsimCountry.cshtml`, `ViewEsimCommodity.cshtml`, `ViewEsimOrder.cshtml` (public components under `Views/Component/EsimCountrySelectorCtrl/`, `EsimCommodityListCtrl/`)
- **Controller / script:** `Boy_Growth_a_Man/ScriptRequire/System/Esim/` (`Settings/`, `Country/`, `Continent/`, `Commodity/`, `Orders/` — each Controller.js + Service.js; controllers `EsimSettingCtrl`, `EsimCountryCtrl`, `EsimContinentCtrl`, `EsimCommodityCtrl`, `EsimOrderCtrl`)
- **Save endpoint:** `Esim/saveConfig` (settings), `Esim/getConfig`, `Esim/testConnection`; country/continent/commodity/order use sibling `Esim/...` routes via their Service.js

### Gotchas / multi-tenant notes
- Gated by `HtmlHelperExtensions.Config.bEsim` (null-checked in `_MainMenu.cshtml` / `_SideBar.cshtml`).
- Sidebar e-SIM components for the layout are component ids `38` (e-SIM Country Selector / เลือกประเทศ e-SIM) and `39` (e-SIM Commodity List / รายการแพ็กเกจ e-SIM).
- App Key is write-only in the UI (password field, blank-to-keep) — never echoed back.
- A "Sync countries" button on the Countries tab is present but `hidden`; only "Sync to shop categories" is active.

---

## Cross-cutting notes
- All five modules use the standard admin language cookie pattern (`<DomainID>languageManageBackend`) → `isThaiLanguage` ternary for labels. Several labels (Jewelry forms, E-SIM tables) are English-only in the markup.
- The four content-builder modules (360, Custom Booking, Digital Business Hub, Jewelry) are reached from the **new-UI left slide bar** (`_SlideBarHomeNew.cshtml`) and registered as AngularJS hash routes in `ScriptRequire/MainSystem/Routing/Server.js`; E-SIM is reached from `_MainMenu.cshtml`.
- Per-domain enablement (`bImageSpinner` / `bCustomBookingByDate` / `bDigitalBusinessHub` / `bJewelryManagement` / `bEsim`) is the correct multi-tenant gating pattern. The Jewelry "Top Engagement Rings" DomainID whitelist is the one in-code anti-pattern found.
