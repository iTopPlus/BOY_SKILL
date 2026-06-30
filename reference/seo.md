# SEO Settings (ตั้งค่า SEO)

## What it does
Controls how the site appears to search engines and social shares: the site-wide SEO defaults (Title / Keywords / Description, robots.txt, llms.txt) and the META Tag scripts (GTM, Analytics, Facebook/remarketing, LINE Tag, custom JS) live on the Website Settings page; each individual page can then override the defaults with its own Title / Keywords / Description / URL-rewrite / Canonical / Facebook share image via the per-page properties modal.

## How to get there
- **Sidebar (site-wide):** Website Settings (ตั้งค่าเว็บไซต์) > the **SEO Settings** (ตั้งค่า SEO) tab and the **META Tag Settings** (ตั้งค่า META Tag) tab on the Web Config page. (Sidebar labels come from `menuSlideBarNameByLangauge.SEOSettings` / `.metaSettings`.)
- **Route (site-wide):** `https://demo110.itopplus.com/?manage=true#!/WebConfig` — then click the **SEO Settings** or **META Tag Settings (GTM,Pixel,Script)** tab. (The hash route `/WebConfig/:tab?` loads `Views/Theme/5Options.cshtml`; the SEO/META tabs are Bootstrap tab-panes `#seo` and `#meta` inside that one view.)
- **Per-page SEO:** opens as a **modal**, not a route. Trigger the gear icon (`<span class="glyphicon glyphicon-cog">`) on a page row in the Layout Manager / page sidebar — `ng-click="$root.openPagePropertiesModal('<pageId>')"`. The modal (`Views/Page/_PagePropertiesModal.cshtml`) embeds `Views/Page/2MainDetail.cshtml`, whose Kendo tab strip has a **SEO** tab and an **Additional Settings** tab. Page-edit context: `https://demo110.itopplus.com/?manage=true#!/layoutmanager/<pageId>`.

## Fields on the screen

### Site-wide — SEO Settings tab (`#seo`)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Title (Website Name) / Title (ชื่อเว็บไซต์) | text input (`config.Title`, maxlength 300) | Default `<title>` / SEO title for the whole site | Per-page Title overrides this unless the page opts out |
| Keywords (Search Terms) / Keywords (คำค้นหา) | textarea (`config.Keywords`, maxlength 300) | Default meta keywords | — |
| Description (Details) / Description (รายละเอียด) | textarea (`config.Description`, maxlength 400) | Default meta description | — |
| Custom Robots.txt / กำหนด Robots.txt | textarea (`config.CustomRobots`) | Extra directives **appended after** a fixed default block shown read-only above the box | Default block (Disallow /login, /theme, /page, … + `Sitemap:`) is always emitted by the server; you only add to it. Served at `/robots.txt`. |
| Custom llms.txt / กำหนด llms.txt | textarea (`config.CustomLlms`) | Body served at `/llms.txt` for LLM crawlers | Empty = endpoint returns **404** (disabled) |
| Custom llms-full.txt / กำหนด llms-full.txt | textarea (`config.CustomLlmsFull`) | Body served at `/llms-full.txt` | Empty = **404** (disabled) |
| Update Sitemap / อัพเดท Sitemap | button (`ng-click="UpdateSitemap()"`) | Regenerates `sitemap.xml` on demand (calls PoolNode `sitemap/genAllSitemap`) | Action button, not a saved field. Toast on success. |

### Site-wide — META Tag Settings tab (`#meta`)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| 1. META TAG (HEAD, GTM 1st script, Google Analytics) | rich/code textarea (`config.FooterMessage`, id `codemeta`) | Injected into `<head>` | Free-form HTML/JS — bad markup can break the site |
| 2. BODY TAG (Remarketing Tag, GTM 2nd script) | code textarea (`config.RemarketingScript`, id `coderemarketing`) | Injected after `<body>` | Can be auto-disabled by the PDPA cookie toggle (`bDisableCookieByDefault`) |
| 3. JavaScript Configuration (custom JS) / การตั่งค่า Java script | code textarea (`config.CustomScript`, id `codejs`) | Site-wide custom JS; no `<script>` tag needed | Marked dangerous in-UI; wrong code breaks rendering |
| 4. LINE Tag ID / {{websiteSettingByLangauge.lineTagID}} | text input (`config.lineTagID`, maxlength 36) | LINE Tag (LINE Ads) tracking ID | UUID format validated client-side via `isValidLineTagId()`; red border on bad format |

### Per-page — SEO tab (`2MainDetail.cshtml` SEO panel)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Page Title / ชื่อหัวข้อของเพจ(Title) | text input (`SelectPageConfig.Title`, maxlength 300) | This page's `<title>` / SEO title | Overrides site Title for this page |
| Keywords (use comma to separate) / คำค้นหาใช้ ,เพื่อแยกคำ(Keywords) | text input (`SelectPageConfig.Keywords`, maxlength 300) | Page meta keywords | — |
| Menu Display Name (Description) / ชื่อที่แสดงในเมนู(Description) | textarea (`SelectPageConfig.Description`, maxlength 400) | Page meta description | Label text is misleading ("Menu Display Name") but binds to the SEO Description |
| Menu Display Name (Alt/Title/UrlRewrite) / ชื่อที่แสดงในเมนู(Alt / Title / UrlRewrite) | text input (`SelectPageConfig.URLRewrite`, maxlength 100) | URL-rewrite / alt / title slug for the page | — |
| Enable Canonical Tag (URL) / เปิดใช้งาน Canonical Tag(URL) | text input (`SelectPageConfig.CanonicalURL`, maxlength 300) | Sets `<link rel="canonical">` for the page | Wrapped in `.bItpCanonical` (visibility may be gated per domain) |

### Per-page — Additional Settings tab (SEO-relevant fields)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Image displayed when sharing on Facebook / ภาพแสดงผลเมื่อแชร์บน facebook | file upload (`#fileuploadfacebook` → `SelectPageConfig.OGFacebook`) | Per-page Open Graph share image | This is the only OG field; there is **no** site-wide OG image field in the SEO tab |
| This page does not display SEO / เพจนี้ไม่แสดงผล SEO | checkbox (`SelectPageConfig.notUseSeoDefault`) | When checked, the page does not inherit the site SEO defaults | Controller checks `if (!notUseSeoDefault)` before applying site defaults to the page |

## Common tasks

### Set the site's default Title / Description / Keywords
1. Go to `?manage=true#!/WebConfig`.
2. Click the **SEO Settings (ตั้งค่า SEO)** tab.
3. Fill **Title**, **Keywords**, **Description**.
4. Save (Web Config save bar) — flows to `localconfig/saveConfigAsync`.

### Add Google Tag Manager / Analytics / Facebook Pixel / remarketing
1. `?manage=true#!/WebConfig` > **META Tag Settings (GTM,Pixel,Script)** tab.
2. Put head-level snippets (GTM 1st script, GA, Pixel base code) in box **1. META TAG (HEAD)** → `config.FooterMessage`.
3. Put body-level snippets (GTM 2nd `<noscript>`, remarketing) in box **2. BODY TAG** → `config.RemarketingScript`.
4. Save.

### Override SEO for a single page
1. In Layout Manager / page sidebar, click the gear icon on the page row (`openPagePropertiesModal`).
2. In the modal, open the **SEO** tab.
3. Set the page-specific Title / Keywords / Description / Canonical.
4. (Optional) On **Additional Settings**, upload the Facebook share image, or tick **This page does not display SEO** to suppress defaults.
5. Click **Save Data (บันทึกข้อมูล)**.

### Add custom robots.txt rules / enable llms.txt
1. `?manage=true#!/WebConfig` > **SEO Settings** tab.
2. The default robots block is shown read-only; type extra directives into **Custom Robots.txt** (they are appended).
3. To enable `/llms.txt` or `/llms-full.txt`, paste content into those boxes (empty = 404).
4. Save. Verify at `https://demo110.itopplus.com/robots.txt` and `/llms.txt`.

### Regenerate the sitemap
1. `?manage=true#!/WebConfig` > **SEO Settings** tab.
2. Click **Update Sitemap (อัพเดท Sitemap)**; wait for the success toast.

## Wired in (for developers)
- **View(s):**
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Theme/5Options.cshtml` — `#seo` tab (lines ~1007–1063) and `#meta` tab (~1065–1116).
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Page/_PagePropertiesModal.cshtml` — modal shell; includes `Page/GotoView?ViewData=2MainDetail`.
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Page/2MainDetail.cshtml` — per-page SEO tab (~53–83) + Additional Settings / OG image (~85–258).
- **Controller / script:**
  - Site-wide: `ScriptRequire/System/BannerConfig/Controller.js` (`BannerConfigController` — `saveData`, `UpdateSitemap`); `ScriptRequire/System/BannerConfig/Service.js` (`genAllSitemap`); save via `ScriptRequire/System/BannerConfig/Banner/Service.js`.
  - Per-page: `ScriptRequire/System/PagePropertiesModal/Controller.js` + `index.js` (`openPagePropertiesModal`, `SaveConfig`).
  - Route: `ScriptRequire/MainSystem/Routing/Server.js` — `.when('/WebConfig/:tab?', …)`.
  - Sidebar labels: `ScriptRequire/domains/language/menu-by-language/menuSlideBarNameByLangauge.js` (`SEOSettings`, `metaSettings`).
- **Save endpoint:**
  - Web Config (all `config.*` SEO/META fields): `localconfig/saveConfigAsync` → `Controllers/LocalConfigController.cs` (escapes `CustomRobots` / `CustomLlms` / `CustomLlmsFull` `&`→`<!ampersand!>`, `+`→`<!plus!>`) → `Config.getQueryString()` → PoolNode `saveConfig`.
  - Sitemap: `sitemap/genAllSitemap` → PoolNode `Global/sitemap.js` (`genAllSitemap` / `genAllSitemapMT`); sitemap domain at `LocalService/src/domains/sitemap/sitemap.domain.js`.
  - Public serving (C#, not PoolNode): `Controllers/FilesController.cs` — `robots()` (emits fixed default block + `config.CustomRobots`; non-itopplus.com hosts only, otherwise full Disallow), `llms()` / `llmsFull()` (404 when config empty).

## Gotchas / multi-tenant notes
- **Site default vs. per-page override:** `config.Title/Keywords/Description` are the site-wide fallback. Each page's `SelectPageConfig.Title/Keywords/Description` override them for that page; ticking **This page does not display SEO** (`notUseSeoDefault`) makes the page skip the site defaults entirely (controllers guard with `if (!notUseSeoDefault)`).
- **No site-wide OG/Pixel field as a discrete control:** the SEO tab has Title/Keywords/Description/Robots/llms only. Open Graph image is **per-page** (`OGFacebook` upload). Facebook Pixel / GTM / GA are entered as raw script in the META tab (`FooterMessage` = head, `RemarketingScript` = body), not as dedicated ID fields. The only dedicated tracking-ID field is **LINE Tag ID** (`lineTagID`).
- **robots.txt host gating:** `FilesController.robots()` branches on `Request.Url.AbsoluteUri.Contains("itopplus.com")` — for the platform's own `*.itopplus.com` preview/builder hosts it returns a full "Disallow: /" for all major bots; real tenant domains get the normal block + the tenant's `CustomRobots`. This is platform-vs-tenant gating (intentional), not a per-tenant whitelist.
- **CustomRobots is append-only:** the fixed default Disallow block is always emitted by the server; the admin box cannot remove those defaults, only add to them.
- **Character escaping on save:** `&` and `+` inside CustomRobots/CustomLlms/CustomLlmsFull are stored as `<!ampersand!>` / `<!plus!>` placeholders by `LocalConfigController` (presumably reversed on render) — don't be surprised to see placeholders in the raw stored config.
- **BODY TAG vs PDPA:** the PDPA tab's `bDisableCookieByDefault` can disable the BODY TAG (`RemarketingScript`, GTM 2nd script) for consent compliance — a remarketing/GTM tag that "isn't firing" may be suppressed by PDPA rather than mis-entered.

## Uncertainties
- The exact public-render wiring of `config.Title/Keywords/Description/CanonicalURL/OGFacebook` into the rendered `<head>` (and bot/SEO render) was not traced; the PoolNode `Local/render/seo/` directory exists (`index.js`) but its read of these fields was not opened. Treat the "Effect" column as the field's intent, verified at the config layer, not at the final HTML output.
- `2MainDetail.cshtml` is included via `Page/GotoView?ViewData=2MainDetail` (and referenced from `_PagePropertiesModal.cshtml`); confirmed it holds the per-page SEO fields, but the GotoView resolution to this exact file is inferred from the matching filename/scope, not from reading GotoView.
- `.bItpCanonical` / `.bItpCustomURL` wrapper classes suggest per-domain visibility toggles for the Canonical / Custom-URL fields; the toggling logic was not traced.
