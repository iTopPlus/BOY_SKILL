# Admin Backend — Navigation & Conventions

## Entering the admin (manage mode)

1. Open the tenant's site, e.g. `https://demo110.itopplus.com/`.
2. Log in at `https://demo110.itopplus.com/login`. (On local dev the username
   and password are **pre-filled** — just submit the form.)
3. Append `?manage=true` to the site root to load the backend shell:
   `https://demo110.itopplus.com/?manage=true`.

The backend renders as an AngularJS single-page app (`ng-app="iTopPlusApp"`) with a
left **sidebar** of feature sections and a top bar. The public site and the backend
share the same URL space; `?manage=true` is what flips the page into manage mode.

## Sidebar map

Labels come from `ScriptRequire/domains/language/menu-by-language/menuSlideBarNameByLanguage.js`
(the backend supports a TH/EN toggle).

| English label | Thai label | Reference |
|---|---|---|
| Website Settings | ตั้งค่าเว็บไซต์ | *(top-level sidebar group heading — contains the items below)* |
| Theme Manager | เลือกรูปแบบเว็บไซต์ | `theme-manager.md` |
| Banner Manager | ตั้งค่าแบนเนอร์ | `banner-manager.md` |
| Menu Manager | เลือกรูปแบบเมนู | `menu-manager.md` |
| Page Setting | ตั้งค่าทั่วไป | `web-config.md` *(this is the `#!/WebConfig` panel)* |
| Page Manager | สร้างหน้าเพจ | `pages.md` |
| Layout Manager | จัดการข้อมูลเว็บไซต์ | `layout-manager.md` |
| Content Manager | จัดการเนื้อหาระบบ | `content-manager.md` |
| Form Manager | จัดการแบบฟอร์ม | `form-manager.md` |
| Contact Manager | จัดการบัญชีผู้ใช้ | `contacts-members.md` |
| Member Manager | จัดการข้อมูลสมาชิก | `contacts-members.md` |
| Website Statistics | สถิติการเข้าชมเว็บไซต์ | `statistics.md` |
| File Manager | จัดการข้อมูลไฟล์ | `file-manager.md` |
| 360 Image Presentation | 360 Image Presentation | `specialized-modules.md` |
| Custom Booking By Date | Custom Booking By Date | `specialized-modules.md` |
| Digital Business Hub | Digital Business Hub | `specialized-modules.md` |
| Jewelry Management | Jewelry Management | `specialized-modules.md` |
| Advanced Settings | ตั้งค่าขั้นสูง | `seo.md` / `web-config.md` |
| SEO Settings | ตั้งค่า SEO | `seo.md` |
| META Tag Settings | ตั้งค่า META Tag | `seo.md` |
| CSS Settings | ตั้งค่า CSS | `web-config.md` |
| Open API+AI (beta) | Open API+AI (beta) | `open-api.md` |

> Note: **SEO / META Tag / CSS / PDPA** are tabs *inside* the Website Settings panel
> (`Views/Theme/5Options.cshtml`), not separate sidebar destinations. SEO also exists
> per-page in Page Properties — see `seo.md`.

## Route format

- Section route: `…/?manage=true#!/<Section>` (AngularJS `#!` hash route).
  Example: `https://demo110.itopplus.com/?manage=true#!/WebConfig`.
- Page-scoped route: append the page id —
  `…/?manage=true/#!/layoutmanager/<pageId>`.
- Some panels open as a **modal / slide-in** triggered by a sidebar `ng-click`
  rather than their own hash route. Each feature file states which applies.

(A consolidated route quick-reference is at the bottom of this file.)

## Save vs Apply (the two-step that trips people up)

Most panels have a sticky **Save** bar that persists the configuration. A separate,
site-wide **Apply / publish** step pushes saved changes to the live site. When a save
queues a pending publish, an **Apply** overlay appears (driven by the global
`$rootScope.applyReady` flag). The most common "I saved it but the live site didn't
change" cause is that the Apply/publish step was never run.

## Language (TH / EN)

The backend UI language is a per-domain cookie `<DomainID>languageManageBackend`
(default `th`). Admin views bind labels from
`ScriptRequire/domains/language/menu-by-language/*.js` (each file exports `{ th, en }`).
In these references, fields are labelled in **English** with the **Thai** UI string in
parentheses so the field is locatable whichever language the panel is set to.

## Multi-tenant rule

ITOPPLUS is only the example tenant. Every tenant DomainID gets the identical
backend; a feature must work for all domains or be gated by a per-domain admin-toggle
config flag — never an in-code domain whitelist.

## Route quick-reference

All routes are relative to the tenant base, e.g. prefix with
`https://demo110.itopplus.com/?manage=true`. So `#!/PageManager` →
`https://demo110.itopplus.com/?manage=true#!/PageManager`.

**Pages & content**

| Screen | Route | Reference |
|---|---|---|
| Page Manager (page tree) | `#!/PageManager` | `pages.md` |
| Edit a page (layout editor, page-scoped) | `#!/layoutmanager/<pageId>` | `pages.md` / `layout-manager.md` |
| Layout Manager (home page) | `#!/layoutmanager` | `layout-manager.md` |
| Page Properties (per-page settings + SEO) | *modal — gear icon on a page row* | `pages.md`, `seo.md` |
| Content Manager (list) | `#!/Contentmanager` (new `/new`, edit `/edit:contentId`) | `content-manager.md` |

**Site settings & SEO**

| Screen | Route | Reference |
|---|---|---|
| Website Settings / WebConfig (= "Page Setting") | `#!/WebConfig` (tabs `/general`, `/css`, `/pdpa`) | `web-config.md` |
| Website **Logo** (website logo + sticky-menu logo) | `#!/WebConfig` (General tab — *not* `#!/Banner`) | `web-config.md` |
| SEO Settings tab | `#!/WebConfig/seo` | `seo.md` |
| META Tag Settings tab | `#!/WebConfig/meta` | `seo.md` |

**Appearance**

| Screen | Route | Reference |
|---|---|---|
| Theme Manager | `#!/ThemeManage` | `theme-manager.md` |
| Banner Manager | `#!/Banner` (optional `/<themeId>`) | `banner-manager.md` |
| Menu Manager | `#!/Menu` | `menu-manager.md` |

**Data & engagement**

| Screen | Route | Reference |
|---|---|---|
| Form Manager (list) | `#!/FormManagement` | `form-manager.md` |
| Form builder | `#!/generateForm/<formId>` | `form-manager.md` |
| Contact Manager (site-owner profile) | `#!/ManageAccount/` | `contacts-members.md` |
| Member Manager | `#!/Member` | `contacts-members.md` |
| File Manager (member files) | `#!/FileDocumentManage` | `file-manager.md` |
| Image gallery / picker | `#!/Managefile` | `file-manager.md` |
| Comment moderation | `#!/ManageComment` | `comments.md` |
| Website Statistics | `#!/Stats` (Dashboard card `#!/Dashboard`) | `statistics.md` |

**Store / Shopcart**

| Screen | Route |
|---|---|
| Manage Shop hub | `#!/Shopcart` |
| Shop Detail | `#!/Shopcart/DetailShop` |
| General Settings | `#!/Shopcart/GeneralSetting` |
| Payment / Finance | `#!/Shopcart/PaymentSetting` |
| Shipping | `#!/Shopcart/Shipping` |
| Notifications | `#!/Shopcart/AlertShop` |
| Coupon | `#!/Shopcart/couponSetting` |
| Categories & Brands | `#!/Shopcart/Collection` |
| Products | `#!/Shopcart/Product` |
| Attributes | `#!/Shopcart/Attribute` |
| Orders | `#!/Shopcart/Order` |
| New Promotion | `#!/Shopcart/newpromotion` |

See `store-shopcart.md`.

**Specialized modules** (per-domain — only on tenants where enabled)

| Module | Route |
|---|---|
| 360 Image Presentation | `#!/ImageSpinnerManage` |
| Custom Booking By Date | `#!/CustomBookingByDate` |
| Digital Business Hub | `#!/DigitalBusinessHub` |
| Jewelry Management | `#!/JewelryManagement` |
| E-SIM — Settings / Countries / Commodities / Orders | `#!/EsimSettings`, `#!/EsimCountry`, `#!/EsimCommodity`, `#!/EsimOrders` |

See `specialized-modules.md`.

**Open API+AI (beta)**

| Screen | Route | Reference |
|---|---|---|
| API key settings + activity log | `#!/open-api-settings` | `open-api.md` |
| Help center (topics: `?topic=start|mcp|api|skill`) | `#!/api-docs` | `open-api.md` |
| REST base URL / MCP URL / OpenAPI spec (public URLs, not admin routes) | `/itopplus-open-api` · `/itopplus-open-api/mcp` · `/itopplus-open-api/openapi.json` | `open-api.md` |

---

## Feature: Announcement Popup สำหรับ Admin (`feature/admin-announcement-popup`)

เมื่อ admin login เข้าหลังบ้าน จะมี modal popup แสดง announcement จาก iTopPlus โดยอัตโนมัติ รองรับหลาย announcement, carousel รูปภาพ, lightbox, และ badge แจ้งเตือนบน navbar ไม่มีหน้า admin สำหรับสร้าง announcement — ข้อมูลถูก author ในฐานข้อมูล PoolNode โดยตรง

### วิธีเข้าถึง

- **Popup:** แสดงอัตโนมัติเมื่อ login เข้า `https://demo110.itopplus.com/?manage=true` หากมี announcement ที่ยังไม่เคยดู
- **เปิด popup ซ้ำ:** คลิกไอคอน bell/megaphone (🔔) บน navbar ด้านบน → dropdown แสดงรายการ → คลิก announcement ที่ต้องการ

### พฤติกรรม

| ลักษณะ | รายละเอียด |
|---|---|
| แสดงอัตโนมัติ | Popup เปิดเมื่อ login ถ้ามี announcement ที่ browser ยังไม่ dismiss |
| Badge count | ตัวเลข unread บน nav bell icon (อ้างอิงจาก `$rootScope.announcementBadge`) |
| Carousel | รูปภาพใน announcement เล่น auto-slide ทุก 4 วินาที; swipe touch/mouse ได้ |
| Lightbox | คลิกรูปใน body เพื่อดูแบบ full-screen |
| Dismiss จำไว้ | การปิด popup บันทึกใน `localStorage` key `dismissedAnnouncements` ต่อ browser |
| Filter โดย site type | `ShowOnDemo` (demo*.itopplus.com), `ShowOnLab` (lab*.itopplus.com), `ShowOnReal` (production) |

### Key JS (for developers)

| Symbol | File | บทบาท |
|---|---|---|
| `AnnouncementController` | `ScriptRequire/System/Announcement/Controller.js` | AngularJS controller หลัก |
| `$scope.loadAnnouncements()` | Controller.js | fetch lite list, กรอง site type, คำนวณ badge |
| `$scope.hydrate(id)` | Controller.js | lazy-fetch content+images รายตัวเมื่อเปิด popup |
| `$scope.nextImage()` / `prevImage()` / `goImage(i)` | Controller.js | navigate carousel + restart auto-slide timer |
| `isDemoOrLab()` / `isReal()` | Controller.js | ตรวจ hostname เทียบ `/^demo\d*\./` / `/^lab\d*\./` |
| `readDismissed()` / `writeDismissed(map)` | Controller.js | localStorage persistence |
| `announcementSwipe` directive | Controller.js | pointer/touch drag → publish `$scope.dragOffsetPx` |
| `AnnouncementService.getActiveLite()` | `Service.js` | `GET /Announcement/GetActive` |

### C# Endpoints

- `POST /Announcement/GetActive` — proxy `GET {nodejs}/announcement/list` จาก PoolNode; return `[]` ถ้า timeout (silent fail)
- `GET /Announcement/GetImage?id=…` — proxy GridFS image จาก PoolNode (หลีกเลี่ยง CORS)


### Gotchas

- **PoolNode ล่ม** → popup ไม่แสดง แต่ admin ยังใช้งานได้ปกติ (silent fail ไม่ throw error)
- **Private/incognito mode** → `localStorage` อาจ block → announcement จะแสดงซ้ำทุก login (try/catch แล้ว)
- **hostname filter เข้มงวด** — `demo.customer.com` จะไม่ถูก detect ว่าเป็น demo site (ต้อง prefix `demo` ต่อ `.itopplus.com` subdomain เท่านั้น)
- **Infinite carousel seam** — ใช้ `scheduleSilentJump` via `setTimeout` (ไม่ใช่ `$timeout`) เพื่อหลีก digest cycle; มี `isSilentJumping` guard ป้องกัน visual glitch ตอน swipe พร้อมกัน

---

## Feature: Login History (`feature/login-history-admin-page`)

เพิ่มหน้า **Login History** ใหม่ใน admin sidebar สำหรับดู log การ login ทั้งหมดในระบบ แสดงรายการแบบ paginated พร้อมวันเวลา, username, IP address และ device/browser

### วิธีเข้าถึง

- **Route:** `https://demo110.itopplus.com/?manage=true#!/LoginHistory`
- **Sidebar:** อยู่ในกลุ่ม Settings / System (ตั้งค่าระบบ)

### พฤติกรรม / Fields

| Column | รายละเอียด |
|---|---|
| วันเวลา (Date/Time) | Timestamp ของการ login แต่ละครั้ง (แสดงใน local timezone — ดูหัวข้อถัดไป) |
| Username | ชื่อผู้ใช้ที่ login |
| IP Address | IP ของ client ที่ login |
| Device / Browser | User-agent string แสดง device และ browser ที่ใช้ |

- แสดงผลแบบ paginated list
- View: `ViewLoginHistory.cshtml`
- Controller: `System/Login/History/Controller.js`
- Backend endpoint: `GET /GetLoginHistory` ใน `LoginController.cs`

### Gotchas

- หน้านี้เป็นหน้าใหม่ — ถ้า sidebar ไม่แสดง ให้ตรวจสอบว่า route `#!/LoginHistory` ถูก register ใน `Server.js` แล้ว

---

## Feature: Login History — UTC Timestamp Fix (`feature/login-history-utc-timestamp`)

แก้ bug เวลา login ใน Login History แสดงเป็น UTC raw (เวลาไม่ตรง timezone ของผู้ดูแล) — เปลี่ยนให้แปลงเป็น local timezone ของ browser ก่อนแสดงผล

### วิธีเข้าถึง

- ทำงานอัตโนมัติ — ไม่มี admin toggle หรือ config ใหม่
- ผลลัพธ์เห็นได้ที่: `?manage=true#!/LoginHistory`

### พฤติกรรม

- เวลาที่แสดงใน Login History ตอนนี้ตรงกับ timezone ของ browser ที่กำลังดูอยู่ (แทนที่จะเป็น UTC raw)
- fix ทำงานฝั่ง client-side โดย JavaScript แปลง UTC timestamp เป็น local time ก่อน render

### Gotchas

- ถ้า browser ของ admin ตั้ง timezone ต่างกัน เวลาที่แสดงก็จะต่างกัน — ซึ่งเป็นพฤติกรรมที่ถูกต้องตาม spec
