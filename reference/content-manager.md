# Content Manager (จัดการเนื้อหา / จัดการเนื้อหาระบบ)

## What it does
Manages the website's system content — articles / news / blog entries — as a WordPress-style list (All / Published / Draft / Trash) plus a block-based editor for each item. Also manages content **categories**, searchable **tags** (with sub-tags and tag groups), and an **RSS Feed** generator. The sidebar label is "Content Manager" (`manageSystemContent`); the in-menu link reads "Manage Content" (จัดการเนื้อหา).

## How to get there
- **Sidebar:** Management System (ระบบจัดการ) > Manage Content (จัดการเนื้อหา). (The sidebar item key `manageSystemContent` renders as "Content Manager" in `menuSlideBarNameByLanguage.js`; the `_MainMenu.cshtml` link text is "Manage Content".)
- **Route (list view):** `https://demo110.itopplus.com/?manage=true#!/Contentmanager`
- **Route (new item):** `https://demo110.itopplus.com/?manage=true#!/Contentmanager/new`
- **Route (edit item):** `https://demo110.itopplus.com/?manage=true#!/Contentmanager/edit:contentId`
- All three routes render the same view (`Views/Management/ViewContent.cshtml`). Inside it, the editor (`managerView == true`) and the list (`managerView == false`) are two states of the one Angular controller. Category / tag / sub-tag / tag-group / RSS / general-settings panels open as **modals** (see triggers below), not separate hash routes.

## Fields on the screen

### List view toolbar & rows (`ng-if="!managerView"`)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Status filter tabs: All / Published / Draft / Trash | tab links (counts shown) | Filters the list by publish state; sets `$root.paramType` | "Trash" tab swaps the bulk button to a restore (recycle) action |
| Add Topic (เพิ่มหัวข้อ — label `AddTopic`) | button | `viewManagement(1)` → opens the block editor for a new item | — |
| Category (Manage Category) | button | `viewCategoryALL()` → opens the **Manage Content Category** modal | — |
| Move selected to Trash / Restore | bulk button | `moveTrashALL(Contents,'all')`; only visible when rows are selected (`hasSelection()`) | In Trash tab the icon/colour flips to "restore" |
| Delete permanently | bulk button | `deleteContentAll(Contents)`; only in Trash tab with a selection | Hard delete |
| Filter by Category (`FilterByCate`) | dropdown w/ search | `searchFillter(cat,true)`; filters list to a category; `searchClear()` clears | Hierarchical (parent/child rows, expand/collapse); searchbox `catFilterText` |
| Add Search Tags (เพิ่มแท็กค้นหา) | button | `viewTagALL()` → opens the **Manage Search Tag** modal | — |
| Search Content (ค้นหาเนื้อหา) | text input | `searchFillter(searchText,false)`; 500ms debounce; "Clear" (เคลียค่า) resets | — |
| Create RSS Feed | button | `rssfeedGeneratorModal()` → opens **RSS Feed Generator** modal | Markup has `style="display:none"` — hidden by default, shown per-domain/script |
| ReIndex Sort Order (ReIndex ตัวจัดเรียง) | button | `reindexOrdernumber()` | `display:none` by default; appears when a category filter is active |
| Advanced Settings (ตั้งค่าขั้นสูง — gear) | button | `contentmanagerSetting()` → opens **General Settings** modal | — |
| Content language (`DefaultLangContent`) | dropdown | `changeContentLanguage()`; switches which language's content is listed/edited | Disabled when `NotAllowSave`; tied to multi-language setting |
| Items per page | dropdown (15/30/50) | `changePagesizeitem()` | Appears top-right and in footer |
| Row: Order / Copy / select checkbox / Pin / Topic / Categories / DateTime / Close Comment / Tools | per-row controls | Copy = `copyContentManager`; Pin = `checkbStricky` (bSticky); Comment badge = `checkbComment`; Tools = Edit/Preview/Trash (or Restore/Delete in Trash) | List is `orderBy:['-bSticky','OrderContents.Ordernumber']` — pinned first |
| Active toggle (สถานะใช้งาน) | toggle badge per row | `checkbActive(manager)` → flips `manager.bActive` optimistically then calls `ContentmanagerService.updateFlags`; reverts if server returns `'ERROR'` | Default = active (true); toggling hides/shows the item on the public page without trashing it. The toggle is separate from **bEnable** (which controls comment/close) and **bSticky** (pin). New items are active by default at the server. |
| Move Position (ย้ายตำแหน่ง) up/down arrows | per-row | `sortContentmanager(id,'A'/'B')` | Column only shown when `showOrderContents` (i.e. filtered to a category) |

### Editor view — title & body (`ng-if="managerView"`)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Title ("Enter title here") | text input | `Content.Titlename` | Required; `validateDuplicateTitle()` checks for duplicate titles before publish |
| Subtitle ("Enter subtitle here") | text input | `Content.SubTitlename` | Container `#itpsubtitlecontent` is `display:none` by default |
| Add Block (เพิ่มบล๊อก) | button | `createNewBlock()` → opens **Manage Block** modal | Each content item is a list of blocks (`Content.Textmanager`) |
| Block body | rich-text editor (Kendo editor) | `rows.Textmanager` (HTML) | One Kendo editor per block; toolbar = `$root.editorTools` |
| Block image(s) | file upload + layout | per-block `imgType` (single / album / slide / tab / gallery / slide-gallery), `imgPosition`, `imgPath[]` | Configured in the Add Block modal; uploads via `FilesRender/UploadFileServer` |
| Block controls | up/down reorder, gear (settings), remove | `switchContentBlock`, `setImageBlock`, `delblockManagerment` | Remove hidden when only one block remains |

### Editor view — right-hand config accordion
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Enable Login Required System (เปิดใช้งานระบบบังคับ Login) | checkbox | `Content.bRequireLoginContentmanager` | Gates the public article behind member login |
| Custom Url | text input | `Content.contentCustomUrl` | — |
| Move To Trash | button | `moveToTrash()` | Only shown when editing an existing item (`Content._id != null`) |
| Enable 360-degree Cover (เปิดใช้งานหน้าปก 360องศา) | checkbox + select + width | `Content.useSpinnerCover`, `spinner`, `imagesetWidth` | Only when `bImageSpinner` is on |
| Manage Cover Image (จัดการภาพปก) | file upload | posts to `FilesRender/UploadFileServer` | Cover image preview shows `Textmanager[0].textImage` |
| Custom Cover ALT | text input | `Content.contentAlt` | Container `display:none` by default |
| Enable Video Cover (เปิดใช้งานหน้าปกวีดีโอ) | checkbox + mp4 upload | `Content.useMP4Cover` | `display:none` by default; uploads via `FilesRender/UploadFileServerLocal` |
| Canonical Tag | text input | `Content.canonicalTagUrl` | — |
| Brief Description (`bDescription`) | textarea | `Content.BriefDescription` | — |
| Draft | button | `saveDraft()` | Only when new or already a draft (`Content._id == null || Content.bDraft`) |
| Save & Publish | button (+ Save / Save and Close split-dropdown) | `validateDuplicateTitle()` then save; dropdown = `SaveAndStay` / `SaveAndClose` | Save & Publish is the primary action; dropdown gives stay/close variants |
| **Categories** — Add Category (`AddCategory`) | text input + Add button | `saveCategory()` adds a new category inline | Category image upload via `FilesRender/UploadFileServer` |
| Category checkboxes (incl. children) | checkbox list | `chooseCategory(cate)` / `checkItem` | Two-level (parent + indented child) |
| **Scheduler** — Display Color (สีในการแสดงผล) | Kendo color palette | `Content.Color` | Fixed 7-swatch palette |
| Start Date (วันเริ่มต้น) | Kendo date-time picker | `Content.DateStart` | — |
| End Date (วันสิ้นสุด) | Kendo date-time picker | `Content.DateEnd` | — |
| **SEO** — Keywords | text input | `Content.Keywords` | — |
| **SEO** — Description | textarea | `Content.Description` | Separate from the "Brief Description" in the Publish panel |
| **Search Tags** (แท็กค้นหา) — Tags | dropdown of tag categories + chips | `toggleSearchTagModal(tagL)` opens the Choose-Tag modal; chips bound to `Content.Tag`; click a chip = `removeThisTag` | — |
| Recent Tags (แท็กที่ใช้ล่าสุด) | chip list | `chooseRecentTag(recenttagg)` | From `recentTag.RecentTags` |
| Javascript | textarea | `Content.CustomJavascriptLandingPage` | `display:none` by default; warns wrong input can break the site |

### Modal: Manage Content Category (จัดการข้อมูลหมวดหมู่เนื้อหา) — `modalContent.cshtml`
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Manage Categories (จัดการหมวดหมู่) | text input + Add | `$parent.CategoryName` + `saveCategory()` | `{{btn}}` toggles Add/Edit label |
| Category Image (ภาพหมวดหมู่) | file upload | posts to `ContentManager/UploadFile` | Preview shown when `CategoryImage != null` |
| Select Main Category (เลือกหมวดหมูหลัก) | dropdown per row | `chooseParentID()` — makes a category a child of another | Filters out self and other children |
| Hide (ปิดไม่แสดง) | toggle per row | `checkbShowonMenu()` → `cate.bShowonMenu` | "checked" class shows when **not** on menu (inverted) |
| Edit / Delete | buttons per row | `editCategory` / `removeCategory` | New / Clear via "Clear Add Category" (เครียล์ค่าเพิ่มหมวดหมู่) |

### Modal: Manage Search Tag Data (จัดการข้อมูลแท็กค้นหา) — `modalContentTag.cshtml`
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Create search tag category name (ตั้งชื่อหมวดแท็กค้นหา) | text input + Add | `$parent.TagName` + `saveTag()` | — |
| Add Sub Search Tags (เพิ่มแท็กค้นหาย่อย) | button per row | `viewSubTag($index)` → opens **Manage Sub Tags** modal | — |
| Manage Tag (Link Search Tags / เชื่อมแท็กค้นหา) | button per row | `groupTag($index,tag)` → opens **Manage Tag Group** modal | — |
| Hide (ปิดไม่แสดง) | toggle per row | `checkShowTag()` → `tag.bTagClose` | — |
| Edit / Delete | buttons per row | `editTag` / `removeTag` | — |
| Upload tags from Excel / Delete all tags | hidden file upload + button | posts to `ContentManager/AddTagContentmanagerFromExcel`; `removeAllUnitTag()` | Container `display:none` by default |

### Modal: Manage Sub Tags (จัดการแท็กย่อย) — `modalSubTag.cshtml`
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Sub-tag text area | textarea (one tag per line) | `subTagData`; `addSubTag(subTagData)` saves | Plain newline-separated list; Cancel = `closeSubTag()` |

### Modal: Manage Tag Group (จัดการแท็กย่อย : {{TagNameTitle}}) — `modalGroupTag.cshtml`
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Tag-group select | dropdown | `changeTagGroup(choosedGroupTag)` picks another tag category | — |
| Add to group / remove from group | clickable chips | `addSubTagToGroup` / `removeSubTagFromGroup` | — |
| Save (บันทึก) | button | `saveTagGroup()` | Links sub-tags of one category to another's tags |

### Modal: Choose Search Tags (จัดการแท็กค้นหา) — `modalChooseTag.cshtml`
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Select Search Tag Category (เลือกหมวดแท็กค้นหา) | dropdown | `chooseMainTag(choosyTag)` | — |
| Search by name (ค้นหาจากชื่อ) | text input | `filterChoosedTag()` | — |
| Available / selected tag chips | two clickable chip lists | `chooseThisTag` adds, `removeThisTag` removes | Ok = `addTagPerContentmanager(subTagData)`; Cancel = `cancelAddTag()` |

### Modal: General Settings (ตั้งค่าทั่วไป) — `Contentmanager/modalContentSetting.cshtml`
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Enable Contentmanager Multiple Languages (เปิดการใช้งาน Contentmanager Multiple Languages) | toggle | `toggleAllowMultipleLanguage()` → `bAllowMultipleLanguage`; Save = `saveContentSetting()` | Drives the per-language content editing |

### Modal: RSS Feed Generator — `modalRssFeedConfig.cshtml`
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Language (ภาษา) | dropdown | `rssData.langRssFeed` | Disabled when `NotAllowSave` |
| Enable scheduled RSS Feed (เปิดใช้ RSS Feed แบบ Schedule) | radio (Disable=2 / Enable=1) | `rssData.bScheduleRSSFeed` | Default `'2'` (disabled) |
| Category (หมวดหมู่) | dropdown ("--All--") | `rssData.Cate` | — |
| Generated RSS URL | read-only label | `generateRssfeed()` builds `…/rssfeed.xml?cagid=&lang=&bschedule=` | "Generate" and "Copy" both call `generateRssfeed()` |

### Modal: Manage Block (Add/Edit content block) — `Contentmanager/modalContentNewBlock.cshtml`
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Upload images | file upload | adds to `makeContent.imgPath` | posts to `FilesRender/UploadFileServer` |
| Image style (`ChooseStyle`) | dropdown | `makeContent.imgType`: 1 Single (`SinglePic`), 2 Album (`AllabumPic`), 3 Slide (`SlidePic`), 4 Tab (รูปแบบแท็บ), 5 Gallery, 6 Slide Gallery | `changeToTabTemplate()` swaps the layout |
| Image position (`ChoosePositionPic`) | dropdown | `makeContent.imgPosition`: Top/Bottom/Left/Right | Hidden when imgType = 4 (Tab) |
| Tab position / Tab format (1–16) / Tab count (1–10) | dropdowns | `makeContent.tabPosition` / `tabType` / `tabCount` | Only shown when imgType = 4 |
| Block Name (`BlockName`) | text input | `makeContent.NameBlock` | — |
| Zoom Picture (`ZoomPic`) | checkbox | `makeContent.imgLightbox` (lightbox) | Shown for imgType 1/2/3/5/6 |
| Enable bullets (เปิดใช้งาน จุด) | checkbox | `makeContent.slideConfig.bBulletType` | Only for imgType = 6 (Slide Gallery) |
| Transition Speed / ความเร็ว Transition (ms) | number input | `$scope.transitionSpeed` → synced into `Contenmanagertmap.Option[0]` on change via `changeSlideTransition`; saved as `makeContent.slideConfig.transitionSpeed` | Applies to imgType = 3 Slide 01 (templateID 54, input on stab==2) and imgType = 4 Tab Slide (templateID 55, input on stab==1). **On Tab Slide (stab==1):** value is synced into `Contenmanagertmap.Option[0]` before `ContentmanagerNext` advances the step — without this sync the field resets to 400 ms on "Next". Default 400 ms when unset or 0. |

## Common tasks

### Create a new content item (article)
1. Sidebar: Management System > Manage Content (or go to `#!/Contentmanager`).
2. Click **Add Topic** (or use `#!/Contentmanager/new`).
3. Type the **Title** (and optional Subtitle).
4. Click **Add Block**, choose an image style/position (or Tab/Gallery), set a Block Name, then upload images and write the body in the Kendo rich-text editor.
5. In the right panel: tick **Categories**, add **Search Tags**, set **Scheduler** Start/End dates and Display Color if needed, fill **SEO** Keywords/Description.
6. Click **Save & Publish** (or **Draft** to save without publishing; the split-dropdown offers Save / Save and Close).

### Toggle an item active / inactive (without trashing)
1. On the list, find the content row.
2. Click the **Active** badge/toggle on the row (`checkbActive`).
3. The item is immediately hidden from (or shown on) the public page. The toggle reverts automatically if the server rejects the change.

### Set slide transition speed (Tab Slide or Slide 01 template)
1. Open or create a content item, click **Add Block**, choose imgType = 3 (Slide 01) or 4 (Tab Slide).
2. On the block settings step that has the **Transition Speed** input (stab==2 for Slide 01; stab==1 for Tab Slide), enter the speed in milliseconds (default 400).
3. For Tab Slide: after editing the speed, click **Next** — the value is now synced before the step advances and will persist on save.
4. Click **Save & Publish**.

### Edit / delete an existing item
1. On the list, use the **Edit** (pencil) tool on the row, or click the title; opens the editor.
2. To trash: click the **Trash** tool on the row (or select rows + the bulk trash button). Trashed items move to the **Trash** tab where they can be **Restored** or **Deleted permanently**.

### Manage categories
1. On the list toolbar click **Category** (Manage Category) → Manage Content Category modal.
2. Type a name + **Add**; optionally upload a Category Image, set a parent via **Select Main Category**, or toggle **Hide**.

### Manage search tags (with sub-tags / groups)
1. Toolbar **Add Search Tags** → Manage Search Tag modal.
2. Add a tag category, then **Add Sub Search Tags** (newline-separated list) and/or **Manage Tag** to link tags into groups.

### Generate an RSS feed
1. (When the button is enabled for the domain) click **Create RSS Feed** → RSS Feed Generator.
2. Pick Language, optional Category, choose schedule on/off, click **Generate**, then **Copy** the produced `rssfeed.xml` URL.

## Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Management/ViewContent.cshtml` (list + block editor); modals `Views/Management/modalContent.cshtml` (categories), `modalContentTag.cshtml` (tag categories), `modalSubTag.cshtml`, `modalGroupTag.cshtml`, `modalChooseTag.cshtml`, `modalRssFeedConfig.cshtml`, and `Views/Management/Contentmanager/modalContentNewBlock.cshtml` + `modalContentSetting.cshtml` (+ `Contentmanager/tabTemplate/template1..16.cshtml` for Tab/Gallery layouts).
- **Controller / script:** `ScriptRequire/Component/Contentmanager/Controller.js` (`ContentmanagerController`, ~6100 lines), `Service.js` (`ContentmanagerService`, `$http` wrappers), `index.js`, `tab-template.js`. Route registered in `ScriptRequire/MainSystem/Routing/Server.js` under `/Contentmanager`, `/Contentmanager/new`, `\Contentmanager\edit:contentId`. Modals are loaded via `/HomeCtrl/RenderPartial?id=~/Views/...` and shown with angular-strap `$modal`.
- **C# controller:** `Controllers/Control/ContentManagerController.cs` (route base `ContentManager/...`).
- **Save endpoint:** `ContentManager/saveContentmanager` (async `JsonResult saveContentmanager(Contentmanager content)`, line ~463). Related endpoints: `setCategory`, `delCategory`, `getCategory`, `setTagContentmanager`/`setAllTagContentmanager`, `delTagContentmanager`, `getTagContentmanager`, `saveTrashContentmanager`, `delContentmanager`/`delAllContentmanager`, `copyContentManager`, `sortContentmanager`/`reorderContentmanager`, `getContentRSSfeed` + `Rssfeed` (the public `rssfeed.xml`), `setRecentTags`/`getRecentTags`, `reindexOrdernumberByCategorieID`, `AddTagContentmanagerFromExcel`. Image uploads go to `FilesRender/UploadFileServer` (and `UploadFileServerLocal` for mp4), category image to `ContentManager/UploadFile`.

## Gotchas / multi-tenant notes
- **Language switching:** each modal/view reads the `<DomainID>languageManageBackend` cookie to pick TH vs EN labels via `isThaiLanguage`. The content **data** language is separate (`DefaultLangContent` dropdown bound to `languageSetting`), gated by the General-Settings "Enable Contentmanager Multiple Languages" toggle (`bAllowMultipleLanguage`). `Mylanguage == '523d4c71164185981a000001'` is the Thai language-id sentinel used in column-header switches.
- **Hidden-by-default controls:** "Create RSS Feed", "ReIndex Sort Order", Custom Cover ALT, Video Cover, the Javascript section, subtitle, and the Excel tag-upload are all `display:none` in the markup and surfaced selectively (per-domain script / state) — don't assume they're visible.
- **`?manage=true` admin UI** — Playwright public-render verification does NOT apply here (this is admin backend).
- **`.cshtml` files require UTF-8 BOM** and **csproj `<Content Include>` entries** (all the named modals are already registered in `Boy_Growth_a_Man.csproj`).
- **No hardcoded-domain whitelist spotted** in these views — category/tag/RSS behaviour is driven by per-domain data and the `bAllowMultipleLanguage` setting, consistent with the multi-tenant rule.
