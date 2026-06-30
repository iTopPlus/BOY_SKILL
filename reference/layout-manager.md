# Layout Manager (จัดการข้อมูลเว็บไซต์)

## What it does
Opens a page in an in-place WYSIWYG editor where you arrange the page's content by dragging **components** (text, image, menu, form, shopcart, etc.) and **layout sections** (column splits like 50/50, 33/33/33) onto the live page, then move, configure, or delete what you placed. It is the per-page content builder, scoped to one page (and one language) at a time.

## How to get there
- **Sidebar:** Main Backend home → the Step 3 design button **"Design Your Web"** (the `choice-3` / `btn-step3` icon in `Views/MainBackend/Index.cshtml`), or in the 2025 UI: **Website Settings (ตั้งค่าเว็บไซต์) → Manage Website (จัดการข้อมูลเว็บไซต์)** card in `Views/MainBackend/NewUI/settingGeneral.cshtml`. The sidebar label for this section is **Layout Manager (จัดการข้อมูลเว็บไซต์)**.
- **Route:** `https://demo110.itopplus.com/?manage=true#!/layoutmanager` (edits the home page), or page-scoped `https://demo110.itopplus.com/?manage=true#!/layoutmanager/<pageId>`. With no `pageId` the route falls back to `HomePageID`.
- Once inside, a left floating toolbar (`#toolslide`, from `Views/LayoutManager/_SideBar.cshtml`) slides in with three numbered panels. Switching which page you edit is done from panel 2 ("Menu & Page") — clicking a page navigates to `#!/layoutmanager/<that pageId>`. The same toolbar appears only while `$scope.Layoutmanager == true` (set when the URL contains `layoutmanager`).

> **Component placed but not showing on the live site?** If a component (or an image inside it) is on the page in the editor but doesn't appear publicly, the cause is often a **CSS rule in Global CSS** at `#!/WebConfig/css` (`display:none`, `visibility:hidden`, etc.), not a broken component or missing data. Check the CSS tab first — see `web-config.md`.

## Fields on the screen
The Layout Manager is a drag-and-drop canvas plus a 3-panel toolbar, not a form. The "fields" are the toolbar controls and the per-component action menu.

| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| **Panel 1 — Content & Layout (เนื้อหา & เลย์เอาต์)** | toolbar step | Opens the component palette to drag onto the page | `ng-click="showNav(1)"` |
| Text group → Write New Content (เขียนเนื้อหาใหม่), System Content (เนื้อหาจากระบบ), Content Category Menu (เมนูหมวดหมู่เนื้อหา), Task Scheduler, HTML Tools (เครื่องมือ Html), Word Tools (เครื่องมือ Word), Table Tools (เครื่องมือตาราง) | draggable palette items | Drag onto a drop zone to add that component | componentids 2,1,28,27,7,10,29; Word/Table/Scheduler hidden when `Config.Optimization.bAdvanceOptimize` |
| Layout group → 100%, 50%-50%, 40%-60%, 60%-40%, 30%-70%, 70%-30%, 20%-80%, 80%-20%, 33%-33%-33%, 25% x 4, 20% x 5 | draggable palette items (sections) | Drag onto the page to add a multi-column **section** that components can then be dropped inside | componentids L0,L1,L2,L3,L4,L5,L8,L9,L7,L10,L11. A Layout cannot be dropped inside another Layout (blocked with a toast) |
| Image group → Photo Album (อัลบั้มรูปภาพ) | draggable palette item | Adds the image/gallery component | componentid 5 |
| Menu group → Top Sub Menu (เมนูด้านบน ย่อย), Full Side Menu (เมนูด้านข้าง เต็ม), Side Sub Menu (เมนูด้านข้าง ย่อย) | draggable palette items | Adds a navigation menu component | componentids 26,9,4 |
| Social / MultiMedia → Social Media (โซเชียลมีเดีย) | draggable palette item | Adds the social component | componentid 8 |
| Shopcart group → Shopping Cart (ตะกร้าสินค้า), Shopping Cart Menu (เมนูตะกร้าสินค้า), Payment Form (ฟอร์มชำระเงิน) | draggable palette items | Adds e-commerce components | componentids 11,17,24. Whole group only shown when `Domain.bCommerce` is true |
| Form group → Contact Us (ฟอร์มติดต่อเรา), Newsletter (ติดตามข่าวสาร), Custom Form (ฟอร์มสร้างเอง), Web Board (เว็บบอร์ด), Login Form (ฟอร์มล๊อกอิน), Registration Form (ฟอร์มสมัครสมาชิก), Search Form (ฟอร์มค้นหา), Excel Search Form (ฟอร์มค้นหา Excel), Price Filter Search (ฟอร์มค้นหา Filter ราคา), Comment Form (ฟอร์ม Comment), Order Recommendation (ฟอร์มแนะนำการสั่งซื้อ), Bank Form (ฟอร์มธนาคาร), Custom Booking, Jewelry Filters, Custom Excel Search, Member Courses System, e-SIM Country Selector / Commodity List | draggable palette items | Adds the chosen form/component | componentids 3,21,12,14,13,16,6,32,33,15,30,31,34,35,36,37,38,39. Several gated by per-domain config flags (`bFormOptimize`, `bAdvanceOptimize`, `bCommerce`, `bCustomBookingByDate`, `bJewelryManagement`, `bCustomExcelSearch`, `bMemberCoursesSystem`, `bEsim`) |
| Stat group → Visit Statistics (สถิติการเข้าชม) | draggable palette item | Adds the visitor-stats component | componentid 23 |
| **Panel 2 — Menu & Page (เมนู & หน้า)** | toolbar step | Page switcher / page tree to choose which page to edit | `ng-click="showNav(2)"` |
| Search pages (ค้นหาหน้า...) | text input | Filters the page tree; Enter jumps to the first match's `#!/layoutmanager/<id>` | from `sidebar-page-filter.js` |
| Select Normal Page / Select Master Page (เลือกหน้าปกติ / เลือกหน้าต้นแบบ) | toggle button | Switches the tree between normal pages and master/template pages | `pagesidebaractive(0|1)` |
| Copy All Internal Content (คัดลอกเนื้อหาภายในทั้งหมด) | button (modal) | Copies the whole current page's content onto a chosen destination page (destination content is erased first) | `ng-click="CopyComponent()"`; confirm dialog warns destination data is overwritten |
| Select Theme Layout Style (เลือกรูปแบบ theme layout) | button (modal) | Opens theme-layout chooser (left/right/full column structure of the theme) | `ng-click="themelayoutConfig()"` |
| **Panel 3 — Design Your Web (ออกแบบเว็บของคุณ)** | toolbar step | Page-level design actions | `ng-click="showNav(3)"` |
| Background | button (modal) | Opens background config | `ng-click="BackgroundConfig()"` |
| slide Effect | button (modal) | Opens page slide/transition effect config | `ng-click="EffectPageConfig()"` |
| Publish All Content | button | Publishes all content on the page | `ng-click="PublishAll()"` |
| Toggle Sidebar / Change Side (left ↔ right) | toggle | Collapses the toolbar or flips it to the other screen edge | `sidebarCollapsed`, `ChangeMode()` |
| **Per-component action menu** (floating gear on each placed component, `MenuFullToolBar.cshtml`) | inline toolbar | | appears on hover over a placed component |
| Layout (ตั้งค่า Layout) | menu item (modal) | Per-component padding / responsive show-hide / animation config | `toggleComponent()` |
| Border (ตั้งค่า Border) | menu item (modal) | Per-component border/background style | `BorderConfig()` |
| Up / Down (สลับ component) | buttons | **Move** the component up/down one slot in its position | `switchUpComponent()` / `switchDownComponent()` → SwitchComponent Action UP/DOWN |
| Left / Right (สลับ component) | buttons | **Move** the component to the adjacent layout column; shown only when the component sits inside a multi-column section (`RefID2` set) | `switchLeftComponent()` / `switchRightComponent()` → Action LEFT/RIGHT |
| Delete | menu item | **Delete** the component (SweetAlert confirm, then removes from DOM) | `delComponentmanager()` → DelComponent |

## Common tasks

### Open a page in layout mode
1. Enter manage mode: `https://demo110.itopplus.com/?manage=true`.
2. From the backend home, click **Design Your Web** (Step 3), or go directly to `#!/layoutmanager`.
3. To edit a different page, open toolbar panel **2 (Menu & Page)**, search/select the page (or use "Select Master Page" for template pages) — the URL becomes `#!/layoutmanager/<pageId>`.

### Add a section (column layout) to a page
1. Open toolbar panel **1 (Content & Layout)** and click **Layout**.
2. Drag the desired column ratio (e.g. **50%-50%**) onto an empty drop zone on the page.
3. The section is created via `Component/AddComponent` and rendered in place. You can now drop components into each column.

### Add a component to a page
1. Open panel **1**, click the group (Text, Image, Menu, Form, Shopcart, Stat, Social/Multimedia).
2. Drag the component tile onto a drop zone — either a top-level position (`#pos…`), an insert point on an existing component (`…Top`), or inside a Layout column (`#Lay…`).
3. The drop calls `scope.AddComponent` → `Component/AddComponent`, the new component's default config is created, and it is compiled into the DOM at the drop point.
   - Note: a Layout cannot be nested inside another Layout (the drop is rejected with a toast).
   - Shopcart components first run a config completeness check; if Category/Payment/Shipping/General settings are missing you are redirected to fill them in.

### Move a component
1. Hover the placed component and open its gear (the `MenuFullToolBar` dropdown).
2. Use **Up / Down** to reorder within the position, or **Left / Right** to move between columns (only available inside a multi-column section).
3. Each click hits `Component/SwitchComponent` with the matching Action and reloads the route.

### Delete a component
1. Hover the component, open the gear menu, click **Delete**.
2. Confirm in the SweetAlert dialog. The component is removed via `Component/DelComponent` and stripped from the DOM.

## Wired in (for developers)
- **View(s):** `Views/LayoutManager/_SideBar.cshtml` (the `#toolslide` 3-panel toolbar + component palette), `Views/LayoutManager/_SidebarMenu.cshtml` + `_SidebarMenuIndex.cshtml` (page tree / page-index JSON), `Views/Component/Layout/Layout*.cshtml` (the column-section templates L0–L11), `Views/Component/Sharing/MenuFullToolBar.cshtml` + `MenuResToolBar.cshtml` (per-component Up/Down/Left/Right/Delete/Layout/Border menu). The page canvas is rendered by `FilesRender/RenderPartialFileLayout` (`Controllers/FilesRenderController.cs`).
- **Controller / script:** Route + page load: `ScriptRequire/MainSystem/Routing/Server.js` (`/layoutmanager/?:pageid?` → controller `ComponentCtrlV2`). Render controller: `ScriptRequire/MainSystem/Controller/ComponentV2/ComponentCtrlV2.js`; add-component dispatch: `ComponentCtrlV2AddCmp.js`; wiring: `ComponentCtrlV2_Server.js`; HTTP service: `ComponentService.js`. Drag/drop directives: `ScriptRequire/MainSystem/Directive/DragDrop/Drag.js` + `Drop.js` (the `componentid → ControlType/controller` switch and `case 'L0'..'L11'` section map live in `Drop.js`). Per-component toolbar actions: `ScriptRequire/Component/ComponentConfig/Controller.js` (`switchUp/Down/Left/RightComponent`, `delComponentmanager`). Theme-level column layout helper: `ScriptRequire/System/Layout/Service.js` (+ `index.js`). Scene flag `$scope.Layoutmanager` set in `ScriptRequire/MainSystem/Controller/Global/RouteChangeSuccess/index.js`.
- **Save endpoint:** Adding: `Component/AddComponent` (and `Component/AddComponentLandingPage` for system master pages). Moving: `Component/SwitchComponent` (Action = `UP`/`DOWN`/`LEFT`/`RIGHT`). Deleting: `Component/DelComponent`. Per-component padding/border/style: `Component/saveComponentConfig`. Theme column layout: `Theme/setLayout` (+ `Theme/getLayoutPCAll` / `getLayoutMobileAll` / `getLayoutTabletAll`). C# handlers are `Controllers/ComponentController.cs` (`AddComponent` line 157, `AddComponentLandingPage` 252, `SwitchComponent` 332, `DelComponent` 342) and `Controllers/ThemeController.cs` (setLayout / getLayout*).

## Gotchas / multi-tenant notes
- **One page + one language at a time.** Layout mode edits a single `pageId`; the language is `DefaultLanguage` resolved from the URL/cookie. Components are stored per language, so content added in one language won't appear under another.
- **Sections vs components.** A "section" is itself a special Layout *component* (the `L0`–`L11` column templates). Regular components get dropped either at a top-level page position or *inside* a section column (`#Lay<positionIndex>_<RefID>`). Nesting a Layout inside a Layout is explicitly disallowed (checked via `boderedlayout` class / `Lay` id and rejected with a toast).
- **Drop target types.** `Drop.js` distinguishes three drop zones: `#pos…` (top-level position, `typeDrop=1`), an existing component's insert handle (`…Top`, `typeDrop=2`, carries `Reorder`), and a Layout column (`typeDrop=3`, carries the column `RefID`). Getting the wrong drop target is the usual cause of a component landing in an unexpected spot.
- **Move (Left/Right) only inside sections.** The Left/Right buttons render only when `RefID2` is set, i.e. the component is inside a multi-column section; a component at a top-level position only has Up/Down.
- **Config-gated palette items, not domain whitelists.** Which components appear in the palette is driven by per-domain config flags (`Domain.bCommerce`, `Config.bEsim`, `bJewelryManagement`, `bCustomBookingByDate`, `bCustomExcelSearch`, `bMemberCoursesSystem`, `Config.Optimization.bAdvanceOptimize`/`bFormOptimize`). This is the correct per-domain-toggle pattern (no hardcoded DomainID whitelist was found in these sources).
- **Save then Apply/Publish.** Component add/move/delete persist immediately, but pushing changes live still goes through the platform's Apply/publish step (panel 3 has a per-page "Publish All Content"); "saved but the live site didn't change" usually means publish wasn't run.
- **The catch-all SPA trap.** `layoutmanager` is a client AngularJS hash route, not a server controller route. If `RenderPartialFileLayout` ever returns the SPA shell instead of the page markup, suspect a routing/whitelist issue (see the RouteConfig controller-whitelist note in the project CLAUDE.md).
