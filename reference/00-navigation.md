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
