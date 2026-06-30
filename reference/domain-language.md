# Domain & Language Settings (ตั้งค่าทั่วไป / Advanced Settings)

## What it does
Platform-level site settings: the domain/site info shown in the admin sidebar (website name, domain, storage usage) plus the language-support section where you enable which languages the public site offers and pick the **Default Language**. Adding/removing a language and changing the default rewrites the config's `LangEnable` list, which drives every public render.

## How to get there
- **Sidebar:** Website Settings (ตั้งค่าเว็บไซต์) > Page Setting (ตั้งค่าทั่วไป) — the gear/"webpage_04" icon labelled `{{menuSlideBarName.settings}}`. The language section sits inside the **General Settings** tab under the heading "Language Settings" (กำหนดตั้งค่าทั่วไปของเว็บไซต์). The domain/site info (website name, domain, storage) is rendered at the top of the sidebar itself, above the menu list.
- **Route:** `https://demo110.itopplus.com/?manage=true#!/WebConfig` (renders `Views/Theme/5Options.cshtml`, controller `BannerConfigController`). The same page has tabs `#!/WebConfig/seo`, `#!/WebConfig/meta`, `#!/WebConfig/css` exposed in the sidebar's **Advanced Settings** (ตั้งค่าขั้นสูง) group — those tab references are documented with the Web Config / SEO feature, not here.
- Storage usage refresh is an inline sidebar control (no separate route); the "site info" data loads via `Domainname/getDomain` and `Domainname/getStorageUsed`.

## Fields on the screen
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Your Website Name (ชื่อเว็บไซต์ของคุณ) | Read-only label + domain chip | Sidebar header; clicking the domain chip navigates to `?manage=true/#!/MainBackend` | Domain name is server-rendered from `HTTP_HOST` (`@domainName`), not editable here |
| Website Expired Date (วันหมดอายุเว็บไซต์) | Read-only label | Sidebar header (`.mysite-expire`) | Hidden by default (`display:none`); the visible value `01 ตุลาคม 25563` is a hardcoded placeholder in the Razor, not live data |
| Storage (Storage) | Read-only meter + refresh icon | Shows `used MB / limit MB`; refresh icon calls `Domainname/updateStorageUsed` | Limit defaults to 3,000 MB; overridden per-domain by hardcoded promo whitelists (see notes) |
| Available languages (ระบบการรองรับภาษา) | Checkbox list (repeater over `language`) | Each checked flag adds that language to the site; toggling fires `switchLanguage(lang)` which pushes/splices the language in `languageUse` | The list of selectable languages comes from `Localconfig/getLanguage`; the enabled set is the config `LangEnable` array. Unchecking the current default clears `langDefault` |
| Default Language (ภาษาเริ่มต้น) | Dropdown / select (`langDefault`, options = `languageUse`) | Sets which enabled language is the site default; placeholder option "-- Choose Default Language --" (-- เลือก ภาษาเริ่มต้น --) | Only languages already enabled (checked) appear as options. Saving with languages enabled but no default selected → toast "Please select a default language" (กรุณาเลือกภาษาเริ่มต้น) |
| Disable Default Language setting when changing language flag (ปิดตั้งค่า DefaultLangauge เมื่อเปลี่ยนธงภาษา) | Toggle/checkbox (`config.setDefaultLangauge`) | When on, switching the front-end language flag does NOT change the stored default | Container `#itp-set-language` is `display:none` by default in the markup |
| Enable session-based language switching instead of cookie (เปิดใช้งานระบบเปลี่ยนภาษาแบบ Session แทน Cookie) | Toggle/checkbox (`config.bCookieSessionLanguage`) | Language choice persisted in server session instead of a browser cookie | Read at runtime as `ServerData.bCookieSessionLanguage`; also gates the front-end `SwitchLang` cookie write |
| Disable language flag display (ปิดการแสดงผล ธงภาษา) | Toggle/checkbox (`config.bFlag`) | Hides the public language-flag switcher | — |
| Display language flag as text (เปลี่ยนการแสดงผลธงภาษาเป็นตัวอักษร) | Toggle/checkbox (`config.bDisableLanguageFlag`) | Renders the language switcher as text instead of flag images | — |
| Disable special-character URL encoding (ปิดการแปลงอักขระพิเศษใน URL) | Toggle/checkbox (`config.bDisableUrlCharTransform`) | Sends GET data without the `_Sla_`/`_Amp_` transform | Adjacent to the language block in the same General Settings tab |
| Save (บันทึกการตั้งค่า) | Button | Persists the whole config via `Localconfig/saveConfig` | One save button covers the entire General Settings tab, not just the language block |

## Common tasks
### Add (enable) a new site language
1. Go to `?manage=true#!/WebConfig` (Page Setting).
2. In the **General Settings** tab, find the "Language Settings" / "Available languages" block.
3. Tick the checkbox next to the flag of the language you want to enable.
4. Click **Save** (บันทึกการตั้งค่า). The language is pushed into `config.LangEnable` and the public site now offers it.

### Set the default language
1. Enable at least one language (above) — only enabled languages appear in the dropdown.
2. In the **Default Language** dropdown, select the language to use as default.
3. Click **Save**. The selected language gets `DefaultLang: true` in `LangEnable` (all others set to `false`); `DefaultLanguage` is updated and the page persists.

### Remove a site language
1. Untick its checkbox in the "Available languages" block (this splices it out of `languageUse`; if it was the default, `langDefault` is cleared).
2. Re-select a Default Language if needed, then **Save**.

## Wired in (for developers)
- **View(s):** `Views/Theme/5Options.cshtml` (language block ~lines 861-893; the `setDefaultLangauge` / session-language toggles ~lines 70-77, 289-294). Domain/storage sidebar header: `Views/LayoutManager/_SlideBarHomeNew.cshtml`.
- **Controller / script:**
  - `ScriptRequire/System/BannerConfig/Controller.js` (the `BannerConfigController` bound to `#!/WebConfig`) — owns `switchLanguage`, `langDefault`, `languageUse`, and builds `config.LangEnable` in the save handler (~lines 990-1055).
  - `ScriptRequire/System/Language/Service.js` (`LanguageService`) — `getLanguageAsync` → `Localconfig/getLanguageAsync` (active langs), `getLanguageAll` → `Localconfig/getLanguage` (all langs), `setLanguage` → `Localconfig/setLanguageAsync?languageid=...` (front-end flag switch).
  - `ScriptRequire/System/Domain/Service.js` (`DomainService`) — `getDomain` → `Domainname/getDomain`, `getStorageUsed`/`updateStorageUsed` → `Domainname/...`, consumed by `SidebarNewController` (`ScriptRequire/MainSystem/Controller/SlidebarNew/index.js`) for the storage meter and `MainBackendController` on load.
  - `ScriptRequire/System/LangSetting/Service.js` (`LanguageSettingService.getCmpLangSetting` → `Language/getCmpLangSetting`) — fetches per-component language strings; used by shopcart/form backends, NOT by this add/enable-language UI.
  - Front-end language switch & 3-cache behavior: `ScriptRequire/MainSystem/Controller/Global/Language/Controller.js` (`SwitchLang`).
  - Labels: `ScriptRequire/domains/language/menu-by-language/website-setting.js` (`websiteSettingByLangauge`: `generalWebsiteSetting` = "Language Settings", `languageSupportSystem` = "Available languages", `defaultLanguage` = "Default Language", `chooseLanguage`) and `menuSlideBarNameByLanguage.js` (`websiteName`, `expriedDate`, `websiteInfo`, `websiteSettings`, `advancedSettings`).
- **Save endpoint:** `Localconfig/saveConfig` (C# `LocalConfigController.saveConfig` — `ConfigService.saveConfig(JSON.stringify(config))`). On success it reads `LangEnable.Where(DefaultLang == true)` to set `HtmlHelperExtensions.languageID`, then `updateConfig(jsonObj)`. Front-end flag switch saves nothing to config — it calls `Localconfig/setLanguageAsync`.

## Gotchas / multi-tenant notes
- **3-cache language-default behavior (known issue).** The "default language" choice is mirrored in three independent stores and all three must agree or the rendered site reverts: (1) Mongo `Config.LangEnable[].DefaultLang`, (2) the C# session "Config", and (3) the app-scope `renderConfig` (`<domain>renderConfig` in `RedisServerType.APPLICATION_SCOPE1`). The app-scope `renderConfig` is what actually drives the rendered language site-wide. `saveConfig` calls `CGClass.ClearRedisAll()` + `CGClass.ClearApplicationScope()` and `setLanguageAsync` patches `renderConfig` directly; if a save drops the language selection the cached config must not be re-cached with the loss (fixed in MRs !1509/!1512 + PoolNode `d1c895a2e`; see memory `project_language_default_three_caches`).
- **Default fallback language is hardcoded.** When no `LangEnable` entry has `DefaultLang == true`, both the C# save path and the front-end controller fall back to `523d4c71164185981a000001` (Thai). The Thai/English admin-UI ternaries throughout also key off that exact ID.
- **Hardcoded-domain storage whitelists (anti-pattern).** `SlidebarNew/index.js` raises the storage limit for specific `DomainID`s via `byPassThreeGigabytePromotion` (`66c6e9b058af501f001b43ff`), `byPassFiveGigabytePromotion` (`fiveGigDomain` list in `Helper`), and `byPassTenGigabytePromotion` (`673c786f7e28fe20f413e43c`). These per-domain in-code whitelists violate the multi-tenant "no hardcoded-domain logic in shared code" rule and should be config-flag driven.
- **Expired-date placeholder.** The sidebar's expiry value (`01 ตุลาคม 25563`) is a hardcoded literal and the block is `display:none` — it is not a live domain field.
- The save button on this page does **not** flip `$rootScope.applyReady` (per the ScriptRequire `applyReady` savebar rule), so any sticky savebar here must omit the `--with-apply` slide-up modifier.
