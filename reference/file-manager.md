# File Manager (จัดการข้อมูลไฟล์)

## What it does
Central media library for a tenant: browse/delete every image the site has uploaded (banners, mobile banners, content images, organized into albums/categories), upload and manage member-owned document files, and build 360° image-spinner sets. All three screens share one AngularJS controller (`ManagefileController`).

## How to get there
The sidebar "File Manager" entry (`manageFileData` = **File Manager** / จัดการข้อมูลไฟล์) is the member file-list screen and is gated by the per-domain config flag `bListFilesByMember`. The image gallery and the 360 spinner are sibling routes on the same controller.

- **Sidebar:** Manage panel left rail > **File Manager (จัดการข้อมูลไฟล์)** — only shown when `bListFilesByMember` is enabled for the domain. The 360 spinner appears just below as **360 Image Presentation** (`image360Presentation`), gated by `bImageSpinner`.
- **Route (member file list — the sidebar "File Manager"):** `https://demo110.itopplus.com/?manage=true#!/FileDocumentManage`
- **Route (image gallery — All / Content / Banner / Mobile, used as the image picker):** `https://demo110.itopplus.com/?manage=true#!/Managefile`
- **Route (360 image spinner):** `https://demo110.itopplus.com/?manage=true#!/ImageSpinnerManage`

All three load their Razor view through `FilesRender/RenderPartial?id=/views/MainManagefile/<View>.cshtml` and use `controller: 'ManagefileController'`.

## Fields on the screen

### Screen 1 — Image gallery / picker (`#!/Managefile`, view `Managefile.cshtml`)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Previous / Next (ก่อนหน้า / หน้าถัดไป) | buttons | Paginate the image grid (`pageSize` = 14). | "Next" disabled on last page or when the Content tab is active. |
| All Images | breadcrumb link | Shows every file type (`coverType('ALL')`). | — |
| Content | breadcrumb link | Switches to the album/category view (`CONTENTIMG`). | — |
| Banner | breadcrumb link | Filters to desktop banner images (`BANNER`). | — |
| Mobile | breadcrumb link | Filters to mobile banner images (`BANNERMOBILE`). | — |
| Image thumbnail / Download / remove (x) | image tile + buttons | Each tile shows the image, a Download link, and a remove (delete) icon. | Delete prompts a JS `confirm`; calls `MainManagefile/deleteimg`. |
| Add content image category (เพิ่มหมวดหมู่รูปภาพของเนื้อหา) | text input + Add (เพิ่ม) button | Creates a new content-image album/category. | Only on the Content tab. Posts to `MainManagefile/addCategories`. |
| Photo album list (อัลบัมรูปภาพ) | list (nav-pills) | Click a category to filter images; the active category shows a delete (x). | Delete posts to `MainManagefile/delCategories`. |
| Select category (--- เลือกหมวดหมู่ ---) | dropdown (per image) | Reassign a content image to a different album. | Posts to `MainManagefile/changeCategories`. |

### Screen 2 — Member file list (`#!/FileDocumentManage`, view `FileDocumentManage.cshtml`)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Search member (ค้นหาสมาชิก) | text input + Search (ค้นหา) / Clear search (เคลียร์ค่าการค้นหา) buttons | Look up a member to attach uploaded files to. | Searches via `MemberService.searchMember`. |
| Member list (--- รายชื่อสมาชิก ---) | dropdown | Pick the member that owns the files you upload. | Disabled until a search returns results. Upload form is hidden until a member is chosen (`choosedMemberID`). |
| Search files (file name, member ID, member name) (ค้นหาไฟล์ (ชื่อไฟล์, รหัสสมาชิก, ชื่อสมาชิก)) | text input | Filters the file table; debounced ~3s, or Enter to search now. | Posts to `MainManagefile/getAllFilesManages`. |
| Choose file... (เลือกไฟล์...) | file upload (multiple) | Uploads one or more files for the selected member; shows a progress bar. | jQuery File Upload → `POST ./MainManagefile/UploadFilesManager/` (multipart). Only visible after a member is selected. |
| File list (รายการไฟล์) | table column | Shows `Realfilename`. | — |
| Upload date (วันที่อัพโหลด) | table column | `CreateDate` (Thai date filter). | — |
| Last modified (วันที่แก้ไขล่าสุด) | table column | `EditDate` (Thai date filter). | — |
| File owner (เจ้าของไฟล์) | table column | `MemberName`. | — |
| Edit (แก้ไข) | button (per row) | Re-opens the file picker to replace that file (keeps the same `_id`). | Triggers `editFileManage` → re-uploads over `UploadFilesManager`. |
| Delete (ลบทิ้ง) | button (per row) | Deletes that one file. | `swal` confirm → `MainManagefile/delFileManageById`. |
| Delete all (ลบทั้งหมด) | button | Deletes all files in the current result set / for all members. | `swal` confirm. Disabled when the list is empty. |
| Pagination | component | Page through file results (`pagesizeitem` = 15). | Rendered only when not the admin auth path (`!(auth && bAdmin)`). |

### Screen 3 — 360 Image Spinner (`#!/ImageSpinnerManage`, view `ImageSpinnerConfig.cshtml`)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Select spinner (กรุณาเลือก Spinner) | dropdown | Loads an existing image set by name. | Disabled when no sets exist. |
| Name the spinner (กรุณาตั้งชื่อ Spinner) | text input + Add (เพิ่ม) button | Creates a new image set. | Rejects duplicate names. Posts to `MainManagefile/saveImageSetByName`. |
| Choose file... (เลือกไฟล์...) | file upload (multiple) | Uploads the frames for the selected spinner; sequential upload with progress bar. | `POST ./MainManagefile/UploadMultipleFileSet/`. Each image must be ≤ 2000×2000 px or it's rejected. Files auto-named `image_<set>_spinner_0NN`. |
| Frame width (ความกว้างกรอบรูป) | text input | Container width (px) used in the generated embed script. | Defaults to 500. |
| Rotation speed (ความเร็วหมุนรูป) | range slider (-199 to 100) | Spin/auto-rotate speed in the generated script. | — |
| images list | read-only list | Shows the expected frame names for the chosen set. | Derived from the set's `countnumber`. |
| Delete (ลบ) | button | Removes the current spinner set. | `removeSpinner()`. |
| code / Copy code | textarea + button | Holds the generated `<div>` + JavascriptViewer embed script; Copy code copies it to clipboard. | Populated by **Generate Spinner**. |
| Generate Spinner | button | Builds the embed script and renders a live 360 preview. | Warns if no spinner/frames selected. Image URLs point at `FileServer/ImageServer/<UploadPath>/...`. |

## Common tasks

### Select / replace an image for a component or banner
1. From a component or banner editor, choose the action that opens the image manager (it navigates to `#!/Managefile` with the editor's content id stashed via `ContentParam`).
2. Use the **All / Content / Banner / Mobile** breadcrumbs to find the image.
3. Click the image (`Imgchoose`) and confirm "Do you want to use this image?" — it saves via `layoutmanager/saveImgContent` and returns you to `./LayoutManager#!`.

### Upload a document file for a member
1. Go to `#!/FileDocumentManage`.
2. Search a member and pick them from the **Member list** dropdown (the upload form is hidden until a member is selected).
3. Click **Choose file...** and select one or more files; watch the progress bar.
4. The file appears in the table; use **Edit** to replace it or **Delete** to remove it.

### Add a content-image album
1. Go to `#!/Managefile`, click the **Content** breadcrumb.
2. Type a name in **Add content image category** and click **Add**.
3. Click the new album in the list to filter; reassign images to it via the per-image **Select category** dropdown.

### Build a 360 image spinner
1. Go to `#!/ImageSpinnerManage`.
2. Type a name, click **Add** to create the set.
3. Click **Choose file...** and upload the rotation frames (each ≤ 2000×2000).
4. Set **Frame width** and **Rotation speed**, then click **Generate Spinner**; copy the embed code from the **code** box.

## Wired in (for developers)
- **View(s):**
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/MainManagefile/Index.cshtml` (includes `Managefile`)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/MainManagefile/Managefile.cshtml` (image gallery / picker)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/MainManagefile/FileDocumentManage.cshtml` (member file list)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/MainManagefile/ImageSpinnerConfig.cshtml` (360 spinner)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Files/RenderPartial*.cshtml` (public/theme render dispatch — not the admin file UI)
- **Controller / script:**
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/ScriptRequire/System/Managefile/Controller.js` (`ManagefileController`)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/ScriptRequire/System/Managefile/Service.js` (`ManagefileService`)
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/ScriptRequire/System/Managefile/index.js`
  - `Boy_Growth_a_Man/Boy_Growth_a_Man/Controllers/MainManagefileController.cs`
  - Routes: `ScriptRequire/MainSystem/Routing/Server.js` — `/Managefile`, `/FileDocumentManage`, `/ImageSpinnerManage`
  - Sidebar: `Views/LayoutManager/_SlideBarHomeNew.cshtml` (lines ~460–471)
  - Labels: `ScriptRequire/domains/language/menu-by-language/menuSlideBarNameByLanguage.js` (`manageFileData`, `image360Presentation`)
- **Save endpoints (all under `MainManagefile/`):**
  - Images: `getManagefile`, `getManagefiletype`, `deleteimg`
  - Categories: `addCategories`, `delCategories`, `changeCategories`, `getAllCategories`
  - Member files: `UploadFilesManager` (multipart upload), `getAllFilesManages`, `delFileManageById`
  - 360 spinner: `UploadMultipleFileSet` (multipart upload), `saveImageSetByName`, `getAllImageSetByDomain`, `getImageSetByName`
  - Image-into-content (from the picker): `layoutmanager/saveImgContent`

## Storage note
- Uploaded bytes are not written by `MainManagefileController` directly; it hands the `HttpPostedFileBase` to `FileTokenRepository.UploadFileServer` (`ImageUploadAuth`) / `UploadFileServerCustomName`, which pushes to the tenant's external image/file server. The saved DB `FilePath` is a `/filesdirectserver/<fileserver>/<UploadFolder>/<file>` reference; rendered image paths use `./Files/Name/<prefix><FilePath>` (prefixes `BT/BO`, `BMT/BMO`, `CT/CO` for Banner / Mobile / Content) and spinner frames resolve through `FileServer/ImageServer/<UploadPath>/...`.
- The platform's data layer is MongoDB + GridFS (per project architecture); file/image metadata records (`Managefile`, `ManageFileOwner`, `ImageSet`, categories) are persisted via the PoolNode LocalService API behind `IManagefileRepository`.

## Gotchas / multi-tenant notes
- **Per-domain gating, no hardcoded whitelist (good):** the sidebar "File Manager" entry is shown only when `HtmlHelperExtensions.Config.bListFilesByMember` is true, and the 360 spinner only when `bImageSpinner` is true — both are per-domain admin config flags, not in-code domain lists.
- Every controller action calls `CGClass.ValidateToken(Request)` and most require `[RequireLogin]`; the AngularJS Service sends the `RequestVerificationToken` header. Two member-file read/delete actions (`getAllFilesManages`, `delFileManageById`) are not decorated `[RequireLogin]` but still validate the token.
- The member-file upload form is hidden until a member is chosen — uploading without selecting a member is not possible from the UI.
- Spinner frame uploads are hard-capped at 2000×2000 px client-side; larger images are rejected with a toast before upload.
- The route name `MainManagefile` is registered in `App_Start/RouteConfig.cs` (Default-route whitelist) and `FilesRender`/`MainManagefile` are reachable; a new sibling action just needs to live on these already-whitelisted controllers.
