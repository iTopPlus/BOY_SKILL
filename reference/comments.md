# Comment Manager (จัดการฟอร์ม Comment)

## What it does
Lists every page/component on the site that has visitor comments, grouped by source, so an admin can review and delete individual comments. It is moderation-by-deletion only — there is no approve/reject toggle; comments appear publicly as soon as a visitor posts them, and the admin's only action here is removing unwanted ones.

## How to get there
This is **not** a top-level sidebar item. It is reached from the **Form Manager** page:
- **Sidebar:** Left slidebar > Form Manager (จัดการแบบฟอร์ม) → opens Form Manager, then click the **"Manage Comment form" (จัดการฟอร์ม Comment)** button in that page's button group.
  - The Form Manager sidebar entry (`#!/FormManagement`) is hidden when `bFormOptimize` is set; the "Manage Comment form" button is only rendered when `!Config.Optimization.bAdvanceOptimize` (i.e. on domains using the advanced/optimized build, the button — and thus this entry point — does not appear).
- **Route (direct):** `https://demo110.itopplus.com/?manage=true#!/ManageComment`
  - (The button in Form Manager links to `?manage=true/#!/ManageComment`.)

## Fields on the screen
This is a read-and-delete grid, not a form — there are no editable inputs. Two table levels: the outer source list, and (when expanded) the per-comment detail rows.

### Outer table — one row per comment source
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Item (รายการ) | Read-only text | Name of the page/component carrying the comments (`CommentName`). | — |
| Type (ประเภท) | Read-only text | Source type (`CommentType`): `Comment` = a Comment component on a normal page (webboard-style), `Shopcart` = comments on a product/shop page, `ContentManager` = comments on a content (article/blog) page. | The raw enum string is shown verbatim, not a friendly/translated label. |
| Comment Count (จำนวนคอมเม้นต์) | Read-only number | Number of comments under this source (`commentDetail.length`). | — |
| Show (แสดง) | Button | Expands/collapses the inner detail rows for that source (`expandingComment`). Toggles in place; nothing is saved. | Labelled with a pencil icon but it only expands — it does not edit. The expand row is hidden when the source has 0 comments. |

### Inner table — one row per comment (shown after "Show")
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Name (ชื่อ) | Read-only text | Commenter's display name (`nameuser`). | — |
| Comment (คอมเม้นต์) | Read-only text | The comment body (`text`). | — |
| IP Address (IP Address) | Read-only text | IP the comment was posted from (`IPAddress`). | Label is "IP Address" in both TH and EN. |
| Delete (ลบทิ้ง) | Button | Deletes that single comment after a confirm dialog (`delComment`). | The only mutating action on the page. No undo. |

Not displayed but present in the data model (`commentDetailObj`): `_id`, `imgFile` (a comment image), `CreateDate`. These are returned by the API but the grid does not render them.

### Paging controls (bottom)
| Control (EN / TH) | Type | Effect |
|---|---|---|
| Previous (ก่อนหน้า) | Button | Loads the previous page of comment sources. Disabled on page 0. |
| `{current}/{max}` | Read-only text | Current page / total pages indicator. |
| Next (หน้าถัดไป) | Button | Loads the next page of comment sources. Disabled on the last page. |

Page size is fixed at **10** sources per page (`pageSize = 10`, hardcoded in the controller; no UI to change it).

## Common tasks
### Review the comments on a page/product
1. Open Form Manager from the sidebar, then click **Manage Comment form** (or go straight to `#!/ManageComment`).
2. Find the source row by its **Item** name and **Type**, and read the **Comment Count**.
3. Click **Show** (แสดง) on that row to expand the per-comment list (Name / Comment / IP Address).
4. Use **Previous / Next** if the source you want is on another page.

### Delete an unwanted comment
1. Expand the source with **Show**.
2. Click **Delete** (ลบทิ้ง) on the offending comment row.
3. Confirm in the dialog ("ต้องการลบข้อมูล ?" / "Delete this data?").
4. On success the list reloads and the source stays expanded; on failure an error dialog ("ไม่สามารถลบข้อมูลได้." / "Cannot delete the data.") appears.

## Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/ManageComment/ManageComment.cshtml` (grid). Reached from `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Management/ViewFormControl.cshtml` (Form Manager, the "Manage Comment form" button).
- **Controller / script:**
  - AngularJS: `Boy_Growth_a_Man/Boy_Growth_a_Man/ScriptRequire/System/ManageComment/Controller.js` (controller `ManageCommentController`), `.../Service.js`, `.../index.js`.
  - Hash route registered in `Boy_Growth_a_Man/Boy_Growth_a_Man/ScriptRequire/MainSystem/Routing/Server.js` (`.when('/ManageComment', …)`, controller `ManageCommentController`).
  - Top-bar title binding in `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Shared/_TopMenuBar.cshtml` + `CurrentURLCheck='ManageComment'` set in `ScriptRequire/MainSystem/Controller/Global/RouteChangeSuccess/index.js`.
  - C# (list): `Boy_Growth_a_Man/Boy_Growth_a_Man/Controllers/ManageCommentController.cs` → `Models/ManageComment/ManageCommentRepository.cs` → PoolNode `/Component/managecomment/GetAllComment`.
  - C# (delete): `Boy_Growth_a_Man/Boy_Growth_a_Man/Controllers/Control/CommentController.cs` (`delComment`) → `Models/Comment/CommentRepository.cs` `deleteComment`.
- **Load endpoint:** `POST ManageComment/GetAllComment` (body `{ DomainID, currentPage, pageSize }`) → returns `{ commentList, totalPage, currentPage }`.
- **Delete endpoint:** `POST Comment/delComment` with body `{ Comment: { DomainID, CommentID, CommentType, + one of ComponentID / ProductID / ContentID depending on type } }`. Returns the string `"Success"` or `"false"`. (Note: not `Localconfig/saveConfig` — comment moderation uses the dedicated Comment controller.)

## Gotchas / multi-tenant notes
- **Moderation = delete only.** There is no approve / hide / unhide toggle on this screen. The `bDisplay` / `bMember` config fields exist on the comment model but belong to the public Comment **component's** settings (`Views/Component/Comment/`), not to this moderation grid.
- **Entry point is gated by build flags, not a domain whitelist.** The link only shows when `!Config.Optimization.bAdvanceOptimize`, and the parent Form Manager sidebar item is hidden when `bFormOptimize` is true. These are per-domain config flags (the multi-tenant-safe pattern), not hardcoded domain IDs — no hardcoded-domain logic was found in this feature.
- **`DomainID` is server-enforced.** `GetAllComment` overwrites `data.DomainID` with `HtmlHelperExtensions.DomainID` server-side, so a client cannot read another tenant's comments by spoofing the body.
- **Delete must send the matching parent id.** The client picks `ComponentID` / `ProductID` / `ContentID` based on `CommentType`; an unknown type falls back to `ComponentID`. If the source type is mislabelled the delete may target the wrong key.
- **Comment image (`imgFile`) and create date are not shown.** They exist in the API payload but the grid omits them — if a comment includes an uploaded image, moderators can't see it from this screen.
- **`pageSize` is hardcoded to 10** in the Angular controller; there is no UI to change page size.
- **English detection quirk:** the view reads the `…languageManageBackend` cookie expecting `"th"`/`"eng"`, while the controller's `isEng` check compares against `'eng'`. Labels in the Razor markup use `isThaiLanguage` (cookie == `"th"`); the swal dialogs use the JS `isEng` flag. Both keep the page bilingual but are computed independently.
