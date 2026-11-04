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

## Alt Text สำหรับรูปภาพใน Content Block (feature/contentinline-image-alt-field)

เมื่อ upload หรือเลือกรูปใน **CommonUpload** (ใช้ร่วมกันใน Content Block ทุกประเภท) มีช่อง **Alt Text (คำอธิบายรูป)** เพิ่มขึ้นมา

### Field ที่เพิ่มมา
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Alt Text / คำอธิบายรูป (`currentImg.imageAlt`) | text input | ค่าที่ใส่จะถูก inject เป็น `alt="..."` บน `<img>` tag ที่ render ออกสู่ public | แสดงเฉพาะเมื่อ `Imgmanager != 'UploadVideo'` |

### พฤติกรรมการ auto-fill
1. เมื่อ **เลือกไฟล์** upload — `imageAlt` ถูก pre-fill จากชื่อไฟล์ (ตัดนามสกุลออก) ทันที
2. เมื่อ **เลือกรูปที่ upload แล้ว** จาก image manager — อ่านค่า alt จากชื่อไฟล์ที่ match pattern `z-z` ใน path
3. ถ้า `<img>` tag มี `alt` อยู่แล้ว — **ไม่** overwrite ด้วย fallback filename (แก้จากพฤติกรรมเดิม)

### Wired in (for developers)
- **View:** `Views/Component/ContentKendo/CommonUpload.cshtml` (เพิ่ม `div.form-group` สำหรับ alt input, `ng-if="Imgmanager != 'UploadVideo'"`)
- **Directive:** `ScriptRequire/MainSystem/Directive/Kendo/KendoImage.js` — `scope.currentImg.imageAlt` เก็บค่า; inject ลงใน rendered `<img>`, `<a fancybox>`, และ `<img>` แบบ style สอง
- **Helper:** `ScriptRequire/Helper.js` `getFileNameFromImagePath` — แก้ให้ skip fallback เมื่อ `alt` มีค่าอยู่แล้ว
- **i18n:** `ScriptRequire/domains/language/menu-by-language/website-setting.js` — `altText` (TH: "คำอธิบายรูป" / EN: "Alt Text"), `altPlaceholder` (TH: "คำอธิบายภาพ" / EN: "Image description")

---

## Paste Options Popup (feature/contentmanager-paste-options-popup)

เมื่อ **Paste (Ctrl+V)** ใน Kendo rich-text editor ของ Content Block จะแสดง popup เลือกรูปแบบการวางแทน browser `confirm()` เดิม

### Popup มี 3 ตัวเลือก
| ตัวเลือก | ภาษาไทย | ผลลัพธ์ |
|---|---|---|
| ปุ่มซ้าย (A สีแดง) | วางแบบมี Style | วางพร้อม HTML + inline style ของต้นทาง |
| ปุ่มกลาง (A ดำ) | วางแบบข้อความธรรมดา | strip HTML ทั้งหมด เหลือแค่ plain text |
| ปุ่มขวา (Ab ดำ) | วางแบบรวม Style กับปลายทาง | วางแบบ merge — ลบ inline `style=""` แต่ยังคง HTML tag structure |

### พฤติกรรมเพิ่มเติม
- ถ้า paste มี `<table>` — ครอบด้วย `<div class="table-responsive"><table class="table">` เสมอ (ทุก mode ยกเว้น plain text)
- ถ้า paste มี `src="data:image"` — reject พร้อม toastr warning "กรุณาอัพโหลดจากระบบเท่านั้น"
- ถ้า paste มี URL ที่มีคำว่า `itopplus` — แปลง `href=".../#!/"` → `href="/"` เพื่อไม่ให้ link เป็น absolute URL
- **Block ใหม่** เริ่มต้นว่างเปล่า (ไม่มี placeholder text "คลิกที่นี้เพื่อพิมพ์ข้อความระบบ" อีกต่อไป)
- Popup ปิดอัตโนมัติเมื่อคลิกนอก popup

### Wired in (for developers)
- **Controller:** `ScriptRequire/Component/Contentmanager/Controller.js` — function `showPasteOptionsPopup()`, `processPasteHtml()`, `stripInlineStyles()`, `dismissPastePopup()`. Replaces `$scope.onPaste` เดิมที่ใช้ `confirm()`
- **CSS class:** `.paste-options-popup`, `.paste-opt-btn` (inject ลง `document.body` แบบ `position:fixed`)

---

## Move Position แสดงเมื่อ filter category (feature/contentmanager-show-moveposition-on-category-filter)

ลูกศร **Move Position** (ขึ้น/ลง) ที่ใช้ reorder content item ตอนนี้แสดงขึ้นมาเมื่อ **filter ด้วย category** ด้วย ไม่ใช่แค่ตอนที่ไม่ได้ filter

### พฤติกรรม
| เดิม | ใหม่ |
|---|---|
| ลูกศร Move Position แสดงเฉพาะเมื่อ `showOrderContents` = true (filter category แล้วเรียงตาม Ordernumber) | ลูกศรแสดงเมื่อ filter category ด้วย (`searchCategoryID` มีค่า) และ sort ก็ consistent กับ All-tab |

### Wired in (for developers)
- **Controller:** `ScriptRequire/Component/Contentmanager/Controller.js` — `sortContentmanager` function ส่ง `Config.searchCategoryID` ไปด้วยตอน sort เพื่อให้ server sort ใน scope ของ category นั้น

---

## Tag Import — แสดง Error/Success Message (feature/contentmanager-tag-import-error-messages)

เมื่อ **import แท็กจาก Excel** ผ่าน "Upload tags from Excel" ใน Manage Search Tag modal ระบบจะแสดง toastr notification แทนที่จะเงียบ

### Notification
| กรณี | Toastr |
|---|---|
| Import สำเร็จ | `success` — "นำเข้าแท็กสำเร็จ / เรียบร้อย" + รีโหลด tag list อัตโนมัติ |
| Import ล้มเหลว (server error) | `error` — ข้อความจาก `getTagImportErrorMessage(data.result)` + title "นำเข้าไฟล์ไม่สำเร็จ" |
| AJAX fail (network error) | `error` — "เกิดข้อผิดพลาดในการอัพโหลด กรุณาลองใหม่ / ข้อผิดพลาด" |

### Wired in (for developers)
- **Controller:** `ScriptRequire/Component/Contentmanager/Controller.js` — jQuery fileupload `done` / `fail` callbacks ของ `AddTagContentmanagerFromExcel`
- **Domain helper:** `getTagImportErrorMessage` จาก `ScriptRequire/domains/components/contentmanager.domain` — แปลง server response เป็น error string

---

## Scheduler — Color Picker + Auto-refresh Calendar (feature/scheduler-auto-active-content)

Content ที่ใช้ **Scheduler** (ตั้งเวลาแสดงผล) มีปรับปรุงสองส่วนที่ทำงานร่วมกัน

### 1. Color Picker ใน Content Editor
ใน right panel ของ Content Editor (ส่วน **Scheduler** — วันเริ่มต้น/วันสิ้นสุด) มีช่อง **Display Color (สีในการแสดงผล)** เป็น `<input type="color">` ผูกกับ `Content.Color`

| Field (EN / TH) | Type | Effect |
|---|---|---|
| Display Color / สีในการแสดงผล (`Content.Color`) | color picker (HTML5 `type="color"`) | สีที่เลือกจะแสดงบน calendar ของ Scheduler component บนหน้าเว็บ |

### 2. Auto-refresh Calendar หลัง Save
เมื่อ Save content ที่มี `bUseScheduler = true`:
- ContentManager controller broadcast event `schedulerContentSaved`
- Scheduler component (`SchedulerController`) ฟัง event นี้ และ re-fetch + re-render calendar ทันทีโดยอัตโนมัติ
- ไม่ต้อง reload หน้าเพื่อดูการเปลี่ยนแปลงบน calendar

### Wired in (for developers)
- **Content Editor:** `Views/Management/ViewContent.cshtml` — เพิ่ม `<input type="color">` ใน scheduler-date-fields section
- **ContentManager Controller:** `ScriptRequire/Component/Contentmanager/Controller.js` — `$rootScope.$broadcast('schedulerContentSaved')` หลัง save สำเร็จ เมื่อ `Content.bUseScheduler` เป็น true
- **Scheduler Controller:** `ScriptRequire/Component/Scheduler/Controller.js` — `$scope.$on('schedulerContentSaved', ...)` re-fetch ด้วย `calendarConfigData` และ re-render ด้วย `calendarInstance.setMatrix(matrix).render()`
- **Scheduler init fix:** Scheduler ที่ไม่มี record ใน DB จะถูก auto-create (`addscheduler`) แทนที่จะ fail เงียบๆ

---

## Gotchas / multi-tenant notes
- **Language switching:** each modal/view reads the `<DomainID>languageManageBackend` cookie to pick TH vs EN labels via `isThaiLanguage`. The content **data** language is separate (`DefaultLangContent` dropdown bound to `languageSetting`), gated by the General-Settings "Enable Contentmanager Multiple Languages" toggle (`bAllowMultipleLanguage`). `Mylanguage == '523d4c71164185981a000001'` is the Thai language-id sentinel used in column-header switches.
- **Hidden-by-default controls:** "Create RSS Feed", "ReIndex Sort Order", Custom Cover ALT, Video Cover, the Javascript section, subtitle, and the Excel tag-upload are all `display:none` in the markup and surfaced selectively (per-domain script / state) — don't assume they're visible.
- **`?manage=true` admin UI** — Playwright public-render verification does NOT apply here (this is admin backend).
- **`.cshtml` files require UTF-8 BOM** and **csproj `<Content Include>` entries** (all the named modals are already registered in `Boy_Growth_a_Man.csproj`).
- **No hardcoded-domain whitelist spotted** in these views — category/tag/RSS behaviour is driven by per-domain data and the `bAllowMultipleLanguage` setting, consistent with the multi-tenant rule.

---

## Feature: Tab Slide — ปัดนิ้ว/ลากเมาส์ + วนสไลด์ต่อเนื่อง (`feature/contentmanager-tab-slide-touch-swipe`)

### What it does
เพิ่ม **touch swipe (ปัดนิ้วบนมือถือ) และ mouse drag (ลากเมาส์บน desktop)** ให้ Block รูปแบบ **Tab Slide (template 55)** ของ Content Manager พร้อมการ **วนสไลด์ต่อเนื่อง (continuous loop)** — ปัดถึงสไลด์สุดท้ายแล้ววนกลับสไลด์แรกได้เลย

### ใช้กับ Block แบบไหน
เฉพาะ Block ที่ตั้ง image layout เป็น **Tab Slide** (templateID 55) — renderer `slider_type55` เท่านั้น รูปแบบอื่น (single / album / slide / gallery) ไม่ได้รับผลกระทบ

### พฤติกรรม
| พฤติกรรม | รายละเอียด |
|---|---|
| Touch swipe (มือถือ) | ปัดซ้าย/ขวาเพื่อเปลี่ยนสไลด์บน `.slider_type55 .TabSlideItpContent` |
| Vertical scroll ยังใช้ได้ | CSS `touch-action: pan-y` — ปัดขึ้น/ลงยังเลื่อนหน้าเว็บได้ตามปกติ ไม่ถูก swipe ดักไว้ |
| Mouse drag (desktop) | กดค้างแล้วลากซ้าย/ขวาเปลี่ยนสไลด์ (`mousedown` → `mousemove` → `mouseup`) |
| วนต่อเนื่อง (loop) | `goToContentSlide(componentId, index, loopDirection)` — `'next'` ที่สไลด์สุดท้ายวนกลับสไลด์แรก, `'prev'` ที่สไลด์แรกวนไปสไลด์สุดท้าย |
| กัน init ซ้ำ | `touchContainer.dataset.touchDragInited = 'true'` — ป้องกันผูก event listener ซ้ำเมื่อ AngularJS re-compile component |

### Wired in (for developers)
- **View (จุดเริ่ม):** `Views/Component/Contentmanager/ContentManager.cshtml` — `<div class="slider_type55 TabSlideItpContent" ng-init="initTabSlideTouchDrag('@(Model._id)');">` + inline CSS `touch-action: pan-y;`
- **Template entry:** `Views/Component/Contentmanager/template/TemplateMain.cshtml` (เลือก template 55)
- **Controller:** `ScriptRequire/Component/Contentmanager/Controller.js`
  - `$scope.initTabSlideTouchDrag(componentId)` — ผูก `touchstart`/`touchmove`/`touchend`/`touchcancel` (touchmove ใช้ `{ passive: false }` เพื่อ `preventDefault` แนวนอนได้) และ `mousedown`/`mousemove`/`mouseup`; helper `getClientX(e)` / `getClientY(e)` อ่านพิกัดจาก `e.touches[0]` หรือ `e` ตรง ๆ
  - `$scope.goToContentSlide(componentId, index, loopDirection)` — เลื่อนสไลด์ + ตั้ง `tabSlideLoopTimeouts[componentId]` สำหรับวนต่อเนื่อง
- **Commit:** `a32e92fef` — `feat(contentmanager): add touch/mouse drag swipe and continuous looping to tab slide format (template 55)`

### Gotchas
- ทำงานเฉพาะ template 55 — ถ้าเปลี่ยน Block ไปใช้ layout อื่น swipe จะหายไป
- `initTabSlideTouchDrag` ถูกเรียกผ่าน `ng-init` ไม่ใช่ directive — ถ้า component ถูก re-render โดยไม่ผ่าน compile ใหม่ listener จะไม่ผูกซ้ำ (โดยตั้งใจ ตาม `dataset.touchDragInited`)

---

## Feature: Active/Inactive Toggle Per-Item (`feature/contentmanager-active-toggle`)

Toggle เปิด/ปิดการแสดงผลของ content item แต่ละรายการจากหน้า list โดยตรง โดยไม่ต้องเปิด editor

### วิธีเข้าถึง
- **Route:** `?manage=true#!/Contentmanager`
- **Field:** Badge toggle ที่แต่ละแถวใน list

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Active toggle / สถานะใช้งาน | toggle badge per row | คลิก = สลับ `manager.bActive` ทันที → เรียก `ContentmanagerService.updateFlags`; ถ้า server ตอบ `'ERROR'` ค่าจะ revert กลับ | Inactive = ซ่อนจากหน้าเว็บ แต่ยังอยู่ใน list (ต่างจาก Draft ที่ซ่อนรอ publish); ต่างจาก `bEnable` (comment) และ `bSticky` (pin) |

### Gotchas
- item ใหม่จะ active (true) โดย default จาก server
- toggle นี้ **ไม่** trash item — item ยังค้างอยู่ใน list เสมอ

---

## Feature: Custom Display Date Toggle + Save Fix (`feature/contentmanager-displaydate-save-fix`)

เพิ่ม toggle `bCustomDisplayDate` สำหรับกำหนดวันที่แสดงผล (Display Date) เองในหน้า editor พร้อมแก้ bug วันที่ไม่ persist หลัง save

### วิธีเข้าถึง
- **Route:** `?manage=true#!/Contentmanager/edit:contentId` → แถบ config ขวามือ
- **Field:** "กำหนดวันที่แสดงผลเอง" toggle → เปิดแล้วจะแสดง date picker

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| กำหนดวันที่แสดงผลเอง (`bCustomDisplayDate`) | toggle | เปิด = แสดง date picker ให้เลือก Display Date | เมื่อ toggle ปิด ค่า Display Date จะไม่ถูกส่งไปกับ save payload |
| Display Date | date-time picker | วันที่ที่จะแสดงผลบนหน้าเว็บ (อาจต่างจาก created date) | แก้ bug: ก่อนหน้านี้วันที่ที่กำหนดจะหายหลัง save เนื่องจาก payload binding ผิด |

### Gotchas
- bug เดิมคือวันที่ไม่ persist เพราะ field ไม่ถูก include ใน save payload เมื่อ toggle ปิด

---

## Feature: Mobile Lightbox สำหรับ Image Slide Gallery (`feature/contentmanager-mobile-lightbox`)

Lightbox full-screen สำหรับ image-slide gallery เมื่อเปิดบนมือถือ — tap รูปเพื่อดูแบบเต็มจอ

### วิธีเข้าถึง
- ไม่มี admin toggle — ทำงานอัตโนมัติบนมือถือ (mobile detect)

### พฤติกรรม / Fields
| พฤติกรรม | รายละเอียด |
|---|---|
| tap รูป | เปิด lightbox full-screen |
| swipe เพื่อปิด | ปัดลงหรือ swipe เพื่อ dismiss |
| pinch-to-zoom | ซูมรูปได้ภายใน lightbox |

### Gotchas
- ใช้ module ใหม่ `mobileLightbox.js`
- ทำงานเฉพาะ mobile (ตรวจ user-agent / touch device)
- ไม่กระทบ desktop behavior

---

## Feature: Gallery Lazy Load บนมือถือ (`feature/contentmanager-gallery-lazyload-mobile`)

Gallery slides โหลด on-demand บนมือถือ — ไม่โหลดทุก slide พร้อมกันตั้งแต่ต้น

### วิธีเข้าถึง
- ไม่มี admin toggle — ทำงานอัตโนมัติบนมือถือ

### พฤติกรรม / Fields
| พฤติกรรม | รายละเอียด |
|---|---|
| Lazy load via IntersectionObserver | slide โหลดเมื่อเข้าใกล้ viewport เท่านั้น |
| เฉพาะมือถือ | desktop โหลดปกติทั้งหมด |

### Gotchas
- ลด initial load time บน mobile ได้มาก โดยเฉพาะ gallery ที่มีรูปเยอะ
- ไม่ต้องตั้งค่าใดๆ ใน admin

---

## Feature: Manual Order Number + Drag-and-Drop Reorder (`feature/contentmanager-manual-ordernumber`)

admin กำหนด order number ของ content item เองด้วย input field หรือ drag-and-drop

### วิธีเข้าถึง
- **Route:** `?manage=true#!/Contentmanager` → filter ตาม category ก่อน → controls ที่แต่ละ item row
- **หมายเหตุ:** ต้อง **filter ด้วย category** ก่อนเท่านั้น — Move Position controls และ order number input ถึงจะปรากฏ

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Order number input | number input per item | กรอกเลขเพื่อกำหนด position ของ item | แสดงเฉพาะเมื่อ filter category แล้ว |
| Move Position (ย้ายตำแหน่ง) | ลูกศรขึ้น/ลง per row | `sortContentmanager(id,'A'/'B')` | แสดงเฉพาะเมื่อ `showOrderContents` (filter category active) |

### Gotchas
- filter category ก่อนทุกครั้ง — ถ้าอยู่ใน All / no filter จะไม่เห็น order controls
- หลัง delete item → list auto-refresh ใน 3 วินาที

---

## Feature: Search Box ใน Category Filter Dropdown (`feature/contentmanager-category-filter-search`)

เพิ่ม search box ใน dropdown "Filter by Category" ของ Content Manager list — พิมพ์เพื่อ filter รายชื่อ category แบบ real-time

### วิธีเข้าถึง
- **Route:** `?manage=true#!/Contentmanager`
- **Field:** dropdown "Filter by Category" → มี search box ด้านบน

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Search box ใน category dropdown | text input | filter รายชื่อ category แบบ real-time ขณะพิมพ์ | bound กับ `catFilterText` |
| Subcategory | collapse/expand | subcategory ซ่อน (collapse) โดย default, คลิก expand ได้ | — |

### Gotchas
- เหมาะสำหรับไซต์ที่มี category จำนวนมาก
- search ไม่ case-sensitive

---

## Feature: Sub-brand / Brand Hierarchy ใน Category Manager (`feature/category-manager`)

รองรับการสร้าง brand hierarchy (parent → child) ใน Category/Brand Manager ของ Shopcart

### วิธีเข้าถึง
- **Route:** `?manage=true#!/Shopcart/Collection/AddBrand/` หรือ `?manage=true#!/Shopcart/Collection`
- **Field:** dropdown "เลือก Parent Brand" เมื่อสร้าง/แก้ไข brand

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Parent Brand (เลือก Parent Brand) | dropdown | เลือก parent เพื่อให้ brand นี้เป็น child brand | เว้นว่าง = top-level brand |

### Gotchas
- ใช้สำหรับ sub-brand หรือ brand ที่อยู่ภายใต้ brand หลัก
- ตรวจสอบว่า Category/Brand Manager เปิดใช้งานสำหรับ domain แล้ว

---

## Feature: Purge Word Styles Toggle Per-Component (`feature/contentword-purge-style-toggle`)

toggle per-component เลือกว่าจะ strip inline styles จาก Microsoft Word เมื่อ paste หรือไม่

### วิธีเข้าถึง
- **Route:** Content Manager → editor → block settings (gear icon)
- **Field:** "ลบ Style จาก Microsoft Word (Purge Word Styles)" toggle

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| ลบ Style จาก Microsoft Word / Purge Word Styles | toggle per block | เปิด (default) = strip Word inline styles เหลือแค่ bold/italic/underline; ปิด = paste เก็บ styles ทั้งหมด | ค่า default = เปิด (strip) |

### Gotchas
- เปิดใน block settings (gear) ของแต่ละ block ไม่ใช่ global setting
- ถ้าต้องการเก็บ formatting จาก Word → ปิด toggle นี้ก่อน paste

---

## Feature: Search Tag Filter — AND ทุก Level (`feature/search-tag-filter-all-levels`)

แก้ Search component tag filter ให้ AND ทุก level ที่เลือกพร้อมกัน (ไม่ใช่แค่ last-selected)

### วิธีเข้าถึง
- ไม่มี admin toggle — fix พฤติกรรมอัตโนมัติ

### พฤติกรรม / Fields
| เดิม | ใหม่ |
|---|---|
| filter แค่ level เดียว (level ล่าสุดที่เลือก) ทำให้ผลลัพธ์ไม่แม่น | AND ทุก level ที่เลือกพร้อมกัน — แสดงเฉพาะ content ที่มีครบทุก tag ที่ filter |

### Gotchas
- ผู้ใช้งานไม่ต้องทำอะไร — พฤติกรรมเปลี่ยนอัตโนมัติ
- อาจทำให้ผลลัพธ์ search น้อยลงถ้า filter หลาย level — นั่นคือ behavior ที่ถูกต้อง

---

## Feature: Bullet Pager สำหรับ Fade Gallery (`feature/image-gallery-fade-bullet`)

toggle แสดง bullet pager (จุดด้านล่าง) สำหรับ Image Gallery รูปแบบ Fade (imgType 7)

### วิธีเข้าถึง
- **Route:** Layout Manager → Image Gallery component → gear config → เลือก Type = Fade
- **Field:** "แสดง Bullet Pager (Show Bullet Pager)" checkbox

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| แสดง Bullet Pager / Show Bullet Pager (`Image.bShowBullet`) | checkbox | เปิด = แสดง bullet dot pager ด้านล่าง Fade gallery | เฉพาะ imgType 7 (Fade) เท่านั้น |

### Gotchas
- ต้องเลือก Type = **Fade** ก่อนถึงจะเห็น field นี้
- `ng-model: Image.bShowBullet`

---

## Feature: วันที่แสดงบนเว็บ (Display Date) + Toggle กำหนดเอง (`feature/contentmanager-displaydate-save-fix` + `feature/contentmanager-copy-above-original`)

### What it does
เพิ่มระบบ **"วันที่แสดงบนเว็บ"** ให้ admin เนื้อหาแต่ละชิ้นสามารถกำหนดวันที่ที่จะแสดงบนหน้าเว็บได้เอง แยกจากวันที่สร้าง (CreatedDate) หรือวันที่แก้ไขล่าสุด (Lastupdate) — เช่น retroactive publish บทความเก่า หรือจัดเรียงตามวันที่ต้องการ

สองส่วนที่ทำงานร่วมกัน:
- **`displayDate`** — ฟิลด์เก็บวันที่เป็น millisecond timestamp string
- **`bUseDisplayDate`** — toggle "กำหนดวันที่เอง" เพื่อสลับระหว่าง custom date กับ Lastupdate

### Fields ใหม่ใน Editor (right-hand accordion)

| Field (EN / TH) | ชนิด | ความหมาย | ข้อควรระวัง |
|---|---|---|---|
| Display Date (วันที่แสดงบนเว็บ) | header label | กลุ่มควบคุมวันที่แสดงผลสาธารณะ | — |
| กำหนดวันที่เอง / Use custom date | checkbox | `Content.bUseDisplayDate` — เปิดแล้ว date picker แสดงขึ้น; ปิดใช้ Lastupdate แทน | default = ปิด (ใช้ Lastupdate) |
| วันที่แสดงบนเว็บ (ค่าเริ่มต้น: วันที่แก้ไขล่าสุด) | Kendo date-time picker | `Content.displayDate` — แสดงเมื่อ `bUseDisplayDate = true` | `ng-show="Content.bUseDisplayDate"` |

### Logic วันที่ที่แสดงหน้า Editor preview
```
Content.bUseDisplayDate && Content.displayDate > 0
  ? displayDate      ← ใช้วันที่ที่ admin กำหนด
  : Content.Lastupdate   ← ใช้วันที่แก้ไขล่าสุด (default)
```

### การเก็บค่า displayDate
- **Save:** แปลง date object → `String(moment(date).valueOf())` (millisecond string); ว่าง/ไม่ valid → `'0'`
- **Load:** `Number(displayDate) > 0` → `new Date(Number(displayDate))`; ไม่งั้น `null`
- ส่งผ่าน query string: `&displayDate=...&bUseDisplayDate=true/false`

### Wired in (for developers)
- **C# Model:** `Contentmanager.cs` — `public string displayDate { get; set; }` + `public bool bUseDisplayDate { get; set; }` + `public string Lastupdate { get; set; }` (read-only จาก DB)
- **Query string:** `ContentmanagerService.getQueryString()` — เพิ่ม `&displayDate=` และ `&bUseDisplayDate=`
- **Controller:** `ScriptRequire/Component/Contentmanager/Controller.js` — parse/format `Content.displayDate` + set `ConfigData.bUseDisplayDate` ก่อน save
- **View:** `Views/Management/ViewContent.cshtml` — checkbox `ng-model="Content.bUseDisplayDate"` + `<input kendo-date-time-picker ng-model="Content.displayDate">` ใน `ng-show="Content.bUseDisplayDate"`
- **Commits:** `628f7a4ad` (feat: displayDate field + UI), `892c0e239` (feat: bUseDisplayDate toggle + Lastupdate default), `fd72db550` (fix: send displayDate on save + restore picker)

### Gotchas
- `displayDate = '0'` หรือว่าง → ถือว่า "ไม่ได้ตั้ง" — frontend ใช้ `Lastupdate` แสดงแทน
- `bUseDisplayDate = false` → แม้จะมีค่า `displayDate` อยู่ ก็ยังแสดง `Lastupdate` (ค่า displayDate ไม่ถูกทิ้ง เพียงแค่ไม่ใช้)
- ทั้งสอง branch (`contentmanager-displaydate-save-fix` และ `contentmanager-copy-above-original`) เป็นฟีเจอร์เดียวกัน แยก commit เพื่อ review

---

## Feature: Popup ตัวเลือกการวาง (Paste Options Popup) (`feature/contentmanager-paste-options-popup`)

### What it does
แทนที่ browser `confirm()` dialog เดิมด้วย **popup Word-style** ที่ปรากฏใกล้จุดวางข้อความ — ให้ admin เลือกได้ว่าจะวางเนื้อหาอย่างไรก่อนที่จะ commit ลง editor

### 3 ตัวเลือกใน Popup

| ปุ่ม (icon + tooltip) | mode | พฤติกรรม |
|---|---|---|
| A (สีแดง) — Keep Source Formatting / วางแบบมี Style | `styled` | วาง HTML เต็มรูปแบบ ปรับตาราง responsive + ลบ inline data-image + fix ลิงก์ภายใน iTopPlus |
| A (สีเดิม) — Keep Text Only / วางแบบข้อความธรรมดา | `plain` | strip inline styles ทั้งหมดออก คงแค่ text + structure |
| Ab — Merge Formatting / วางแบบรวม Style กับปลายทาง | `merge` | ใช้ Kendo `pasteCleanup` merge กับ style ปลายทาง |

### พฤติกรรม UI
- Popup สร้างเป็น `div.paste-options-popup` แนบใน `document.body` ณ ตำแหน่ง cursor (BoundingClientRect)
- **Viewport clamp** — ถ้า popup เกินขอบขวา/ล่างของ viewport จะถูก shift เข้ามาอัตโนมัติ
- กด Escape หรือ click นอก popup → ปิด popup (event listener บน `document`)
- Popup ถูก dismiss อัตโนมัติหลัง user เลือก mode

### ฟังก์ชันหลัก
| Function | หน้าที่ |
|---|---|
| `showPasteOptionsPopup(kendoEditor, originalHtml)` | สร้าง + วาง popup ณ cursor position |
| `dismissPastePopup()` | ลบ popup ออกจาก DOM + ถอด document listener |
| `processPasteHtml(html)` | ปรับ HTML ก่อนวาง: wrap ตาราง responsive, ลบ base64 image, fix internal href |
| `stripInlineStyles(html)` | regex strip `style="..."` ทุก attribute |

### Wired in (for developers)
- **Controller:** `ScriptRequire/Component/Contentmanager/Controller.js` — ฟังก์ชันทั้งหมดข้างต้น; hook เข้า Kendo editor `paste` event
- **View:** ไม่มี markup พิเศษ — popup สร้างใน JS ล้วน (`document.createElement('div')`)
- **CSS:** `.paste-options-popup`, `.paste-opt-btn` — defined inline ใน controller หรือ scoped style
- **Commits:** `9f053763f` (feat: replace confirm with popup), `50af3d9e6` + `4df6e7473` (fix: paste logic refinements)
