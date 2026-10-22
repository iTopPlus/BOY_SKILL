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
| Enable Canonical Tag (URL) / เปิดใช้งาน Canonical Tag(URL) | text input (`SelectPageConfig.CanonicalURL`, maxlength 300) | Sets `<link rel="canonical">` for the page. When **left blank**, the system auto-generates a canonical pointing to the clean page URL (stripping `/langXX` suffixes) on every navigation. | Wrapped in `.bItpCanonical` (visibility may be gated per domain). Auto-gen happens in `ComponentCtrlV2.js` `LinkCanonicalCreater`; the page-level override is preferred when filled. |

### Shopcart product — Search Engine (SEO) panel
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Canonical URL / Canonical Tag URL | text input (`Shopproduct.canonicalTagUrl`, stored via `getQueryString`) | Sets `<link rel="canonical">` for this product's detail page | When left blank, the system auto-generates a canonical pointing to the **product listing page** URL (smart auto-gen — not the detail page URL). Wired in `ScriptRequire/Store/System/Shopcart/Product/AddProduct/Controller.js`. |

### Automatic hreflang (multi-language sites only)
On sites with **more than one active language**, the system injects a `<link rel="alternate" hreflang="…">` tag into `<head>` for the currently active language. There is **no admin field to fill** — the tag is generated automatically from the canonical URL + the current language's `LocalizationCode`.

| Behaviour | Detail |
|---|---|
| When it fires | Only when `LanguageActive.length > 1` (multi-language domain) |
| `hreflang` value | Current language's `LocalizationCode` (lower-cased), e.g. `th`, `en` |
| `href` value | Canonical URL of the page, with `/langXX` suffix appended if the current URL path ends in `/langXX` |
| Placeholder in `<head>` | `<link id="hreflang-current" rel="alternate" hreflang="" href="">` emitted by `_MetaHead.cshtml` only when the domain has >1 active language |
| Single-language sites | Placeholder is **not** emitted — no hreflang tag appears |

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

### Set Canonical URL for a shopcart product
1. In the admin go to `?manage=true#!/Shopcart/Product/AddProductsV2/<productId>`.
2. Open the **Search Engine (SEO)** panel on the product editor.
3. Fill the **Canonical URL** field. Leave blank to let the system auto-point to the listing page URL.
4. Save the product.

### Check or verify hreflang (multi-language sites)
No admin action is required — the tag is auto-injected. To verify:
1. Open the public site with DevTools Network → view page source or Elements panel.
2. Look for `<link id="hreflang-current" rel="alternate" hreflang="th" href="…">` (or `en`, etc.) in `<head>`.
3. The tag only appears on sites with ≥ 2 active languages (set via `?manage=true#!/WebConfig` > Available languages).

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

---

## Feature: Auto Generate Canonical Tag (URL) (`feature/autogen-canonical-setting`)

เพิ่ม toggle ระดับ site ใน Website Settings สำหรับให้ระบบสร้าง canonical tag อัตโนมัติบนทุกหน้าที่ยังไม่ได้กำหนด Canonical URL ด้วยตัวเอง URL ที่ generate จะอยู่ในรูป `https://[www.]domain/PageName/PageID`

### วิธีเข้าถึง

**Toggle ระดับ site:**
- Route: `https://demo110.itopplus.com/?manage=true#!/Theme` → tab Options (General Settings)
- Field label (TH): "เปิดใช้งาน Auto Generate Canonical Tag (URL) สำหรับหน้าที่ไม่ได้กำหนด Canonical เอง"
- ng-model: `config.bAutoGenCanonical` (checkbox)

**Per-page Canonical URL:**
- Route: `https://demo110.itopplus.com/?manage=true#!/Page` → เลือกหน้า → tab SEO
- Field: Canonical URL input — เมื่อ `bAutoGenCanonical = true` จะแสดง placeholder เป็น URL ที่จะถูก generate, พร้อม Copy + Reset button

### Fields ในหน้า Page Manager (เมื่อ bAutoGenCanonical = ON)

| Field / Control | Type | ng-model | หมายเหตุ |
|---|---|---|---|
| Canonical URL | text input | `SelectPageConfig.CanonicalURL` | ถ้าเว้นว่าง = ใช้ auto-gen; กรอกเองเพื่อ override |
| (Placeholder) | auto text | — | แสดง URL ที่ระบบจะ generate โดย `buildAutoCanonical()` |
| Copy | button | — | copy auto-gen URL ไป clipboard; แสดง "Copied!" 2 วินาที |
| Reset | button | — | เคลียร์ manual URL กลับเป็น auto-gen |
| Hint text | info label | — | "Auto generate will apply when this field is empty" |

### Logic การ generate URL

```
https://[www.]domain/encodedPageName/pageId
```

- เว้น `www.` ถ้า domain มี `itopplus.` หรือ `theiconweb.` หรือเป็น `localhost`
- ถ้า `bDisableUrlCharTransform` ON จะแทน `/` ใน pageName ด้วย `_Sla_`
- **Server-side (PoolNode):** `SEORender` ใน `LocalService/src/controllers/Local/render/seo/index.js` inject canonical เข้า `<head>` ก็ต่อเมื่อ `cmpConfig.config.bAutoGenCanonical === true` AND ทั้ง `page.CanonicalURL` และ `PageConfig.CanonicalURL` ว่างเปล่า

### C# Model + PoolNode

- **C# `Config.cs`:** เพิ่ม `public bool bAutoGenCanonical { get; set; }` + ต่อ `getQueryString()` → `&bAutoGenCanonical=true/false`
- **PoolNode `DB.js` `ConfigSchema`:** เพิ่ม `bAutoGenCanonical: Boolean`
- **PoolNode `config.js`:** `saveConfig` parse string `'true'`/`'false'` → store; default `false` ถ้าไม่มีใน body

### Wired in (for developers)

- **Admin JS:** `ScriptRequire/System/PageManager/Controller.js`
  - `$scope.buildAutoCanonical(pageName, pageId)` — build URL string
  - `$scope.copyAutoCanonical(pageName, pageId)` — copy to clipboard + feedback
  - `$scope.canonicalCopied` — bool สำหรับ "Copied!" label
  - Save validation: ถ้า `CanonicalURL` ไม่ว่างและลงท้ายด้วย special char (`[^a-zA-Z0-9฀-๿]$`) → toastr warning + abort save
- **Views:** `Views/Page/2MainDetail.cshtml` — Canonical input + dynamic placeholder + Copy/Reset div (ซ่อนเมื่อ `bAutoGenCanonical = false`)
- **Views:** `Views/Theme/5Options.cshtml` — checkbox toggle ในแท็บ General Settings

### Gotchas

- **`www.` prefix เช็คทั้งฝั่ง frontend และ PoolNode** — logic เหมือนกัน ถ้า DomainName มี `www.` อยู่แล้วและ domain ไม่ match pattern จะไม่ double prefix (guard `dn.indexOf('www.') === -1`)
- **Empty-only activation** — แค่ space เดียวใน Canonical URL ก็ bypass auto-gen ของหน้านั้น
- **บังคับ false เมื่อ upgrade** — `saveConfig` default `false` ถ้าไม่มี key → enable แบบ opt-in ไม่มีผลกระทบต่อ site เก่า
- **ทำงานเฉพาะ page ที่มี object `page`** — home/special routes ที่ไม่มี page object จะไม่ได้รับ canonical inject

---

## Feature: กำหนด Primary URL สำหรับบทความและสินค้า (`feature/seo-primary-url-toggle`)

เพิ่ม toggle ระดับ site ให้ admin กำหนด **primary URL เดียว** สำหรับ article/product ป้องกัน duplicate content โดย inject canonical tag ฝั่ง server และส่ง 301 redirect จากหน้าอื่นที่ชี้ content เดียวกันไปยัง primary URL

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/WebConfig` → tab **General**
- **Field label (TH):** "กำหนด Primary URL สำหรับบทความและสินค้า"
- **ng-model:** `config.bSeoPrimaryUrl` (checkbox)

### พฤติกรรม / Fields

| Field / Control | Type | ng-model | หมายเหตุ |
|---|---|---|---|
| กำหนด Primary URL สำหรับบทความและสินค้า | checkbox | `config.bSeoPrimaryUrl` | เปิด = ระบบ inject canonical + 301 redirect; ปิด = ปล่อยทุก URL render ตามปกติ |

- เมื่อ `bSeoPrimaryUrl = true` → `HtmlHelperExtensions.cs` inject `<link rel="canonical">` ฝั่ง server-side ให้ทุก article/product page
- URL อื่นที่ชี้ content เดียวกันจะถูก 301 redirect ไปยัง primary URL แทนการ render

### Wired in (for developers)
- **C# `Config.cs`:** `public bool bSeoPrimaryUrl { get; set; }`
- **C# `HtmlHelperExtensions.cs`:** ตรวจ `config.bSeoPrimaryUrl` ก่อน inject canonical tag และ trigger 301 redirect logic
- **View:** `Views/Theme/5Options.cshtml` → General tab

### Gotchas
- ค่า default คือ `false` — ไม่กระทบ site เก่าเมื่ออัปเกรด
- 301 redirect เกิดขึ้น server-side เมื่อ URL ปัจจุบันไม่ตรง primary URL ของ content นั้น
- ควร generate sitemap ใหม่หลังเปิด toggle นี้เพื่อให้ sitemap.xml ใช้ primary URL

---

## Feature: Per-Page noindex/nofollow (`feature/page-noindex-toggle`)

แก้ให้ checkbox **"This page does not display SEO"** บน per-page Additional Settings tab ทำการ inject `<meta name="robots" content="noindex,nofollow">` จริงๆ เข้า `<head>` แทนที่จะแค่ซ่อน SEO defaults อย่างเดิม

### วิธีเข้าถึง
- **Route:** Page Properties modal → **Additional Settings** tab
- เปิด modal ผ่าน gear icon บน page row ใน Layout Manager / page sidebar (`openPagePropertiesModal('<pageId>')`)
- **Field label:** "This page does not display SEO (เพจนี้ไม่แสดงผล SEO)"
- **ng-model:** `SelectPageConfig.notUseSeoDefault` (checkbox)

### พฤติกรรม

| สถานะ checkbox | พฤติกรรมเดิม | พฤติกรรมใหม่ |
|---|---|---|
| ไม่ได้ติก | render SEO defaults ปกติ | เหมือนเดิม |
| ติก | ซ่อน SEO defaults เท่านั้น | ซ่อน SEO defaults **+ inject `<meta name="robots" content="noindex,nofollow">`** |

- `HomeCtrlController.cs` ตรวจ `notUseSeoDefault` flag และ emit noindex meta tag ฝั่ง server-side

### Wired in (for developers)
- **C# `HomeCtrlController.cs`:** เพิ่ม logic ตรวจ `SelectPageConfig.notUseSeoDefault`; ถ้า `true` → emit `<meta name="robots" content="noindex,nofollow">` เข้า response
- **View:** `Views/Page/2MainDetail.cshtml` → Additional Settings tab (checkbox เดิม ไม่ได้เพิ่ม field ใหม่)

### Gotchas
- feature นี้ **ไม่ได้เพิ่ม field ใหม่** — ใช้ checkbox `notUseSeoDefault` ที่มีอยู่แล้ว แต่เพิ่ม server-side behavior
- หน้าที่เคยติก checkbox นี้อยู่แล้วก่อน deploy จะได้รับ noindex tag ทันทีหลัง deploy
- ตรวจสอบได้โดย view-source หน้านั้น หา `<meta name="robots" content="noindex,nofollow">`

---

## Feature: เพิ่ม Disallow: /search ใน robots.txt (`feature/robots-disallow-search`)

เพิ่ม `Disallow: /search` เข้าใน default block ของ robots.txt โดยอัตโนมัติ ป้องกัน search engine crawl ติด facet crawl trap จาก URL ที่มี query parameter search

### วิธีเข้าถึง
- **ไม่มี admin toggle** — ทำงานอัตโนมัติ
- ผลลัพธ์ดูได้ที่ `https://[yourdomain]/robots.txt`

### พฤติกรรม

- `Controllers/FilesController.cs` เพิ่ม 1 บรรทัด `Disallow: /search` เข้า default block ที่ emit ทุกครั้ง
- ไม่กระทบ `config.CustomRobots` — ยังใช้ append rules เพิ่มเติมได้ตามปกติ
- default block (ที่รวม `/search` แล้ว) จะปรากฏในส่วน read-only ของ **Custom Robots.txt** field ใน `?manage=true#!/WebConfig` > SEO Settings tab

### Wired in (for developers)
- **C# `Controllers/FilesController.cs`:** `robots()` action — เพิ่ม `sb.AppendLine("Disallow: /search")` ใน default Disallow block

### Gotchas
- เป็นการแก้ **default block ซึ่ง admin ไม่สามารถแก้ไขได้** ผ่าน Custom Robots.txt box (box นั้น append เท่านั้น)
- ถ้า site มี URL `/search` ที่ต้องการให้ index ได้ ต้องติดต่อ iTopPlus support เพื่อ override

---

## Feature: Sitemap/Feed ใช้ Scheme จาก Request จริง (`feature/sitemap-feed-respect-scheme-type`)

แก้ bug ที่ sitemap.xml และ product feed URLs ใช้ HTTP แทน HTTPS (หรือกลับกัน) โดยแก้ logic ใน `HtmlHelperExtensions.cs` ให้ดึง scheme จาก request จริงแทนที่จะ hardcode

### วิธีเข้าถึง
- **ไม่มี admin toggle** — ทำงานอัตโนมัติ
- ตรวจสอบได้ที่ `https://[yourdomain]/sitemap.xml` และ product feed URLs

### พฤติกรรม

| กรณี | พฤติกรรมเดิม (bug) | พฤติกรรมใหม่ |
|---|---|---|
| Site ใช้ HTTPS | URL ใน sitemap อาจเป็น `http://` | URL ใน sitemap เป็น `https://` ตาม request จริง |
| Site ใช้ HTTP | URL ใน sitemap อาจเป็น `https://` | URL ใน sitemap เป็น `http://` ตาม request จริง |

- `HtmlHelperExtensions.cs` แก้ logic `BuildAbsoluteUrl()` (หรือ method ที่ทำหน้าที่เดียวกัน) ให้อ่าน `Request.Url.Scheme` แทนค่า hardcode
- ผลครอบคลุมทั้ง sitemap.xml และ product/content feed URLs ที่ใช้ helper เดียวกัน

### Wired in (for developers)
- **C# `HtmlHelperExtensions.cs`:** แก้ method build absolute URL ให้ใช้ `Request.Url.Scheme` หรือ `HttpContext.Current.Request.IsSecureConnection`

### Gotchas
- หลัง deploy ควร trigger **Update Sitemap** (`?manage=true#!/WebConfig` > SEO Settings > ปุ่ม "อัพเดท Sitemap") เพื่อ regenerate sitemap.xml ด้วย scheme ที่ถูก
- CDN หรือ reverse proxy ที่ terminate SSL ก่อนถึง app server อาจทำให้ `Request.IsSecureConnection = false` แม้ end-user เห็น HTTPS — ควรตรวจสอบว่า `X-Forwarded-Proto` header ถูก forward มาด้วย


---

## Feature: Redirect URL (301) (`feature/seo-url-redirect-rules`)

### What it does
Admin กำหนดตาราง "URL ต้นทาง -> URL ปลายทาง" ได้เอง เมื่อมีคนหรือ Google เปิด URL ต้นทาง ระบบตอบ **301 (permanent)** ไปยังปลายทาง ใช้กับ URL ของเว็บนี้เท่านั้น ต้องตรงทั้งเส้น (ไม่รองรับ wildcard) และมีผลตอน **โหลดหน้าใหม่** ไม่ใช่ตอนคลิกลิงก์ภายในเว็บ (SPA)

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/WebConfig` -> แท็บ **SEO Settings** (ใต้ Custom llms-full.txt) -> หัวข้อ **Redirect URL (301)**
- **Sidebar:** Website Settings (ตั้งค่าเว็บไซต์) > SEO Settings (ตั้งค่า SEO)

### Fields on the screen
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Enable custom URL redirects / เปิดใช้งาน Redirect URL ที่กำหนดเอง | checkbox (`config.bUrlRedirect`) | เปิด/ปิดทั้งตาราง | ปิดแล้ว rule ยังเก็บไว้แต่ไม่ทำงาน |
| On / เปิด | checkbox ต่อแถว (`rule.bEnable`) | เปิด/ปิดเฉพาะแถว | — |
| Source URL / URL ต้นทาง | text (`rule.source`) | path ของเว็บนี้ เช่น `/old-page` | วางลิงก์เต็มได้ ระบบตัดเหลือ path ให้ (blur/paste); ห้ามมี query string `?...`; ห้ามเป็นหน้าแรก; ห้ามซ้ำกับแถวอื่น; เทียบแบบ lower-case ไม่สน trailing slash |
| Destination URL / URL ปลายทาง | text (`rule.destination`) | path ของเว็บ (`/new-page`) หรือ `http(s)://` ของเว็บอื่น | ต้องขึ้นต้นด้วย `/` หรือ `http(s)://`; ห้ามซ้ำกับต้นทางของแถวเดียวกัน; ห้ามเป็นต้นทางของอีกแถว (จะ redirect ต่อกัน) |
| Note / หมายเหตุ | text (`rule.note`, maxlength 200) | บันทึกช่วยจำ | — |
| Add row / เพิ่มแถว, Remove / ลบแถวนี้ | ปุ่ม | เพิ่ม/ลบแถว | สูงสุด **1,000** รายการ (ปุ่มเพิ่มถูก disable) |
| Search the list / ค้นหาในรายการ | text | กรองตาราง + แบ่งหน้า | — |

แถวที่ผิดแสดงข้อความสีแดง และ Save จะถูกบล็อก ("กรุณาแก้ไขรายการ Redirect URL ที่มีข้อผิดพลาดก่อนบันทึก")

### Wired in (for developers)
- **C#:** `Models/SEO/UrlRedirectRules.cs` (`Resolve`, `Key`, `EncodedPath`); `Models/Config/Config.cs` (class `UrlRedirect {source,destination,bEnable,note}`, `bUrlRedirect`, `UrlRedirects[]`, ส่งใน `getQueryString`); `Controllers/HomeCtrlController.cs` `RedirectToCustomUrl()` (ใช้ `PrimaryUrlLocation()` ที่แยกออกมาจาก `RedirectToPrimaryUrl`)
- **View:** `Views/Theme/5Options.cshtml`
- **JS:** `ScriptRequire/System/BannerConfig/Controller.js` (WebConfig controller), `ScriptRequire/domains/seo/url-redirect.domain.js`, ข้อความใน `domains/language/menu-by-language/website-setting.js` (`urlRedirect*`)
- **Tests:** `Boy_Growth_a_Man_Test/UrlRedirectRulesTests.cs`, `url-redirect.domain.test.js`

### Gotchas
- ทำงานก่อน `bSeoPrimaryUrl` redirect (rule ที่ admin ตั้งชนะอัตโนมัติ) และก่อนเช็ค 404 จึงไม่ตอบ 404
- ทำเฉพาะ GET/HEAD และ **ไม่ทำเมื่อมี `?manage=true`** (admin ยังเข้าหน้าที่เป็นต้นทางได้)
- query string ของผู้เข้าชมถูกส่งต่อ (ถ้าปลายทางไม่มี `?` เอง)
- ตอบ 301 แต่ตั้ง `no-store` เพื่อให้ browser ไม่จำ จึงยกเลิก rule ได้
- Rule C# (`UrlRedirectRules.cs`) และ JS (`url-redirect.domain.js`) ต้องแก้คู่กัน
- ต้อง Save ที่ WebConfig (แล้ว Apply ตามปกติ) จึงมีผล

---

## Feature: Import/Export Redirect URL เป็นไฟล์ (`feature/seo-url-redirect-import-export`)

### What it does
เพิ่มปุ่ม ดาวน์โหลดไฟล์ตัวอย่าง / ส่งออก / นำเข้า ให้ตาราง Redirect URL (301) ใช้ไฟล์ **.xlsx** หรือ **.csv** (ทำฝั่ง browser ทั้งหมด)

### วิธีเข้าถึง
- `?manage=true#!/WebConfig` -> SEO Settings -> Redirect URL (301) -> ปุ่มเหนือตาราง

### Fields on the screen
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Download template / ดาวน์โหลดไฟล์ตัวอย่าง | dropdown Excel/CSV | ไฟล์ตัวอย่าง 2 แถว | — |
| Export / ส่งออก | dropdown Excel/CSV | ส่งออกรายการปัจจุบัน | CSV มี BOM (Excel อ่านไทยได้); cell ที่ขึ้นต้น `= + - @` ถูกใส่ `'` นำหน้ากัน formula |
| Import / นำเข้า | ปุ่ม + file picker | **แทนที่ทั้งหมด** ด้วยข้อมูลในไฟล์ (มี confirm) | หลังนำเข้าต้องตรวจแถวสีแดงแล้วกด **บันทึก** เอง |

คอลัมน์ไฟล์ต้องเป็นลำดับนี้: `Enabled (1/0)`, `Source URL`, `Destination URL`, `Note` แถวแรกเป็น header ที่ต้องตรงเป๊ะ (ไม่สนตัวพิมพ์) ไม่เช่นนั้นไม่นำเข้าอะไรเลย ค่า Enabled ที่ถือว่าปิด: `0, false, no, off, n, ปิด`; แถวที่ไม่มีทั้งต้นทางและปลายทางถูกทิ้ง

### Wired in (for developers)
- `ScriptRequire/domains/seo/url-redirect-file.domain.js` (ใช้ `jszip`; `rowsToCsv/parseCsv/rulesToRows/rowsToRules/hasValidHeader`), `ScriptRequire/System/BannerConfig/Controller.js` (`downloadUrlRedirectTemplate`, `exportUrlRedirects`, `importUrlRedirects`), `Views/Theme/5Options.cshtml`, `website-setting.js` (`urlRedirectTemplate/Export/Import*`), test `url-redirect-file.domain.test.js`

### Gotchas
- รองรับเฉพาะ .xlsx และ .csv; เกินจำนวนสูงสุดจะแจ้งและไม่นำเข้า
- หลัง Import ใช้ validation เดิมของตาราง (แสดงสีแดง) และยังไม่บันทึกจนกว่าจะกด Save

---

## Feature: คำนำหน้า URL บทความ (`feature/seo-article-url-prefixes`)

### What it does
เปลี่ยนคำใน URL บทความได้ 2 แบบ: (1) **Article URL prefix** แทนคำว่า `contents` สำหรับบทความที่ตั้ง Custom Url -> `/{prefix}/{custom-url}` (2) **Article long URL prefix** แทน `รายละเอียด` / `article` สำหรับบทความที่ไม่มี Custom Url (ใช้คำเดียวทุกภาษา) เมื่อบันทึก ลิงก์บทความทั้งเว็บเปลี่ยนเป็นคำใหม่ และลิงก์เดิม (คำที่เคยใช้ รวม `/รายละเอียด/`, `/article/`) **301 redirect** มาคำปัจจุบันอัตโนมัติ

### วิธีเข้าถึง
- `?manage=true#!/WebConfig` -> checkbox ถัดจาก "URL หลักของสินค้าและบทความ (Primary URL)" และก่อน "หน้า 404"
- Content Manager: ใต้ช่อง **Custom Url** ของบทความ มีบรรทัด "ลิงก์บทความ: ..." (preview)

### Fields on the screen
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Change the article URL prefix / เปลี่ยนคำนำหน้า URL บทความ (แทนคำว่า contents) | checkbox `config.bArticleUrlPrefix` + text `config.ArticleUrlPrefix` (maxlength 50) | ตั้งคำแทน `contents` | a-z, 0-9, `-` ยาว 2-50, ห้ามขึ้น/ลงท้ายด้วย `-`; เก็บเป็น lower-case |
| Change the long article URL prefix / เปลี่ยนคำนำหน้า URL บทความแบบเต็ม | checkbox `config.bArticleLongUrlPrefix` + text `config.ArticleLongUrlPrefix` | ตั้งคำแทน `รายละเอียด`/`article` | กฎเดียวกัน; ใช้คำเดียวทุกภาษา |
| Earlier prefixes / คำที่เคยใช้ | read-only (`ArticleUrlPrefixHistory`, `ArticleLongUrlPrefixHistory`) | แสดงคำเก่าที่ 301 มาคำปัจจุบัน | PoolNode เป็นคนเพิ่ม ไม่ส่งกลับตอน save |
| Article link preview / ลิงก์บทความ | help text ใต้ Custom Url (Content Manager) | แสดงลิงก์ที่จะได้ (`articleUrlPreview()`) | แสดงเมื่อมีค่า Custom Url |

ข้อความ error ใต้ช่อง: format ผิด, คำที่ระบบใช้แล้ว (reserved), มีเพจชื่อเดียวกัน, ชนกับ prefix อีกแบบ (ที่เป็นหรือเคยเป็น) Save ถูกบล็อกจนกว่าจะแก้

### Wired in (for developers)
- **C#:** `Models/SEO/ArticleUrlPrefix.cs`, `Models/SEO/ArticleLongPrefix.cs` (Normalize/Validate/Match/Effective/Previous/LegacyWords; reserved list อ่าน `RouteTable` ด้วย), `Models/Config/Config.cs` (+ `getQueryString`), `Controllers/LocalConfigController.cs` (`articleUrlPrefixRefusal` ตอบ `ERROR_ARTICLE_URL_PREFIX:<reason>`; `saveConfigResult`), `Controllers/HomeCtrlController.cs` (301 จากคำเก่า), `Controllers/RenderController.cs` (map prefix กลับเป็น `contents`/`article` ให้ PoolNode), `Controllers/Control/ContentManagerController.cs`, `Models/HtmlHelperExtensions.cs`
- **View:** `Views/Theme/5Options.cshtml`, `Views/Management/ViewContent.cshtml`, `Views/Shared/_LayoutClient.cshtml` + `_LayoutServer.cshtml` (`ServerData.articleUrlPrefix(es)`, `articleLongPrefix(es)`)
- **JS:** `domains/seo/article-url-prefix.domain.js` (กฎเดียวกับ C# และ PoolNode `article-url-prefix.domain.js` ต้องแก้ 3 ที่คู่กัน), `System/BannerConfig/Controller.js` (`checkArticlePrefixes`), `System/PageManager/Controller.js` (`warnIfArticleUrlPrefix`), `Component/Contentmanager/Controller.js`, `MainSystem/Filter/ContentManagerURI.js`, `MainSystem/Routing/Client.js`, `MainSystem/Run/MainAppRun.js`, `domains/seo/content-canonical.domain.js`

### Gotchas
- ตั้งชื่อเพจ/Name/CustomUrlName/URLRewrite ให้ตรงกับ prefix จะขึ้น toast เตือน (ยังบันทึกต่อ) เพราะลิงก์ `/{prefix}/...` จะเปิดเป็นบทความ
- Save ล้มเหลวทั่วไปแสดง "บันทึกไม่สำเร็จ กรุณาลองใหม่อีกครั้ง" (`saveConfigError`)
- ทดสอบ: `ArticleUrlPrefixTests.cs`, `ArticleLongPrefix*Tests.cs`, `article-url-prefix.domain.test.js`

---

## Feature: Canonical ของบทความไม่รับค่าที่ไม่ใช่ URL (`feature/seo-canonical-ignore-non-url`)

### What it does
ช่อง **Canonical Tag** ในบทความ (Content Manager) บางครั้ง admin วาง hashtag/keyword ลงไป ตอนนี้ระบบใช้เฉพาะ URL เต็ม `http(s)://...` หรือ path ที่ขึ้นต้น `/` (วางบน origin canonical ของเว็บ) ค่าอื่นถูกทิ้ง

### วิธีเข้าถึง
- Content Manager (`?manage=true#!/...` หน้าแก้บทความ) -> ส่วน SEO -> **Canonical Tag**

### Fields on the screen
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Canonical Tag | text (`Content.canonicalTagUrl`, placeholder `https://`) | canonical ของบทความ | ค่าที่ไม่ใช่ URL/path ขึ้นข้อความแดง "Canonical Tag ต้องเป็น URL เต็ม (https://...) หรือ path ที่ขึ้นต้นด้วย /" และ server ทิ้งค่านั้น |

### Wired in (for developers)
- `domains/seo/content-canonical.domain.js` (`manualCanonicalUrl`, root-relative branch ใน `primaryCanonicalUrl`), `Component/Contentmanager/Controller.js` (`canonicalTagInvalid()`, `CanonicalMustBeUrl`), `Views/Management/ViewContent.cshtml`

### Gotchas
- path ที่ชี้ไปบทความของตัวเอง (`isOwnArticlePath`) ไม่ถูกใช้เป็น manual override
- `//host/x` ไม่นับเป็น path; ส่วน `#fragment` ถูกตัด
