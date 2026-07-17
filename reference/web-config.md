# Website Settings / WebConfig (ตั้งค่าเว็บไซต์)

## What it does
The Website Settings panel is the single tabbed page where a tenant configures site-wide display options, favicon/logo, supported languages, CSS injection, and PDPA/cookie-consent. It is a five-tab panel (#general, #seo, #meta, #css, #pdpa); this reference covers the **General**, **CSS**, and **PDPA** tabs. SEO and META tabs are documented in `seo.md`.

## How to get there
- **Sidebar:** Settings (ตั้งค่าทั่วไป) — left slidebar gear icon `{{menuSlideBarName.settings}}` linking `#!/WebConfig`. The advanced-settings sub-group of the same slidebar links the deeper tabs directly: SEO Settings (ตั้งค่า SEO) → `#!/WebConfig/seo`, META Tag Settings (ตั้งค่า META Tag) → `#!/WebConfig/meta`, CSS Settings (ตั้งค่า CSS) → `#!/WebConfig/css`. The center settings card (`settingGeneral.cshtml`) also links `#!/WebConfig`.
- **Route:** `https://demo110.itopplus.com/?manage=true#!/WebConfig` (the General tab). Per-tab deep links append the tab slug: `…#!/WebConfig/general`, `…#!/WebConfig/css`, `…#!/WebConfig/pdpa` (also `/seo`, `/meta`). The route is `'/WebConfig/:tab?'` and renders `Views/Theme/5Options.cshtml` with controller `BannerConfigController`. There is no separate PDPA/CSS modal — they are tabs within the same page. (The PDPA rich-text editor and the Promotion preview do open Kendo/`$modal` popups inside the page.)

## Fields on the screen

### General tab (#general — ตั้งค่าทั่วไป / "General Settings")

#### Step 1.1 — General Display (การแสดงผลทั่วไป), left column
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Disable language flag display (ปิดการแสดงผล ธงภาษา) | toggle | Hides the language flag switcher | `config.bFlag` |
| Display language flag as text (เปลี่ยนการแสดงผลธงภาษาเป็นตัวอักษร) | toggle | Renders language switch as text not flag image | `config.bDisableLanguageFlag` |
| Enable session-based language switching instead of cookie (เปิดใช้งานระบบเปลี่ยนภาษาแบบ Session แทน Cookie) | toggle | Language choice stored in session, not cookie | `config.bCookieSessionLanguage` |
| Enable within-page links for content / Slide to Content (เปิดใช้งานลิงก์ภายในหน้าเดียวกันสำหรับเนื้อหา) | toggle | Smooth in-page anchor scrolling | `config.bSlideToContent` |
| Always Ask Captcha (เปิดใช้งาน Captcha ทุกครั้ง) | toggle | Forces captcha on every submission | `config.bAlwaysAskCaptcha` |
| Enable View Counter for Content Manager (เปิดใช้งานตัวนับจำนวนผู้อ่านเนื้อหา) | toggle | Read counter on content listing pages; has help text warning of slower loads on cache miss | **NESTED** under `config.ContentmanagerSettings.bViewCounterContentmanager` (parent object is init-guarded in the controller) |
| Disable printer (ปิดการแสดงผล Printer) | toggle | Hides the print button | `config.bPrinter` |
| Use modern print engine for receipts/labels (ใช้ระบบพิมพ์แบบใหม่ สำหรับใบเสร็จ/ป้ายจ่าหน้า) | toggle | Switches Shopcart receipt/label print engine | `config.bModernPrintingShopcart` |
| Disable scrollbar (ปิดการแสดงผล Scrollbar) | toggle | Hides custom scrollbar | `config.bScrollber` |
| Enable back to top button (เปิดการแสดงผลปุ่ม Back to Top) | toggle + sub-panel | Reveals position radios (left/center/right bottom) + optional own-image upload (`./localconfig/UploadBackToTop/`) | `config.BackToTopNew[0].bBackToTop`, `.backToTopPosition`, `.bBacktoTopImage`, `.BackToTopImage` (array; controller seeds `BackToTopNew[0]`) |
| Enable pop-up banner (การแสดงรูปภาพ เมื่อเปิดเว็บไซต์ / Popup) | toggle + sub-panel | Reveals Flash upload, close-timer, mobile-display toggles, width/height/timer numbers, image upload (`./localconfig/UploadPomotion/`), link/unlink | `config.Pomotion[0].bPopup` etc.; preview opens `CommonPomotion.cshtml` modal |
| Fixed top menu bar / Desktop only (Fixed เมนูด้านบน) | toggle + sub-panel | Pins PC menu; sub-toggle full-screen; optional fixed-menu logo upload (`./FilesRender/UploadFileServer/`) + link | `config.bPcMenuonTop`, `config.bPcMenuonTopFullScreen` (disabled unless bPcMenuonTop), `config.fixedMenuLogo[0].flagShowLogo/.logoImage/.linkLogo` |
| Disable Default Language setting when changing language flag (ปิดตั้งค่า DefaultLangauge เมื่อเปลี่ยนธงภาษา) | toggle | Keeps default language fixed on flag change | `config.setDefaultLangauge`; the row is `display:none` by default (`#itp-set-language`) |
| Enable other format menus (เปิดใช้งานเมนูรูปแบบอื่น) | toggle + dropdown | Reveals a Mega/template menu picker (~38 templates: Sidenav overlay, "Menu with image 1-38", etc.) | `config.bEnableMenuTemplates`, `config.menuTemplateType` (option values are not 1:1 with label numbers — e.g. value 20 = "Type 19 (GEMO HOUSE)") |
| Enable Watermark (เปิดการใช้งาน Watermark) | toggle + sub-panel | Reveals Disable-Resize toggle, frequency radios (one / left-bottom / right-bottom / center-bottom / many), image upload | `config.WatermarkManagement[0].bWatermarkRender/.bDisableResize/.WatermarkFrequency/.WatermarkImage`. Wrapper has class `bHideWatermarkItopplus` |

#### Step 1.1 — right column
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Disable responsive (ปิดการใช้งาน Responsive) | toggle | Turns off responsive layout; shows red warning that per-device settings become unavailable | `config.bResponsive` |
| Disable right click (ปิดคลิกขวาหน้าจอ) | toggle | Blocks context menu on public site | `config.bDisableRightClick` |
| Enable Short URL (เปิดใช้งาน Short URL) | toggle | Enables short URLs | `config.bShortURL` |
| Enable Custom URL (เปิดการแสดงผล URL แบบกำหนดเอง) | toggle | Per-page custom URLs | `config.bCustomPageURL`; wrapper class `bItpCustomURL` |
| Disable Facebook comment tab (ปิดการแสดงผลแถบแสดงความคิดเห็น Facebook) | toggle | Hides FB comments site-wide | `config.bFacebookCommentAll` |
| Enable comment section (เปิดการแสดงผลแถบแสดงความคิดเห็น Comment) | toggle | Enables built-in comments; disabled unless bFacebookCommentAll is on | `config.bGuestBookCommentAll` (ng-disabled on `!config.bFacebookCommentAll`) |
| Enable comment bar for members only (เปิดการแสดงผลแถบแสดงความคิดเห็น Comment สำหรับสมาชิกเท่านั้น) | toggle | Restricts comments to members; disabled unless bFacebookCommentAll | `config.bGuestBookMember` |
| Enable advertising image / YouTube (แสดงรูปโฆษณาหรือวิดีโอ YouTube) | toggle + sub-panel | Reveals image-vs-youtube choice, corner-position radios, size dropdown (small/medium/large), embed textarea or image upload (`./localconfig/UploadAdvertising/`), link/unlink | `config.Advertising[0].bAdvertising/.AdvertisingType/.Position/.Width/.Advertising/.Link` |
| Disable WEBP images (ปิดการทำงานระบบ WEBP format) | toggle | Turns off WebP serving; when OFF, exposes a "WebP replacement all content" button (calls `ConfigService.replacePNGtoWEBP`) | `config.disableWebp` |
| Disable auto-resized for gallery (ปิดระบบ Image Auto Resize เฉพาะ Image Gallery) | toggle | Disables gallery auto-resize | `config.bDisableImageResize` |
| Enable E-SIM module / BillionConnect (เปิดใช้งานระบบ E-SIM) | toggle | Enables E-SIM module for the domain | `config.bEsim` |
| Enable login with Social Media (เปิดใช้งานระบบ Login ผ่านสื่อ Social) | toggle + sub-panel | HTTPS-only (`ng-if="isHttps"`); reveals Facebook App ID / Google Client ID / Line Channel ID + Secret + "Get redirect URL" buttons | `config.bSocialLogin`, `config.sociallogin.{bShowFacebookLogin,facebookAppID,bShowGoogleLogin,googleClientID,bShowLineLogin,lineChannelID,lineChannelSecret}`; save zeroes out empty-credential providers |
| Enable login via Email / OTP (เปิดใช้งานระบบ Login ผ่าน Email - ยืนยันด้วยรหัส OTP) | toggle | Email OTP two-factor login | `config.bTwoFactorLogin`; this UI checkbox was added by `feature/webconfig-twofactor-login-toggle` — the pipeline (LoginController, Config model) existed earlier but had no admin toggle and required a direct MongoDB edit to enable. |
| Enable membership registration with pop-up (เปลี่ยนรูปแบบการแจ้งเตือนการสมัครสมาชิกเป็นรูปแบบ popup) | toggle | Member-register alert as popup | `config.alertSetting` |
| Enable custom form with pop-up (เปลี่ยนรูปแบบการแจ้งเตือนการบันทึก Custom Form รูปแบบ popup) | toggle | Custom-form submit alert as popup | `config.customformAlertPopup` |
| Enable preview custom form (เปิดการแสดงผลตัวอย่าง Custom Form) | toggle | Enables custom form preview | `config.bPreviewCustomForm` |

> Hidden/legacy controls in the General markup (not normally visible): Festival Banner (`config.FestivalBanner[0]`, in `.ng-hide`), Payment-page URL + redirect-after-login + "Disable login redirector" (`config.paymentPagePublicURL`, `config.bRedirectLoggedIn`, `config.bRedirectCancelLogin` — all `display:none`).

#### Step 1.2 — Mobile Display (แสดงผลบนมือถือ)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Disable search button on mobile (ปิดการแสดงผล ปุ่ม search บนมือถือ) | toggle | Hides mobile search button | `config.bSearchMobile` |
| Show search box on menu (แสดงช่องค้นหาบนเมนู) | toggle | Shows input search in mobile menu | `config.bSearchMobileNewMode` |
| Disable display of side data — Mobile/Tablet only (ปิดการแสดงผล ข้อมูลด้านข้าง) | toggle | Hides side data on mobile/tablet | `config.bPosition` |
| Fixed top menu — Mobile/Tablet (Fixed เมนูด้านบน) | toggle | Pins mobile menu | `config.bMenuonTop` |
| Hide menu when scrolling down / show on scroll up (ซ่อนเมนูเมื่อ Scroll ลง…) | toggle | Auto-hide menu on scroll; shown only when bMenuonTop | `config.bMenuScrollUpTop` |
| Hide menu when refreshing the page (ซ่อนเมนูเมื่อ Refresh หน้า) | toggle | Hides menu on refresh; shown only when bMenuScrollUpTop | `config.bHideMenuScrollUpInit` |
| Enable display of side menu / Sidebar (เปิดการแสดงผลเมนูด้านข้าง) | toggle | Enables mobile sidebar | `config.bMobileSidebar` |
| Enable display of data in side menu (เปิดการแสดงผลข้อมูลในเมนูด้านข้าง) | toggle | Shows data in sidebar; disabled unless bMobileSidebar | `config.bMobileSidebarPosIndex1` |
| Disable display of sub-menu automatically (ปิดการแสดงผลเมนูย่อยแบบ Auto) | toggle | Collapses auto sub-menu; disabled unless bMobileSidebar | `config.bSubMenuToggle` |
| Increase image size (เพิ่มขนาดรูปภาพ…) | toggle | Larger images on mobile | `config.bExtendsMobile` |
| Enable effects in image system (เปิดใช้งาน เอฟเฟคในระบบรูปภาพ) | toggle | Image effects on mobile | `config.imgEffectMobile` |

#### Step 2 — Under Construction (ตั้งค่าปิดเว็บไซต์ชั่วคราว)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Under Construction Website (ปิดเว็บไซต์ชั่วคราว) | toggle | Puts the public site into maintenance mode | `config.bUnderConstruction` |

#### Step 3 — Language / General website setting (กำหนดตั้งค่าทั่วไปของเว็บไซต์)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Available languages (ระบบการรองรับภาษา) | checkbox list | Per-language enable checkboxes with flag images; `ng-change="switchLanguage(lang)"` | Builds `config.LangEnable` on save; toggling adds/removes from `languageUse` |
| Default Language (ภาษาเริ่มต้น) | dropdown | Sets the site default language | `langDefault`; save requires it (warns "Please select a default language"). See MEMORY: lost default language has 3 cache layers |
| Disable special-character URL encoding (ปิดการแปลงอักขระพิเศษใน URL) | toggle | Sends GET data without `_Sla_`/`_Amp_` transform | `config.bDisableUrlCharTransform` |
| Favicon | file upload | Uploads favicon; auto-saves on success | `#fileupload` → `FilesRender/UploadFileServer`; result rewritten to `/48/48/` path into `config.FaviconImage`, then `saveData()` |
| Logo website | file upload (**hidden / legacy**) | Standalone logo block — its wrapper has class `hidden`, so it is **not usable** in the current build | `#fileuploadLogo` → `localconfig/UploadLogo`; `config.Logo`. The real site/header logo is the **fixed-menu logo** under the *Fixed top menu bar* row above — see the "Upload the website / header logo" task below |
| Configure Email Sender Name (ตั้งค่าชื่อผู้ส่งอีเมลออกจากระบบ) | text input | Local part of system sender email (domain appended) | `config.FixedEmail`; controller splits/rejoins on `@` + tenant `Domain.Name` |
| Search configuration | partial | Renders `~/Views/Component/Search/Searchconfig.cshtml` (search pattern/score/filters) | Saved inside `config.searchConfig` via `createDefaultForSearchConfig`; see search/store references |
| Advance Component (Advance Component) | toggle | JS bundle optimization for advance components | `config.Optimization.bAdvanceOptimize` (nested) |
| Form Component (Form Component) | toggle | JS bundle optimization for form components | `config.Optimization.bFormOptimize` (nested) |
| Enable Lazyload (เปิดใช้งาน Lazyload) | toggle | Lazy-loads bundles | `config.Optimization.enableLazyLoad` (nested) |

### CSS tab (#css — ตั้งค่า CSS / "CSS Settings")
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| CSS Global | CodeMirror textarea (CSS) | Site-wide custom CSS injected on every page | `config.CustomCSS`; editor `#codecss`, value pulled from CodeMirror into scope inside `saveData()` |
| CSS by Language (CSS สำหรับภาษา) | language dropdown + CodeMirror textarea | Per-language CSS; pick language then edit | `cssByLanguage.CustomCSS` keyed by `LanguageID`; merged into `config.CustomCSSByLanguage[]` by `manageCustomCSSByLanguageArray`; `ChangeCSSLanguage` swaps editor content on language change |
| CSS SEO (CSS สำหรับ SEO) | CodeMirror textarea (CSS) | CSS applied to the bot/SEO render path | `config.CustomCSSforSEO`; editor `#codecssSEO` |

> All three CSS fields are CodeMirror editors initialized lazily when the CSS tab is first opened (`activateTab('css')`). On save, `saveData()` reads `editor_css`, `editor_css_by_language`, `editor_css_seo` `.getValue()` into the config — if the tab was never opened the editors stay `null` and existing values are preserved.

> **Troubleshooting — an image or whole component "missing" on the public page is often CSS here, not broken data.** Tenant-authored rules in **CSS Global** (or **CSS by Language** / **CSS SEO**) can hide an element (`display:none`, `visibility:hidden`, `opacity:0`, `height:0`) even when the component's markup and data are correct — and some images are supplied as a CSS `background-image` that lives here, not in the component's own image field. So when "a section/image isn't showing," check the **CSS tab** first: `…/?manage=true/#!/WebConfig/css`. Real example tenant: `https://demo110.itopplus.com/?manage=true/#!/WebConfig/css`.

### PDPA tab (#pdpa — ตั้งค่า PDPA / "PDPA Settings")
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Enable Personal Data Protection Act (เปิดใช้งาน Personal Data Protection Act) | toggle | Turns on the PDPA / cookie-consent banner on the public site | `config.PersonalDataProtectionAct.bPersonalDataProtectionAct` (nested object) |
| Disable BODY TAG functionality — Remarketing Tag, GTM 2nd script (ปิดการทำงานของ BODY TAG) | toggle | When PDPA on, blocks BODY-tag scripts until the visitor consents to cookies | `config.PersonalDataProtectionAct.bDisableCookieByDefault`; only visible when the PDPA toggle is on |
| Default Language selector (เลือก ภาษาเริ่มต้น) | dropdown | Picks which language's policy text you are editing | `langDefault`; `ng-change="changePDPAlanguage(langDefault)"` swaps the editor to that language's array entry |
| Personal Data Protection Statement | rich-text editor (Kendo) | The cookie-policy / consent message body, per language | Bound to `config.PersonalDataProtectionActArray[indexPDPA].personalPolicyMessageByLanguage`; seeded from `pdpaDefaultTemplate()` when empty. Editor block only shown when the PDPA toggle is on |

> Labels in the PDPA tab are inline Razor `isThaiLanguage ? … : …` ternaries (not `websiteSettingByLangauge` keys), so they are not in `website-setting.js`.

## Common tasks

### Inject site-wide custom CSS
1. Open `…/?manage=true#!/WebConfig/css`.
2. Type CSS into the **CSS Global** editor (no `<style>` wrapper needed).
3. For language-specific overrides, pick the language in the **CSS by Language** dropdown and edit that editor; repeat per language.
4. Click **Save** (or press Ctrl+S).

### Turn on the cookie-consent / PDPA banner
1. Open `…/?manage=true#!/WebConfig/pdpa`.
2. Check **Enable Personal Data Protection Act**.
3. (Optional) Check **Disable BODY TAG functionality** to hold remarketing/GTM 2nd-script until consent.
4. Choose the language in the top-right selector, edit the **Personal Data Protection Statement** text (a default template is pre-filled).
5. Repeat step 4 for each enabled language, then **Save**.

### Change the favicon
1. Open `…/?manage=true#!/WebConfig` (General tab), scroll to **Favicon**.
2. Click **Choose file…** and pick a `.png/.jpg/.jpeg/.gif` (favicon is resized to 48x48).
3. Upload triggers an automatic save — no need to click Save separately.

### Upload the website / header logo
The logo that renders in the site header is the **fixed-menu logo**
(`config.fixedMenuLogo[0].logoImage`, rendered by `Views/Component/Menu/MenuBootstrap/Logo_Menu.cshtml`).
The standalone "Logo website" box is `hidden` in the current build, so use this path:
1. Open `…/?manage=true#!/WebConfig` (General tab).
2. Turn **ON** **Fixed top menu bar (Fixed เมนูด้านบน)** (`config.bPcMenuonTop`) — this reveals its settings box. **(The logo uploader does not appear until this is on.)**
3. In that box, check **Upload Logo (อัพโหลดโลโก้)** (`config.fixedMenuLogo[0].flagShowLogo`).
4. Click **Choose file** and select the image — it posts to `./FilesRender/UploadFileServer/` (`#fileupload-UploadMenuLogo`) and is stored in `config.fixedMenuLogo[0].logoImage`.
5. (Optional) set a **link** for the logo (`config.fixedMenuLogo[0].linkLogo`).
6. **Save**, then run **Apply/publish**.

### Enable email OTP login
1. Open `…/?manage=true#!/WebConfig` (General tab), right column.
2. Check **Enable login via Email (OTP verification)** (`config.bTwoFactorLogin`).
3. Click **Save**.

## Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Theme/5Options.cshtml` (whole panel; General/CSS/PDPA tabs at lines ~44, ~1118, ~1145). Sidebar entry: `Views/LayoutManager/_SlideBarHomeNew.cshtml` (link `#!/WebConfig`, advanced sub-links `#!/WebConfig/{seo,meta,css}`). Center card: `Views/MainBackend/NewUI/settingGeneral.cshtml`. Search sub-panel: `Views/Component/Search/Searchconfig.cshtml`.
- **Controller / script:** `ScriptRequire/System/BannerConfig/Controller.js` (`BannerConfigController` — `init()`, `saveData()`, `activateTab()`, CodeMirror/CSS handlers, PDPA `changePDPAlanguage`, upload handlers). Service: `ScriptRequire/System/Config/Service.js` (`getConfig`, `saveConfig`, `uploadFavIcon`, `replacePNGtoWEBP`). Route: `ScriptRequire/MainSystem/Routing/Server.js` (`.when('/WebConfig/:tab?', …)`). Labels: `ScriptRequire/domains/language/menu-by-language/website-setting.js` (`websiteSettingByLangauge`, th + en). PDPA default body: `ScriptRequire/domains/templates/pdpa-template.domain.js`.
- **Save endpoint:** `Localconfig/saveConfig` (POST). The whole `$scope.config` is JSON-stringified (`$scope.configBuf`) and sent via `ConfigService.saveConfig`. C# side: `Models/Config/Config.cs` `class ConfigMain` properties + `getQueryString()` (lines ~508-748) builds the URL-encoded body PoolNode parses by position. Uploads use separate endpoints: favicon/menu-logo/watermark/advertising image → `FilesRender/UploadFileServer`, plus `localconfig/UploadLogo`, `localconfig/UploadBackToTop`, `localconfig/UploadPomotion`, `localconfig/UploadAdvertising`.

## Gotchas / multi-tenant notes
- **`getQueryString()` is the silent-drop point for flat toggles.** A flat `config.bX` must have a matching `+ "&bX=" + bX` line in `Config.cs getQueryString()` or the value never reaches PoolNode and the save reverts on reload. See the `adding-webconfig-toggle` skill for the full 5-layer recipe.
- **Nested toggles skip `getQueryString()`.** `ContentmanagerSettings.*`, `Optimization.*`, `PersonalDataProtectionAct.*`, `sociallogin.*` serialize as one JSON blob via the parent getter (`contentmanagersetting`, `optimize`, `personalProtectionJSON`, `socialConfigJSON`); they need the parent object initialized in JS instead. The controller already guards `config.ContentmanagerSettings = {}` for legacy domains where it is null — Optimization/PersonalDataProtectionAct are likewise re-shaped in `init()`/`saveData()`.
- **CSS editors are lazy.** If a developer adds a new CodeMirror field, remember the value is only read into the config when the CSS tab has been activated; unopened editors stay `null`.
- **CSS here can hide components/images.** A "missing" section or image on the public site is frequently a Global CSS rule (`display:none`, etc.) at `#!/WebConfig/css`, not a code/data/deploy problem — check the CSS tab before assuming the component is broken. (Same root cause as the "section not showing → domain custom CSS" debugging note.)
- **PDPA has both a legacy single object and a per-language array.** Old `config.PersonalDataProtectionAct.personalPolicyMessage` (single) is migrated into `config.PersonalDataProtectionActArray[]` (per-language) on load; both are serialized (`personalProtectionJSON`, `personalProtectionArrayJSON`). The `bDisableCookieByDefault` toggle lives on the legacy single object.
- **Default-language change ripples across caches.** Changing the Default Language here touches Mongo `LangEnable`, the C# session "Config", and app-scope `renderConfig` (see MEMORY: "Language default lost = 3 cache layers").
- **Multi-tenant: clean.** Every toggle keys off `config.*` per-`DomainID`; no hardcoded-domain whitelist found in this view, its controller, or `getQueryString()`. The `bHideWatermarkItopplus` / `bItpCustomURL` CSS wrapper classes are styling hooks, not domain whitelists. Social login is gated only by `isHttps` (scheme), not by domain. Keep new features per-domain-toggleable, never domain-listed.
- **Save bar does not follow `applyReady`.** Per `ScriptRequire/CLAUDE.md`, WebConfig's `saveData` does not set `$rootScope.applyReady = false`, so the sticky savebar omits the `--with-apply` slide-up modifier. Ctrl+S is wired to the Save button via an inline script.
