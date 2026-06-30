# Page Manager (สร้างหน้าเพจ) + Page Properties

## What it does
Manages the website's page tree: create main pages and sub-pages, master (template) pages, set the page name / display name / short URL, control where a page shows (menus, devices, members), reorder by drag-and-drop, delete pages, and pick the homepage. The same page-detail form is also reachable as the per-page "Page Properties" modal (gear icon on each page row), where per-page SEO lives.

## How to get there
- **Sidebar:** Website Settings (ตั้งค่าเว็บไซต์) > **Page Manager** (สร้างหน้าเพจ) — the `createPages` entry in the left slide bar (`#!/PageManager`). Clicking a page in the tree deep-links it into the LayoutManager editor (`#!/layoutmanager/<pageId>`). *(The separate sidebar item labelled **Page Setting** / ตั้งค่าทั่วไป — the `settings` label — is actually the Website Settings panel `#!/WebConfig`; see `web-config.md`, not this screen.)*
- **Route (Page Manager screen):** `https://demo110.itopplus.com/?manage=true#!/PageManager`
- **Route (edit a specific page in the layout editor, page-scoped):** `https://demo110.itopplus.com/?manage=true#!/layoutmanager/<pageId>` (page tree links use this; omitting `<pageId>` defaults to the homepage)
- **Page Properties:** opens as a **modal**, not a route. Triggered by the gear icon (`glyphicon-cog`) that appears on hover over any page row in the sidebar page tree — it calls `$root.openPagePropertiesModal('<pageId>')`. The modal embeds the same detail form (`2MainDetail`) used on the Page Manager screen.

## Fields on the screen

The Page Manager screen (`Index.cshtml`) is a left page-tree + right detail pane. Creating a page opens a small modal (`1Main.cshtml`). Selecting an existing page (or opening the gear modal) shows the full detail form (`2MainDetail.cshtml`), organized as Kendo tabs: General / SEO / Additional Settings / JavaScript Settings.

### Page Manager toolbar + tree (Index.cshtml)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Add Main Menu (เพิ่มเมนูหลัก) | button | Opens the Create New Page modal to add a root-level page | When the "Master Pages" tab is active, this creates a master page (`bLandingPage=true`) instead |
| Add Sub Menu (เพิ่มเมนูย่อย) | button | Opens the Create New Page modal to add a child under the selected page | Disabled (`NotAllowAddSub`) until a page is selected; master pages cannot have sub-pages |
| Delete Page (ลบหน้า) | button | Deletes the selected page (confirm dialog; warns if it has children) | Disabled until a page is selected; cannot delete the Home Page; cannot delete a page that contains the Homepage in its subtree (`ERRORHOMEPAGEINSUBTREE`) |
| Language selector (-- เลือก ภาษา --) | dropdown/select | Switches which language's PageConfig is shown/edited | Bound to `DefaultLang`; options come from `AllLanguage` |
| Pages / Master Pages tabs (หน้าเพจ / หน้าต้นแบบ) | tabs | Switch the tree between normal pages and master (template) pages | — |
| Page tree | tree (custom UL/LI, drag-to-reorder) | Click a node to load it into the detail pane; drag a row to reorder / re-parent | Drag reorder calls `ChangeOrderPage`; Homepage cannot be nested (forced back to top level); reorder only allowed within the same DomainID |

### Create New Page modal (1Main.cshtml)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Page Reference Name (ชื่ออ้างอิงเพจ) | text input | The new page's name (`Page.NamePage`) | Required; validated 3–50 chars; `+` and `#` stripped on save |
| Set this page as Master Page (กำหนดหน้านี้เป็น Master Page) | checkbox | Marks the new page as a master/template page (`Page.bLandingPage`) | On the Master Page tab; clears any selected master page |
| Select Master Page (เลือกหน้าต้นแบบ) | dropdown/select | Attaches the new page to an existing master page (`Page.LandingPageID`) | Only shown when "Set as Master Page" is unchecked; options from `PageMaster` |
| Display Format tab (รูปแบบแสดงผล) | layout pickers | Per-device layout (PC / mobile / tablet) thumbnails | Tab is `hidden` in the create modal markup |
| Create Page (สร้างเพจ) / Cancel (ยกเลิก) | buttons | Submit / dismiss | Submit runs `CreateNewPage()` → `SavePage('ContactForm')` |

### Detail form — General tab (2MainDetail.cshtml, ทัวไป)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Page Reference Name (ชื่อที่ใช้อ้างอิงเพจ) | text input | The page's internal name (`SelectPage.NamePage`) | maxlength 50; disabled when `NotAllowSave` |
| Menu Display Name (ชื่อที่แสดงในเมนู) | text input | Name shown in the navigation menu (`SelectPageConfig.Name`) | maxlength 50; required on save (blocks save if empty) |
| URI Display Name (ชื่อที่แสดงบน URI) | text input | Custom short URL segment (`SelectPageConfig.CustomUrlName`) | maxlength 50; inside `.bItpCustomURL` wrapper |

### Detail form — SEO tab (per-page SEO; documented in detail in seo.md)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Page Title (ชื่อหัวข้อของเพจ / Title) | text input | Per-page `<title>` (`SelectPageConfig.Title`) | maxlength 300; defaults from global config Title unless `notUseSeoDefault` |
| Keywords (คำค้นหาใช้ ,เพื่อแยกคำ / Keywords) | text input | Meta keywords, comma-separated (`SelectPageConfig.Keywords`) | maxlength 300; warns at ≥300 chars |
| Description (ชื่อที่แสดงในเมนู / Description) | textarea | Meta description (`SelectPageConfig.Description`) | maxlength 400 |
| Alt / Title / UrlRewrite (Alt / Title / UrlRewrite) | text input | URL rewrite / hover title (`SelectPageConfig.URLRewrite`) | maxlength 100; duplicate menu name → `ERRORREWRITEURL` on save |
| Enable Canonical Tag URL (เปิดใช้งาน Canonical Tag) | text input | Per-page canonical URL (`SelectPageConfig.CanonicalURL`) | maxlength 300; inside `.bItpCanonical` wrapper |

> Per-page SEO fields above are the same ones cross-linked from **seo.md** — see that reference for how page-level SEO interacts with site-wide SEO defaults.

### Detail form — Additional Settings tab (ตั้งค่าเพิ่มเติม)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| URL to Other Page (URL ไปยังเพจอื่น) | text input | Redirect/link this menu item to another URL (`SelectPageConfig.URLTarget`) | — |
| Image displayed when sharing on Facebook (ภาพแสดงผลเมื่อแชร์บน facebook) | file/image upload | OG image (`SelectPageConfig.OGFacebook`) | Uploads via `FilesRender/UploadFileServer` |
| Open new window when accessed (เปิดหน้าต่างใหม่ เมื่อมีการเรียกใช้) | checkbox | `SelectPageConfig.bNewWindows` | — |
| Disable access to this page in all cases (ปิดหน้านี้ ไม่ให้เข้าถึง ทุกกรณี) | checkbox | `SelectPageConfig.bDisableAccess` | — |
| Disable access (mobile only) (ปิดหน้านี้... *เฉพาะบนโทรศัพท์) | checkbox | `SelectPageConfig.bDisableAccessOnlyMobile` | Inside `#itp-disable-page-OnlyMobile` |
| This page does not display SEO (เพจนี้ไม่แสดงผล SEO) | checkbox | `SelectPageConfig.notUseSeoDefault` | When set, page SEO no longer inherits global config defaults |
| Page for members only (เพจสำหรับสมาชิก เท่านั้น) | checkbox | `SelectPageConfig.bLoginRequire` | — |
| Page for VIP members only (เพจสำหรับสมาชิก vip เท่านั้น) | checkbox | `SelectPageConfig.pageOnlyVip` | Blocked if the page is the Homepage (`checkIsHomePage`) |
| This page does not display in the top menu (เพจนี้ไม่แสดงผลในเมนูด้านบน) | checkbox | `SelectPageConfig.bShowonMenu` | Disabled for the Home Page |
| This page does not display in the side menu (เพจนี้ไม่แสดงผลในเมนูด้านข้าง) | checkbox | `SelectPageConfig.bShowonMenuVertical` | Disabled for the Home Page |
| Page for payment notification system (เพจสำหรับระบบแจ้งชำระเงิน) | checkbox | `SelectPageConfig.bPaymentPage` | **Only rendered if `Domain.bCommerce`**; on save writes shopcart `PagePayment` setting |
| This page does not display on phone (เพจนี้ไม่แสดงผลบนโทรศัพท์) | checkbox | `SelectPageConfig.bPhone` | Shown only when `bShowonMenu`; disabled for Home Page |
| This page does not display on tablet (เพจนี้ไม่แสดงผลบนแท็บเล็ต) | checkbox | `SelectPageConfig.bTablet` | Same conditions as above |
| This page does not display on computer (เพจนี้ไม่แสดงผลบนคอมพิวเตอร์) | checkbox | `SelectPageConfig.bComputer` | Same conditions as above |
| Close this page for maintenance (ปิดปรับปรุงเพจนี้) | checkbox | `SelectPageConfig.bUnderConstruction` | — |
| Show menu page icon (แสดง icon หน้าเมนู) | checkbox | `SelectPageConfig.bIcons` | Enables the "Select icons" button |
| Disable display for normal users (ปิดการแสดงผลสำหรับบุคคลธรรมดา) | checkbox | `SelectPageConfig.bHidePageNormal` | — |
| Disable display for members (ปิดการแสดงผลสำหรับสมาชิก) | checkbox | `SelectPageConfig.bHidePageMember` | — |
| Set as backup homepage (ตั้งเป็นหน้าหลักสำรอง) | button | Registers this page as a reserve homepage (`addReserveHomePage`) | Blocked if page is VIP-only |
| Select icons (เลือก icons) | button | Opens the icon picker modal (`ActivedStyle`) | Disabled unless "Show menu page icon" is checked. In the Page Properties modal this just shows a toast telling you to use the Page Manager screen instead |
| Select template page (เลือกหน้าต้นแบบ) | dropdown/select | Attach/detach a master page (`SelectPage.LandingPageID`) | Only for non-master pages; options from `PageMaster` |
| Set as homepage (ตั้งเป็นหน้าหลัก / Homepage) | button | Makes this page the site homepage (`setHomepage`) | Only for top-level non-master pages; disabled if already Home Page; blocked if VIP-only |
| Image displayed on menu (ภาพแสดงผลบน menu) | file/image upload | Mega-menu image (`SelectPage.MenuImagePath`) | Hidden by default (`.megaMenuType2itopplus`, `display:none`) |
| Image displayed on menu 2 (ภาพแสดงผลบน menu 2) | file/image upload | Second mega-menu image (`SelectPage.MenuImagePath2`) | Hidden by default (`.megaMenuType5itopplus`) |

### Detail form — JavaScript Settings tab (ตั้งค่า Java Scripts)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Select to add JavaScript Code (เลือกเพื่อใส่ Code Javascript) | checkbox | Reveals the code editor (`toggleJavascript`) | Danger warning shown — bad script can break the site |
| JavaScript for website (Java Script สำหรับเว็บไซต์) | rich-text editor (CodeMirror) | Per-page custom JS (`SelectPageConfig.CustomScript`) | Initialized via `LoadscriptConfig()`; value read on save |

### Page Properties modal extras (_PagePropertiesModal.cshtml)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Language selector (-- เลือก ภาษา --) | dropdown/select | Switch which language's config is edited (`DefaultLang` → `ChangeLanguage`) | Same as the Page Manager screen selector |
| Close (ปิด) / Save Data (บันทึกข้อมูล) | buttons | Dismiss / persist (`SaveConfig`) | The embedded form's own bottom "Save Data" button is hidden via CSS; the modal footer button is used instead. On success the modal auto-closes |

## Common tasks

### Create a main (root) page
1. Open `?manage=true#!/PageManager`.
2. Make sure the **Pages** tab (not Master Pages) is active.
3. Click **Add Main Menu** (เพิ่มเมนูหลัก).
4. Enter the **Page Reference Name** (3–50 chars).
5. Click **Create Page** (สร้างเพจ).

### Create a sub-page
1. In the page tree, click the parent page to select it.
2. Click **Add Sub Menu** (เพิ่มเมนูย่อย) (enabled only after a page is selected).
3. Enter the name and click **Create Page**. The new child appears under the parent.

### Create a master (template) page
1. Switch the tree to the **Master Pages** (หน้าต้นแบบ) tab.
2. Click **Add Main Menu** — it now creates a master page (`bLandingPage=true`).
   (Or, in the Create New Page modal's Master Page tab, tick **Set this page as Master Page**.)
3. To attach a normal page to a master: select the page → Additional Settings tab → **Select template page** dropdown.

### Edit a page's name / short URL / type
1. Select the page in the tree (right pane loads).
2. General tab: edit **Page Reference Name**, **Menu Display Name**, **URI Display Name**.
3. Click **Save Data** (บันทึกข้อมูล). Errors: duplicate page name = `ERRORNAME`; duplicate menu name = `ERRORREWRITEURL`.

### Control visibility / publishing
1. Select the page → **Additional Settings** tab.
2. Toggle the menu/device/member checkboxes (top menu, side menu, phone/tablet/computer, members-only, VIP-only) or **Close this page for maintenance**.
3. Save Data.

### Reorder pages
1. On the Page Manager screen, drag a page row by its handle to a new position (before/after a sibling, or "over" a row to nest it as a child).
2. The drop persists immediately via `ChangeOrderPage`; an illegal swap or moving the Homepage reloads the tree.

### Set the homepage
1. Select a top-level, non-master page → Additional Settings tab.
2. Click **Set as homepage** (ตั้งเป็นหน้าหลัก) and confirm.

### Delete a page
1. Select the page in the tree.
2. Click **Delete Page** (ลบหน้า) and confirm. The Home Page can't be deleted, nor a page whose subtree contains the Homepage.

### Open Page Properties (incl. per-page SEO)
1. Hover any row in the sidebar page tree; a gear icon (cog) appears on the right.
2. Click it to open the Page Properties modal (`openPagePropertiesModal(pageId)`) — it loads the full detail form including the SEO tab.

## Wired in (for developers)
- **View(s):**
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Page/Index.cshtml` — Page Manager shell (tree + detail pane), `PageManagerController`, `ng-include` of `2MainDetail`
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Page/1Main.cshtml` — "Create New Page" modal
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Page/2MainDetail.cshtml` — the General/SEO/Additional/JS detail form (shared by screen and modal, loaded via `Page/GotoView?ViewData=2MainDetail`)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Page/_PagePropertiesModal.cshtml` — Page Properties modal wrapper (`PagePropertiesModalController`)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/LayoutManager/_SidebarMenu.cshtml` — page tree render + `PageTool()` gear helper + `openPagePropertiesModal()` trigger
- **Controller / script (AngularJS):**
  - `ScriptRequire/System/PageManager/Controller.js` (`PageManagerController`), `Service.js` (`PageManagerService`), `index.js`
  - `ScriptRequire/System/PagePropertiesModal/Controller.js` (`PagePropertiesModalController`) + `index.js` (registers `$rootScope.openPagePropertiesModal`)
  - `ScriptRequire/System/Page/Service.js`, `index.js`
  - `ScriptRequire/domains/components/pageManage.domain.js` (`replacePlus`, `checkIsnotPageOnlyPageVIP`, `replaceJavascript`)
  - Route registration: `ScriptRequire/MainSystem/Routing/Server.js` — `/PageManager` → `Views/Page/Index.cshtml` + `PageManagerController`; `/layoutmanager/?:pageid?` → layout editor (`ComponentCtrlV2`)
  - Labels: `ScriptRequire/domains/language/menu-by-language/menuSlideBarNameByLanguage.js` (`createPages` = "Page Manager"/"สร้างหน้าเพจ", `settings` = "Page Setting"/"ตั้งค่าทั่วไป"); `sidebar-page-filter.js` (page search box strings)
- **C# Controller:** `Controllers/PageController.cs` (route name `Page`, whitelisted in `App_Start/RouteConfig.cs` Default route). `GotoView(ViewData)` returns the embedded view by name.
- **Save endpoint(s):**
  - Create root: `POST page/AddPageRoot`
  - Create child: `POST page/AddPagebyParentID`
  - **Save/update a page (the main "Save Data"):** `POST page/SetPagebyID` → `PageController.SetPagebyID(Page)` → `pageRepo.SetPagebyID` → PoolNode (returns `END` / `ERROR` / `ERRORNAME` / `ERRORREWRITEURL`)
  - Delete: `POST page/DeletePagebyID`
  - Reorder: `POST page/ChangeOrderPage`
  - Read: `GET page/getPageRoot`, `page/getPageChild`, `page/getPagebyID`
  - Reserve homepage: `ConfigService.addReserveHomePage` (Localconfig)
  - Uploads (OG / menu / icon images): `FilesRender/UploadFileServer` (and `page/UploadIconMenu` for icon picker)

## Gotchas / multi-tenant notes
- **Two entry points, one form.** The detail form `2MainDetail.cshtml` is reused both inline on the Page Manager screen (`PageManagerController`) and inside the gear-icon Page Properties modal (`PagePropertiesModalController`). They share field bindings but have separate controllers; the modal hides the form's inline Save button and uses its own footer Save, and its icon picker is a no-op toast (directs you to the Page Manager screen).
- **Sidebar tree ng-class is inert.** `_SidebarMenu.cshtml` HTML is appended without `$compile`, so the active-page highlight is applied manually in JS (`applyActiveHighlight` in `PagePropertiesModal/index.js`) by matching the `/layoutmanager/<id>` href.
- **Commerce-gated field.** "Page for payment notification system" (`bPaymentPage`) only renders when `Domain.bCommerce` is true, and on save writes the shopcart `PagePayment` setting. This is a per-domain capability flag (`bCommerce`), not a hardcoded-domain whitelist — consistent with multi-tenant rules.
- **Homepage constraints.** The Homepage must stay at top level (drag-nesting is reverted with a toast and a reload), cannot be deleted, cannot be VIP-only, and a page containing the Homepage in its subtree cannot be deleted.
- **Language is per-PageConfig.** Each page holds a `PageConfig` array keyed by `LanguageID`; the language selector swaps which entry the form edits. SEO defaults are copied from global config only when `notUseSeoDefault` is false and the field is undefined.
- **Name sanitizing on save.** `+` → `<!plus!>`, `&` → `<!ampersand!>`, `#` stripped (via `replacePlus` / inline replaces) before posting; names are validated 3–50 chars on create.
- No hardcoded-domain (`exclusiveName*`) logic was found in this feature's scripts; all behavior keys off `DomainID`, `bCommerce`, and per-page flags.
