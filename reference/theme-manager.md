# Theme Manager (เลือกรูปแบบเว็บไซต์)

## What it does
Lets a tenant choose the website template (theme) that defines the overall layout and primary color scheme. Picking a theme swaps the entire site layout, sets the default menu styles, and starts a wizard that continues into Banner and Menu setup. (Sidebar label in EN is "Theme Manager"; the TH sidebar string is "เลือกรูปแบบเว็บไซต์", and the on-screen panel heading reads "กำหนดรูปแบบโทนสี" / "Set Color Scheme".)

## How to get there
- **Sidebar:** Website Settings (ตั้งค่าเว็บไซต์) > Theme Manager (เลือกรูปแบบเว็บไซต์)
- **Route:** `https://demo110.itopplus.com/?manage=true#!/ThemeManage`

## Fields on the screen
The main screen (`1ThemeItems.cshtml`) is a template gallery, not a form. The only interactive controls are:

| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Filter by Color (เลือกThemeตามสี:) | Color palette (Kendo `kendoColorPalette`, fixed 7 swatches) | Re-filters the theme grid to themes whose `ColorID` matches the picked swatch | Hardcoded palette: `#cccac3, #ffcc00, #aeff00, #ff3f3f, #ba00c1, #005e99, #43aeff`. Picking a swatch resolves the color code to a `ColorID` (`Theme/getColorFromCode`) then reloads the grid. Not a free color picker — no custom hex. |
| Theme thumbnail grid (template tiles) | Image button grid (repeater, 8 per page) | Hovering a tile reveals a "Select" (เลือกแบบนี้) overlay; the currently-applied theme tile is highlighted (`btn-warning`) | Thumbnails load from `/Template/{themeId}/image/thumb/ThemeLayout1.jpg`. Grid is client-paginated, `pageSize = 8`. |
| Select (เลือกแบบนี้) | Action link (`PickTheme(theme)`) | Applies that theme to the site (see Common tasks) | Pops a confirm dialog before changing; confirming overwrites the whole layout. |
| Previous / Next / `<<` / `>>` (ก่อนหน้า / หน้าถัดไป) | Pagination buttons | Move through pages of the theme grid | Client-side only; disabled at first/last page. |

Wizard / preview controls that exist in the source but are NOT shown by the live `ThemeManage` route (see Gotchas):
- **2ThemeGallery.cshtml** — a full-screen theme preview slider with "Select theme" (เลือก Theme) / "Cancel" (ยกเลิก) buttons, shown only when `step == 'Gallery'`. The `ng-include` that would mount it is commented out in `1ThemeItems.cshtml`.
- **3ThemeDetail.cshtml** — a "Set platform and website layout" (กำหนดรูปแบบแพลทฟอร์มและเว็บไซต์) step with PC / SmartPhone / Tablet layout tabs (Mobile & Tablet tabs are `display:none`). Its layout-pick handlers (`pickLayoutPC/Mobile/Tablet`) are fully commented out in `Controller.js`, so selecting a layout here is currently a no-op.

## Common tasks
### Apply a different website template
1. Open Website Settings > Theme Manager (route `#!/ThemeManage`).
2. (Optional) Click a swatch under "Filter by Color" to narrow the grid to one color family.
3. Hover the template tile you want; click "Select" (เลือกแบบนี้).
4. Confirm the warning dialog ("Do you want to change the entire layout?" / "ต้องการเปลี่ยน รูปแบบเลเอาท์ ทั้งหมดหรือไม่ ?") by choosing ต้องการ.
5. The new theme is saved: `config.ThemeID`, `config.MenuStyleID` (= theme's `DefaultMenu`), and `config.MenuVerticalStyleID` (= theme's `DefaultSideMenu`) are updated, a banner config is seeded (`SlideEffect`, `bnHeight`), the app-scope cache is cleared, the site re-publishes, and you are redirected to the Banner step (`#!/Banner/<themeId>`).

### Filter themes by color
1. On the Theme Manager screen, click one of the 7 color swatches next to "Filter by Color".
2. The grid reloads showing only themes tagged with that color; pagination resets to page 1.

## Wired in (for developers)
- **View(s):**
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Theme/1ThemeItems.cshtml` (the live screen for `#!/ThemeManage`)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Theme/2ThemeGallery.cshtml` (preview slider — include commented out)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Theme/3ThemeDetail.cshtml` (platform/layout step — handlers commented out)
- **Controller / script:**
  - `ScriptRequire/System/Theme/Controller.js` (AngularJS `ThemeController`), `ScriptRequire/System/Theme/Service.js` (`ThemeService`), `ScriptRequire/System/Theme/index.js`
  - `ScriptRequire/System/ThemeColor/Service.js` (`ThemeColorService`: `getColor`, `getColorFromCode`)
  - C# `Controllers/ThemeController.cs`
  - Route registration: `ScriptRequire/MainSystem/Routing/Server.js` — `.when('/ThemeManage', …)` renders `Views/Theme/1ThemeItems.cshtml` with controller `ThemeController`.
  - Sidebar link: `Views/LayoutManager/_SlideBarHomeNew.cshtml` (`<a href="#!/ThemeManage">`)
  - Label: `ScriptRequire/domains/language/menu-by-language/menuSlideBarNameByLanguage.js` (`chooseWebsiteTemplate`: TH "เลือกรูปแบบเว็บไซต์" / EN "Theme Manager")
- **Save endpoint:** `Theme/setThemeAsync` (POST, `ThemeService.setTheme` → C# `setThemeAsync`). It calls `configRepo.saveConfigAsync(jsonObject)` to persist the Config (ThemeID + menu style IDs), backs up the banner config, and applies the theme's default banner template; it also calls `CGClass.ClearApplicationScope()` to drop the app-scope render cache. The banner seed uses `BannerConfigService.setBannerConfig`, and `CommonService.PublishAll()` re-publishes the site.
  - Theme/color read endpoints (all on `ThemeController.cs`): `getThemeAsync`, `getThemeByColorAsync`, `getThemeAllByColorAsync`, `getThemeAllAsync`, `getColorAsync`, `getColorFromCodeAsync`, `getthemepreviewbyThemeIDAsync`.
  - Layout-save endpoint `setLayoutAsync` exists on the controller (PC/Mobile/Tablet → `config.LayoutPC/LayoutMobile/LayoutTablet` via `saveConfig`) but its client callers are commented out, so it is currently unused from this UI.

## Gotchas / multi-tenant notes
- **Domain-name branching is hardcoded in the client.** Both `Controller.js` `bindAll()` and `Change()` (and the route's `resolve`) switch behavior on `domain.Name.indexOf('itopplus')`, `'demo'`, and `'localhost'`: those environments load ALL themes by color (`getThemeAllByColorAsync`), while every other tenant gets the filtered set (`getThemeByColorAsync`). Tenants whose domain string doesn't contain `itopplus`/`localhost` also get short-circuited to the Banner step when `domain.bDesign == true` (i.e. they skip theme selection entirely). This is a domain-name whitelist anti-pattern — flag if extending.
- **The "wizard" beyond step 1 is dead in this route.** `1ThemeItems.cshtml` shows tiles when `step` is not `Gallery`/`Detail`/`Banner`, but the `ng-include`s for the Gallery and Detail steps are commented out, so `PreviewTheme`/`settingLayout` can't actually surface those panels here. `2ThemeGallery.cshtml` and `3ThemeDetail.cshtml` remain in the repo and are reachable only if those includes are restored; treat them as legacy.
- **Layout (PC/Mobile/Tablet) selection is non-functional.** `pickLayoutPC`, `pickLayoutMobile`, `pickLayoutTablet` in `Controller.js` are entirely commented out. Selecting a layout in `3ThemeDetail.cshtml` does nothing and never saves.
- **The color "filter" is not a theme color editor.** Users cannot set an arbitrary brand color here; they only filter the gallery by one of 7 preset swatches. The actual color comes baked into each theme (`ColorID`). There is no hex/RGB input.
- **Applying a theme is destructive and global.** `PickTheme` overwrites `ThemeID`, `MenuStyleID`, `MenuVerticalStyleID`, re-seeds banner config, clears the app-scope cache, and republishes the whole site — hence the confirm dialog. The redirect lands on `#!/Banner/<themeId>` to continue setup.

## Uncertainties
- **Fonts:** the task scope lists "fonts", but none of the scoped Theme Manager screens (`1ThemeItems`, `2ThemeGallery`, `3ThemeDetail`) nor `Controller.js`/`Service.js` expose a font picker or font setting — the only `font-*` occurrences are CSS styling on the views themselves. Font selection appears to live in other modules (e.g. content/banner editors), not in Theme Manager. Documented as absent here rather than invented.
- The confirm dialog button values are the literal strings `ต้องการ` / `ยกเลิก` regardless of UI language (only the title/content are localized via the `isEng` flag), so the EN UI still sends the Thai button value internally.
