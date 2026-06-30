# Banner Manager (ตั้งค่าแบนเนอร์)

## What it does
Configures the hero/banner area at the top of the website: uploads banner images, picks the slide/transition effect, sets banner height, ordering, autoplay interval and links per image, plus an advanced per-layer (text/image) animation editor for the "Effect slide" format. Also offers a built-in image gallery/repository and a config backup/restore history.

## How to get there
- **Sidebar:** Website Settings (ตั้งค่าเว็บไซต์) > Banner Manager (ตั้งค่าแบนเนอร์). It is the second item under Website Settings, between Theme Manager (เลือกรูปแบบเว็บไซต์) and Menu Manager (เลือกรูปแบบเมนู). Link target: `<a href="#!/Banner">`.
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Banner`
  (route also accepts an optional theme id segment: `#!/Banner/:themeID?`; both map to `4_0BannerView.cshtml` + `BannerController`)

> **Looking for the website Logo?** The Logo is **not** uploaded on this Banner screen — it lives in **Website Settings / Web Config** (`#!/WebConfig`), which is the same "Banner/Theme settings" family (the WebConfig view's root div is `id="ThemeBannerView"` and it is served by `BannerConfigController`). The real, uploadable logo is the **fixed-menu logo** (`config.fixedMenuLogo[0].logoImage`, which renders in the site header). To upload it: on the WebConfig **General** tab, turn **ON** *Fixed top menu bar (Fixed เมนูด้านบน)*, then check **Upload Logo (อัพโหลดโลโก้)** and choose the file — the uploader is hidden until that toggle is on. (The separate standalone "Logo website" box, `config.Logo`, is `hidden`/legacy in the current build.) See the **"Upload the website / header logo"** task in **web-config.md**.

## Fields on the screen

### Main banner screen (`4_0BannerView.cshtml`)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Select Effect (เลือก Effect) — top toolbar | Dropdown (`SlideEffect`) | Chooses the banner display format. Options from `ALLEffect`: 4 = Carousel slide format (รูปแบบ แสดงภาพสไลด์ Carousel), 5 = Effect slide format (รูปแบบ แสดงภาพสไลด์ Effect), 2 = Single image format (รูปแบบ แสดงภาพเดี่ยว), 3 = Flash image format (รูปแบบ แสดงภาพแฟลช). | `ng-change="chooseEffectBanner()"` saves the config immediately (not on a Save button) and then re-opens the upload panel. Effect 1 also appears in tables (legacy "slider") but is not in the `ALLEffect` picker. The displayed table layout switches: effects 1/4/5 show the multi-row list (Active/Order/Image/Manage); effects 2/3 show a single image/flash row. |
| Current height / Set Height (ความสูงปัจจุบันคือ … / ตั้งค่าความสูง) | Read-out + button | Shows `{{bnHeight}}` (Pixel) and a "Set Height" button that opens the Banner Display Settings panel (`#demo`). | Hidden when `SlideEffect == 2` (single image). |
| Language (ภาษา) | Dropdown (`LanguageUse`) | Selects which language's banner set to edit/upload (`AllLanguage`); banners are stored per language. | Disabled while `LanguageState == 0` (during an in-progress upload). |
| Upload Image (อัพโหลดภาพ) | Button → Dropzone | Opens the Dropzone upload area (`#Dropzone`) posting to `FilesRender/UploadFileServer` (or `Localconfig/uploadBannerDetailFlash` when effect = 3 Flash). | Requires an Effect to be selected first, else a toastr warning. Flash (effect 3) refuses a second upload until the old one is deleted. |
| Active (ทำงาน) — per row | Toggle (kendo-mobile-switch, `banner.Enable`) | Enables/disables that banner image. `ng-change="UpdateEnable(banner)"`. | Shown only for effects 1/4/5. |
| Order (ลำดับ) — per row | Dropdown (`banner.OrderNum`, options from `DdlOrder`) | Reorders the banner. `ng-change="UpdateOrder(banner)"` → `chOrderBannerDetail`. | Shown only for effects 1/4/5. |
| Banner Image (รูปภาพที่แสดง) — per row | Image preview | Shows the uploaded banner thumbnail (`banner.BannerPath`). | — |
| Add Link / Remove Link (สร้างลิงค์ / ลบลิ้งค์) — per row | Buttons | Opens the Link manager modal (`linkedConfig`) / clears the link (`clearLinkURL`). | Add/Remove Link buttons show for effect 4 (carousel) and effect 2 (single). "Remove Link" only when `banner.LinkURL != null`. |
| More Settings (ตั้งค่าเพิ่มเติม) — per row | Button | Opens the per-layer animation editor (`chooseBannerDetail`, `State='edit'`, renders `4_1BannerOptions.cshtml`). | Shown only for effect 5 (Effect slide). |
| Delete (ลบ) — per row | Button | Deletes that banner image (`SettingRemove` → `removeBannerDetail`, with confirm). | — |
| Previous / Next (ก่อนหน้า / หน้าถัดไป) | Pagination buttons | Pages the banner list, 3 per page (`pagesize`). | — |

### Banner Display Settings panel (`#demo`, opened by "Set Height")
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Banner Height Settings / Image Height (ตั้งค่าขนาดรูปแบบแบนเนอร์เพิ่มเติม (ความสูงของภาพ)) | Number input (`bnHeight`, min 50, max 2000) | Sets banner height in pixels. | `required`; Save is blocked if the form is invalid. |
| Transition Effect (รูปแบบลูกเล่นการเปลี่ยนภาพ) | Dropdown (`SlideEffect`, options `DdlSlideEffect`) | Same effect selection as the top toolbar, in the settings panel. | — |
| Enable Infinite Loop (ตั้งค่าให้เอฟเฟคเล่นวนตลอดไป Infinite Loop) | Checkbox (`InfiniteLoop`) | Makes the effect loop forever. | Shown only when `SlideEffect <= 3`. Note: "this setting only applies to some effects". |
| Custom Script | Textarea (`ManualScript`, CodeMirror JS) | Custom banner JS. | Wrapped in a `hidden` form-group — not visible in the standard UI. |
| Save / Cancel (บันทึก / ยกเลิก) | Buttons | `SaveData(BannerConfigGlobal)` → `setBannerConfig`; Cancel returns to the normal view. | Save validates the form (`$invalid` → warning). |

### Per-layer animation editor — Effect slide / effect 5 (`4_1BannerOptions.cshtml`)
Opened via "More Settings" on an effect-5 banner. Edits text/image layers placed over the banner image.
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Add layer (เพิ่ม Layer) | Button → modal | Opens a modal to choose Text Layer or Images Layer (`AddBannerDetailText('Text' \| 'Image')`). | — |
| Auto image-change time (เวลาเปลี่ยนภาพอัตโนมัติ) | Dropdown (`BannerDetailPick.slidedelay`, options `SlideDelay`) | Autoplay interval per slide: ปกติ/Normal = 7500, ช้า/Slow = 10000, เร็ว/Fast = 2500 (ms). | — |
| Animation IN / OUT effect icons (12 icons) | Icon buttons | `chooseAnimationEffect(n, $index)` — picks entry/exit animation per layer. Tooltips: Rotate back/Zoom in/Zoom out/Fade/Reverse/Slide slow/Slide fast/Flip/Show immediately/Slide in/Rotate/Flip back. | Two tabs: Animation IN and Animation OUT. |
| Direction (no label) | Dropdown (`MainConfig[i].beforeTextEffect` / `afterTextEffect`, options `Direction`) | Animation direction: Fade / Slide from left / right / top / bottom. | — |
| Animation duration (ระยะเวลาการ Animate) | Kendo slider (`TimerConfigData[i].durationin` / `durationout`, 0–5000) | Length of the in/out animation. | — |
| Animation start delay (ระยะเวลาเริ่ม Animate) | Kendo slider (`TimerConfigData[i].delayin` / `delayout`, 0–5000) | Delay before the layer animates. | — |
| Display duration (ระยะเวลาแสดง) / Animate in and out immediately | Kendo slider + toggle (`TimerConfigData[i].showuntil`, 0–5000) | How long the layer stays before exit; toggle = animate in/out immediately. | — |
| Layer text editor | Kendo rich-text editor (`TextConfig[i].text`) | Editable text for a Text Layer (double-click or "Edit text" in the layer menu). | — |
| Layer image upload | File upload (`TextConfig[i].image`) | Upload image for an Image Layer (`chooseUpload` → `FilesRender/UploadFileServer`). | — |
| Per-layer menu: Edit text / Animation / Front / Back / Create link / Remove link / Delete (แก้ไขข้อความ / Animation / หน้า / หลัง / สร้างลิ้งค์ / ยกเลิกลิงค์ / ลบข้อมูล) | Context menu | Manage a single layer: edit, set z-order front/back (`choosezIndexAnimation`), link (`linkedConfig`/`clearLinkURL`), delete (`deleteAnimation`). | "Create link" shows when the layer has no url; "Remove link" when it has one. |
| Save and go back (บันทึกและย้อนกลับ) | Button | `saveAnimationBanner(BannerDetailPick, 'cancel')` — persists the layer config. | Disabled while `buttonClicked`. |

### Banner image gallery / repository (`4_2BannerRepository.cshtml`)
Reached when `State == 'banner'` (a "Settings"/gallery flow). A grid of ready-made banner styles.
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Add this style (เพิ่มรูปแบบนี้) | Button | `PickBanner(ban)` — adds the selected gallery image as a new banner detail. | — |
| Download this image (Download รูปนี้) | Link | Downloads the source image (`~/Files/Name/{{ban.ImagePath}}`). | — |
| Previous / Next (ก่อนหน้า / หน้าถัดไป) | Pagination | Pages the gallery (8 per page, `BannerpageSize`). | — |
| Color palette (kendoColorPalette) | Color picker | `changeColor(value)` → filters gallery banners by color. | Bound via `#color-chooser` (palette swatches), handler `changeColor`. |

### Link manager modal (`BannerLinkManager.cshtml`) — opened by "Add Link" / "Create link"
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Internal link / URL link (ลิงก์ภายในระบบ / ลิงก์จาก URL) | Tab toggle (`Linkmanager`) | Switch between linking to an internal page vs an external URL. | `ChangeLinkmanager('internal' \| 'External')`. |
| Page tree (internal) | Kendo tree-view (`dataSource` → `page/getPageRoot`) | Pick the internal page to link to. | — |
| Paste your URL here (วาง URL ของคุณที่นี่) | Text input (`LinkURL`) + Preview | External URL; "Preview" (ดูตัวอย่าง) renders it in an iframe. | — |
| Title text (ข้อความหัวเรื่อง) | Text input (`LinkTitle`) | Link title attribute. | — |
| Alternative text (ข้อความสำรอง) | Text input (`LinkAlt`) | Link alt attribute. | — |
| Open new window (เปิดหน้าต่างใหม่ (New Window)) | Checkbox (`bNewWindows`) | Opens the link in a new tab/window. | — |
| Save (บันทึก) | Button | `SaveLink(...)` then closes modal. For effects 2/4 saves to the banner detail (`setBannerDetail`); for layer links sets `TextConfig[i].url`. | — |

### Effect/transition picker modal (`ViewBannerGallery.cshtml`, id `#myGallery`)
"2D slide transitions" list — a table of LayerSlider transition names/IDs populated by script, opened via `chooseEffectSlide`. Selecting one calls `ChooseEffectSlide(e)`. (Largely a LayerSlider transition gallery; the 3D section is commented out.)

### Backup / restore (`#bannerbackup` in `4_0BannerView.cshtml`)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Back Up | Button | `BackupConfirm()` → `localconfig/BannerBackUp` — snapshots current banner config. | — |
| Backup History (รายการ Back Up ย้อนหลัง) + Select | List + buttons | Lists prior backups by date; "Select" restores one (`selectbackup` → `SelectBackUpBannerConfig`). | Triggered by `$scope.Backup()`; no visible trigger button in this view's main toolbar (see uncertainties). |

## Common tasks

### Add / upload a new banner image
1. Go to `?manage=true#!/Banner`.
2. In the top toolbar, pick an Effect (e.g. Carousel slide format) from **Select Effect**.
3. (Optional) Choose the **Language** whose banner set you are editing.
4. Click **Upload Image** to open the Dropzone, then drop/select the image.
5. The image appears in the banner list with **Active** on and an **Order** number.

### Set banner height / transition / loop
1. On the Banner screen click **Set Height** (next to "Current height").
2. In the Banner Display Settings panel set **Banner Height Settings** (px), the **Transition Effect**, and toggle **Enable Infinite Loop** (effects ≤ 3 only).
3. Click **Save** (บันทึก).

### Reorder / enable / delete a banner
1. Use the per-row **Order** dropdown to change position, the **Active** toggle to show/hide, or **Delete** to remove (confirm prompt).

### Link a banner image to a page or URL
1. On a banner row (effect 4 carousel or effect 2 single) click **Add Link**.
2. In the Link manager pick **Internal link** (choose a page in the tree) or **URL link** (paste a URL).
3. Fill Title/Alt, optionally tick **Open new window**, then **Save**.

### Add text / image layers with animation (Effect slide format)
1. Set Effect to **Effect slide format** (5) and upload a base image.
2. On that row click **More Settings** to open the layer editor.
3. Click **Add layer** → choose **Text Layer** or **Images Layer**.
4. Position the layer, pick Animation IN/OUT effects, direction, durations/delays, set **Auto image-change time**.
5. Click **Save and go back**.

### Choose a ready-made banner from the gallery
1. Enter the gallery (banner repository) view.
2. Hover a style and click **Add this style** (or **Download this image**). Use the color palette to filter.

## Wired in (for developers)
- **View(s):**
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Theme/4_0BannerView.cshtml` (main screen + backup panel)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Theme/4_1BannerOptions.cshtml` (per-layer animation editor, effect 5)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Theme/4_2BannerRepository.cshtml` (image gallery/repository, `data-ng-include` of `Theme/GotoView?ViewData=4_2BannerRepository`)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Theme/ViewBannerGallery.cshtml` (`#myGallery` 2D-transition picker modal)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Component/Banner/BannerLinkManager.cshtml` (link modal)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Component/Banner/AdvanceLayerEffect.cshtml` (advanced per-layer effect modal, opened by `AdvanceEffectConfig`)
- **Controller / script (AngularJS):**
  - `ScriptRequire/System/BannerConfig/Banner/Controller.js` — `BannerController` (the controller that actually drives `4_0BannerView`)
  - `ScriptRequire/System/BannerConfig/Banner/Service.js` — `BannerService`
  - `ScriptRequire/System/BannerConfig/Service.js` — `BannerConfigService` (`getBannerConfig`, `setBannerConfig`)
  - `ScriptRequire/System/BannerDetail/Service.js` — `BannerDetailService` (per-image detail CRUD + ordering)
  - `ScriptRequire/System/BannerConfig/index.js`, `ScriptRequire/System/BannerDetail/index.js` (barrels)
  - Route registration: `ScriptRequire/MainSystem/Routing/Server.js` — `.when('/Banner/?:themeID?', { templateUrl: 'FilesRender/RenderPartial?id=/views/Theme/4_0BannerView.cshtml...', controller: 'BannerController' })`
  - Sidebar link: `Views/LayoutManager/_SlideBarHomeNew.cshtml` (`<a href="#!/Banner">`); label key `bannerSettings` in `ScriptRequire/domains/language/menu-by-language/menuSlideBarNameByLanguage.js`
  - C# models: `Models/BannerConfig/BannerConfigRepository.cs`, `Models/BannerDetail/BannerDetailRepository.cs`
- **Save endpoint(s)** (all under the C# `Localconfig` controller, proxied to PoolNode):
  - Banner config (effect, height, interval, loop): `POST localconfig/setBannerConfig` (`{ jsonObject }`); read via `GET Localconfig/getBannerConfig?DomainID=`
  - Per-image banner detail: `POST localconfig/setBannerDetail`, `POST localconfig/addBannerDetail`, `GET localconfig/removeBannerDetail`, `POST localconfig/chOrderBannerDetail`, `GET localconfig/getBannerDetail` / `getAllBannerDetail` / `getAllBannerFlash`
  - Upload: `FilesRender/UploadFileServer` (image) and `Localconfig/uploadBannerDetailFlash` (Flash), plus `localconfig/uploadBannerDetail`
  - Gallery: `localconfig/getAllBannerAsync`, `localconfig/getBanberColorAsync`, `localconfig/getBannerAsync`
  - Backup: `localconfig/BannerBackUp`, `localconfig/getBackUpBanner`, `localconfig/SelectBackUpBannerConfig`
  - Note: menu-style saves in this controller (`saveMenuNavbar`/`saveMenuVertical`) go through `localconfig/saveConfigAsync` — unrelated to banner config.

## Gotchas / multi-tenant notes
- Banner data is **per language**: the **Language** dropdown changes which banner set you edit; uploads carry `LanguageUse`. The default language drives what is shown.
- The folder is named `BannerConfig`, but `BannerConfig/Controller.js` (`BannerConfigController`) is actually the **Web Config / Page Setting** page (route `#!/WebConfig`), not the Banner Manager. The banner screen is driven by `BannerConfig/Banner/Controller.js` (`BannerController`). Don't edit the wrong one.
- Effect numbering is non-obvious: the picker (`ALLEffect`) only offers 4/5/2/3, but the templates also branch on effect 1 (legacy slider). Effect 3 is Flash (legacy) and effect 2 is single image. Tables render differently per effect group (1/4/5 vs 2/3).
- `chooseEffectBanner()` (top Effect dropdown) and `UpdateOrder` / `UpdateEnable` save **immediately** via `setBannerConfig`/`setBannerDetail` — there is no global save bar for those; only the Banner Display Settings panel uses a Save button. (`saveData` here does not set `$rootScope.applyReady`.)
- No hardcoded-domain whitelist was found in the banner scripts/views; everything is keyed on the per-request `DomainID`, consistent with the multi-tenant model.
- The mobile-banner functions (`UploadBannerMobile`, `UploadMBOpen`, `removeBannerMobile`, `getBannerMobile`) and the backup trigger (`$scope.Backup`) exist in `BannerController`/`BannerService` but have **no trigger element in the four scoped views** — see uncertainties.

## Uncertainties
- **Desktop vs mobile banners:** the controller/service have full mobile-banner support (`getBannerMobile`, `uploadBannerMobile` via `./Localconfig/uploadBannerMobile`, `#upbannermobile`, `#mb` DOM ids), but none of the scoped views (`4_0BannerView`, `4_1BannerOptions`, `4_2BannerRepository`, `ViewBannerGallery`) contain those elements or a visible "mobile banner" tab/button. The mobile UI likely lives in another (possibly legacy/theme) view not in scope. I could not confirm a live mobile-banner field on screen.
- **Backup/restore entry point:** `#bannerbackup` (Back Up / Backup History) is in `4_0BannerView.cshtml`, but its opener `$scope.Backup()` has no visible button in that view's toolbar — the trigger may be elsewhere (e.g. a global head-manage control) or currently hidden.
- **`bIntervalSlide` / `IntervalSlide`:** these are read into scope and sent in `setBannerConfig`/`chooseEffectBanner`, implying an autoplay-interval setting, but I found no on-screen input bound to them in the scoped views (autoplay interval for effect 5 is set via `slidedelay`/`SlideDelay` instead). Their UI surface, if any, is unconfirmed.
- **`ViewBannerGallery.cshtml` (`#myGallery`):** its transition table body is populated by external LayerSlider script not in scope, so the exact list of selectable transitions is not enumerable from the source read.
- BOM/encoding of the docs file is not relevant (this is a `.md`), but note the scoped `.cshtml` files rely on the UTF-8 BOM rule for Thai labels (per Views/CLAUDE.md).
