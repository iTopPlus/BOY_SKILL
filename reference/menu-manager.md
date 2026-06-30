# Menu Manager (เลือกรูปแบบเมนู)

## What it does
Picks the navigation-menu **style/template** for the site — a top (horizontal) menu and a side (vertical) menu — choosing the rendering engine (Bootstrap or Kendo), filtering candidate templates by color, and saving the chosen template IDs onto the site config. It does not edit which pages/links appear in the menu; the item list is driven by the site's pages elsewhere.

## How to get there
- **Sidebar:** Left manage sidebar > Menu Manager (เลือกรูปแบบเมนู) — the `#!/Menu` link in `_SlideBarHomeNew.cshtml`, sitting between Banner Manager (`#!/Banner`) and Page Setting (`#!/WebConfig`).
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Menu`

## Fields on the screen
The screen is a chooser, not a form. It has two read-only "current selection" previews at the top, then a toggle that reveals a paginated gallery of template previews you select from.

| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Current Side Menu (เมนูด้านข้างที่ใช้ปัจจุบัน) | Read-only preview (iframe) | Shows the vertical menu template currently saved as `config.MenuVerticalStyleID`. | Rendered in an `<iframe>` via `/Menu/RenderPartialMenu`; not editable here, only reflects the saved choice. |
| Current Top Menu (เมนูด้านบนที่ใช้ปัจจุบัน) | Read-only preview (iframe) | Shows the horizontal/navbar template currently saved as `config.MenuStyleID`. | Same iframe-preview mechanism. |
| Select a new menu style / Cancel (เลือกรูปแบบเมนูใหม่ / ยกเลิก) | Toggle button (`toggleMenu()`) | Shows/hides the template-picker gallery. Label flips to "Cancel" (ยกเลิก, red) while open, back to "Select a new menu style" (เลือกรูปแบบเมนูใหม่, blue) when closed. | Button text + color are AngularJS state (`pickmenuText.Name` / `.Color`), hardcoded Thai strings in the controller; not driven by the language-file objects. |
| Color palette (no label) | Color picker (Kendo color palette) | `changeColorMenu(color)` filters the gallery to menu templates matching the picked color; resets to page 1. Fixed swatches: `#cccac3, #ffcc00, #aeff00, #ff3f3f, #ba00c1, #005e99, #43aeff`. | Looks up the color ID via `Theme/getColorFromCode`, then filters `MenuData`. If no template matches the color, it falls back to showing all (`MenuAll`). Also forces `menuType = 'bootstrap'`. |
| Previous / Next (ก่อนหน้า / หน้าถัดไป) + page counter | Pager buttons | Paginate the template gallery (`MenupageSize = 4` per page). Counter shows `{current}/{maxPage}`. | Two identical pager rows (above and below the gallery). |
| Select Side Menu (เลือกเมนูด้านข้างนี้) | Action button per template | `saveMenuVertical(menuvertical._id)` — sets `config.MenuVerticalStyleID` and saves. | Browser `confirm()` first ("Do you want to change the menu style?" / "ต้องการเปลี่ยน รูปแบบเมนู หรือไม่ ?"). On success sets `$rootScope.RefreshCmpLoad = true` and closes the picker. |
| Select Main Menu (เลือกเมนูหลักนี้) | Action button per template | `saveMenuNavbar(menu.id)` — sets `config.MenuStyleID` (the top/navbar menu) and saves. | Same confirm dialog and post-save behavior as Select Side Menu. |

### Menu engine note (horizontal vs vertical, Bootstrap vs Kendo)
- Each gallery template carries a `MenuType` of `bootstrap` or `kendo`; `menuType` (default `'bootstrap'`) filters which previews render. `changemenuType(e)` maps `1 → bootstrap`, `2 → kendo` (no visible UI control wired on this screen for that toggle in `6Menu.cshtml` — only the color picker forces bootstrap).
- "Top/Main menu" = horizontal navbar (`MenuStyleID`, rendered by `MenuBootstrap.cshtml` / `MenuKendo.cshtml`). "Side menu" = vertical (`MenuVerticalStyleID`, rendered by `MenuBootstrapVertical.cshtml` / `MenuKendoVertical.cshtml`).
- The five scoped `.cshtml` files (`MenuBootstrap`, `MenuBootstrapVertical`, `MenuKendo`, `MenuKendoVertical`) are **static preview markup** with placeholder links ("Link", "Products", "My Teammates"); they illustrate the style only. `MenuHeaderJSCSS.cshtml` injects the shared server CSS/JS the previews need. The live menu's actual items come from the site's pages, not from these previews.

## Common tasks
### Change the top (horizontal) menu style
1. Open `?manage=true#!/Menu`.
2. Click **Select a new menu style** (เลือกรูปแบบเมนูใหม่) to open the gallery.
3. (Optional) Click a color swatch to filter templates by color; use Previous/Next to browse.
4. Under a template's main/top preview, click **Select Main Menu** (เลือกเมนูหลักนี้).
5. Confirm the dialog. The new style saves and the picker closes; the "Current Top Menu" preview updates.

### Change the side (vertical) menu style
1. Open the picker as above.
2. Under a template's side preview, click **Select Side Menu** (เลือกเมนูด้านข้างนี้).
3. Confirm the dialog to save.

### Match the menu to a color
1. Open the picker and click a color swatch in the palette.
2. The gallery filters to templates of that color (falls back to all if none match); pick Main or Side as above.

## Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Theme/6Menu.cshtml` (the screen); preview partials `Views/Theme/MenuBootstrap.cshtml`, `MenuBootstrapVertical.cshtml`, `MenuKendo.cshtml`, `MenuKendoVertical.cshtml`, and shared head `Views/Theme/MenuHeaderJSCSS.cshtml`. Sidebar entry: `Views/LayoutManager/_SlideBarHomeNew.cshtml` (`#!/Menu`).
- **Route registration:** `ScriptRequire/MainSystem/Routing/Server.js` — `.when('/Menu/?:themeID?', …)` loads `6Menu.cshtml` via `FilesRender/RenderPartial` under controller **`BannerController`** (the Menu route reuses the Banner controller, not `ThemeController`).
- **Controller / script:** `ScriptRequire/System/BannerConfig/Banner/Controller.js` — holds `toggleMenu`, `changeColorMenu`, `changemenuType`, `saveMenuNavbar`, `saveMenuVertical`, and the `MenuData`/`MenuDataVertical`/`MenuAll` loading (via `ThemeService.getAllmenu()` / `getAllmenuVertical()`). Sidebar labels come from `ScriptRequire/domains/language/menu-by-language/menuSlideBarNameByLanguage.js` (`chooseMenuTemplate` = "Menu Manager" / "เลือกรูปแบบเมนู").
- **Save endpoint:** `ScriptRequire/System/BannerConfig/Banner/Service.js` → `saveMenuNavbar` and `saveMenuVertical` both `POST localconfig/saveConfigAsync` with `{ json: config }` (the whole config object, with the updated `MenuStyleID` / `MenuVerticalStyleID`). Color lookup uses `GET Theme/getColorFromCode?ColorCode=…`. Previews fetch `/Menu/RenderPartialMenu?id=<view>&StyleID=<id>` and CSS from `/MenuRender/getCssMenu` / `/MenuRender/getCssMenuVertical` (C# controllers `MenuController` / `MenuRenderController`).

## Gotchas / multi-tenant notes
- The screen mutates `$scope.config` (`MenuStyleID`, `MenuVerticalStyleID`) and persists the full config through the standard `localconfig/saveConfigAsync` pipeline — same path as WebConfig. Both `MenuStyleID` and `MenuVerticalStyleID` are also set automatically when picking a Theme (`ThemeController.PickTheme` copies `DefaultMenu`/`DefaultSideMenu` from the theme), so changing the theme will reset menu styles.
- Confirmation dialogs are plain browser `confirm()` and the toggle button text are hardcoded Thai strings in `Controller.js` (e.g. `'ยกเลิก'`, `'เลือกรูปแบบเมนูใหม่'`), bypassing the TH/EN language-file mechanism — the EN variant only appears via the `isEng` ternary on the confirm message, not on the toggle button. This is a localization gap, not a per-domain feature.
- No hardcoded-domain whitelist was found in this feature's code; the chooser works the same for every tenant via its `config` document.
- Color palette swatches are a fixed in-code list (no per-domain config), shared with the Theme color chooser.

## Uncertainties
- `6Menu.cshtml` does not expose a visible Bootstrap-vs-Kendo toggle; `changemenuType()` exists in the controller but no `ng-click` for it appears in this view, and the color picker hard-sets `menuType = 'bootstrap'`. Whether Kendo templates are reachable from this screen in practice is unclear from the markup alone.
- "How menu items map to pages" is not configured on this screen — only the template/style is chosen here. The actual link-to-page wiring lives elsewhere (page management / the live menu component), which is out of scope for these files.
