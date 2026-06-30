# Form Manager (จัดการแบบฟอร์ม)

## What it does
Builds custom data-entry / contact forms (drag-and-drop fields, layouts, themes) that can be placed on a page, and manages where each submission goes: a per-form list of notification email recipients plus a printable / Excel-exportable submission history.

## How to get there
- **Sidebar:** Website Settings (ตั้งค่าเว็บไซต์, the left settings rail) > Form Manager (จัดการแบบฟอร์ม). Sidebar key is `manageforms` (EN "Form Manager" / TH "จัดการแบบฟอร์ม"), rendered in `Views/LayoutManager/_SlideBarHomeNew.cshtml` and only shown when `bFormOptimize` is false. The legacy `_MainMenu.cshtml` link is labelled "Manage Data Forms" (จัดการรูปฟอร์มกรอกข้อมูล).
- **Route (form list):** `https://demo110.itopplus.com/?manage=true#!/FormManagement`
- **Route (form builder, opened from "Create new form" / "Edit form"):** `https://demo110.itopplus.com/?manage=true#!/generateForm/<formId>`
- The list page's other panels (Config recipients, History, Rename, Conversion) are **in-page overlays** toggled by `ng-click` (e.g. `config_Form`, `viewhistory`, `editFormName`, `addConversion`) inside `ViewFormControl.cshtml`, not separate routes.

## Fields on the screen

### Form list page (`#!/FormManagement`, `ViewFormControl.cshtml`)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Create new form (สร้างฟอร์มใหม่) | button | Opens the "Add a data-entry form" panel | — |
| Manage table form / Table Form (จัดการแบบฟอร์มตาราง) | link button | Goes to `#!/TableComponent` | Only shown when `Config.Optimization.bAdvanceOptimize` is **false** |
| Manage Comment form (จัดการฟอร์ม Comment) | link button | Goes to `#!/ManageComment` | Only shown when `bAdvanceOptimize` is false |
| Search forms (ค้นหาฟอร์มกรอกข้อมูล) | text input | Client-side filter of the form list (`ChangeForm`) | Clear button resets and reloads the list |
| Form name (ชื่อฟอร์ม) | table column | Read-only display of `Formname` | Paged 10 per page |
| History | button (per row) | Opens the submission-history overlay (`viewhistory`) | Toast "No history" if empty |
| Config | button (per row) | Opens the notification-email overlay (`config_Form`) | — |
| Rename form (เปลี่ยนชื่อฟอร์ม) | button (per row) | Opens the rename overlay (`editFormName`) | — |
| Edit form (แก้ไขฟอร์ม) | button (per row) | Navigates to the drag-and-drop builder `#!/generateForm/<id>` (`editForm`) | — |
| Conversion | button (per row) | Opens the Conversion Tracking overlay (`addConversion`) | — |
| Delete (ลบทิ้ง) | button (per row) | Confirm dialog, then deletes the form (`removeForm`) | — |

### Add form panel (`#addFrom` overlay)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Form / Form name (แบบฟอร์ม / ชื่อฟอร์ม) | text input (required) | New form's `Formname` | Save disabled while empty; on save it auto-seeds the recipient list from the site-owner email(s), creates the form, then jumps straight into the builder (`#!/generateForm/<newId>`) |

### Rename panel (`#editFormName` overlay)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Form / name (แบบฟอร์ม) | text input (required) | Updates `Formname` (`saveEditFormName`) | — |

### Config / recipients panel (`#configFrom` overlay — "Manage Form")
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Contact name / email (ชื่อผู้ติดต่อ) | email input (required) | Adds an email to this form's notification recipient list (`addFormConfig`) | `type="email"`, validated; "Save" disabled while empty. Each add/remove immediately persists via `SetFormConfig` |
| Contact email list (รายการ อีเมลล์ผู้ติดต่อ) | table | Lists recipient emails; each row has Delete (ลบทิ้ง) (`removeConfig`) | These are the addresses that receive each form submission |

### History panel (`#viewhistory` overlay — submissions)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Start / End date (date pickers) | date inputs | Date range for filtering submissions | Used by Search / Print all / Export-Excel |
| Search (ค้นหา) | button | Client-side filters loaded history by date range (`filterCustomForm`) | — |
| Reset (รีเซ็ต) | button | Restores the unfiltered history (`resetHistory`) | — |
| Print all (พิมพ์ทั้งหมด) | button | Server-builds and prints all submissions in range (`printFormFilterByDate` → `printCustomFormByDateRange`) | — |
| Export-Excel | button | Downloads `.xlsx` of submissions in range (`exportFilterByDate` → `ExportCustomFormByRangeDate`) | Filename `exportCustomform<Formname>.xlsx` |
| Usage date (วันที่ใช้งาน) | table column | Submission timestamp | Server-side paged via `<pageginbackend>` |
| View / Print (เรียกดู / พิมพ์) | buttons (per row) | View one submission's saved HTML, or print it | — |
| Owner Name | text input (per row) | Optional "owner/salesman" tag saved to a submission (`saveCustomOwnerToHistory`) | Column hidden by default (`custom_forsaleman_itp` is `display:none`) — a per-tenant/custom feature; field locks once a name is saved |

### Conversion Tracking panel (`#conversionCustomFormItp` overlay)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Enable (เปิดใช้งาน) | checkbox | Toggles `bConversionScript` for the form | — |
| Conversion tracking script (javascript) | textarea (CodeMirror) | Custom JS fired on submit (`saveConversion`) | Saving also auto-creates the `ItopplusCustomFormThankyou` master page if missing |

### Form builder (`#!/generateForm/<id>`, `generateForm.cshtml` + `GenerateFormCtrl`)
Left rail = draggable items. Each is dropped into a layout column on the canvas, then double-clicked/configured via its own popup. `formid` is the element type id.

| Element (EN / TH) | `formid` / type | Notes |
|---|---|---|
| 1 / 2 / 3 column format (รูปแบบ N คอลัมน์) | layoutid 1/2/3 | LAYOUT row — drop a layout first, then drop fields into it |
| Header | 0 | Rich-text heading (Kendo editor) |
| Paragraph | 1 | Rich-text paragraph |
| Shot Input 1 / Short Input 2 | 2 / 15 | Single-line text input |
| Long Input | 3 | Textarea |
| Dropdown | 4 | Select box |
| Multiple Choice 1 / 2 | 6 / 14 | Checkbox group |
| Single Choice 1 / 2 | 5 / 13 | Radio group |
| Confirmation text box (กรอบข้อความยืนยัน) | 12 | Confirmation input |
| Date Picker | 10 | Date input |
| Address | 11 | Address block (province/district/etc.) |
| File Upload | 7 | File upload control |

**Builder toolbar / per-element config popups:**
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Padding | button | Opens Control spacing slider (`#heightManage`, `configheight`) | Persisted as `height` (px) on the form |
| Theme | button | Opens background-color swatch picker (`#selecttheme`, `selectthemeFunction`) | none/white/lightgray/yellow/lightblue/black |
| Submit button settings (ตั้งค่าปุ่ม Submit) | link → `#btnManage` | Pick button style (7 Bootstrap variants) + Button Text | — |
| Save | button | Serializes layout + all fields and POSTs to `FormManager/SetForm`, then returns to the list | Note: after switching layout the UI warns "save every time" before continuing |
| Cancel (back) | button | Returns to `#!/FormManagement` without saving | — |
| **Textbox popup** (`#textboxManage`): Icon after text, Data type (Text/Number/Email/Phone — ตัวหนังสือ/ตัวเลข/อีเมล/เบอร์โทรศัพท์), Placeholder text, Required (บังคับใส่ข้อมูล), Use this as the email subject (ใช้ข้อมูลนี้เป็นชื่อหัวข้ออีเมล), Font color | radios / text / checkboxes / color | Configures a Short Input | `subjectEmail` makes this field's value the notification email's subject line |
| **Textarea popup** (`#textareaManage`): Icon, Placeholder, Required, Use as email subject, Font color, Height slider | mixed | Configures a Long Input | — |
| **SelectBox popup** (`#selectboxManage`): Items (one per line — 1 บรรทัดต่อ Item), Required, Use as email subject | textarea / checkboxes | Configures a Dropdown's options | — |
| **Radio popup** (`#radioManage` / `radioManage2`): Display Width, Item Default (Yes/No), Required | slider / radios / checkbox | Configures a Single Choice group | — |
| **Checkbox popup** (`#checkboxManage` / `checkboxManage1`): Display Width, Required | slider / checkbox | Configures a Multiple Choice group | — |
| **Upload popup** (`#uploadManage`): Required | checkbox | Configures the File Upload field | Width slider is commented out / disabled |

## Common tasks

### Create a new form
1. Go to `?manage=true#!/FormManagement`.
2. Click **Create new form** (สร้างฟอร์มใหม่).
3. Enter a **Form name** and click **Save** — you land in the drag-and-drop builder.
4. Drag a **column layout** (1/2/3) onto the "Layout drop area" first.
5. Drag **Form Elements** (Short Input, Dropdown, File Upload, etc.) into the layout columns.
6. Double-click each field to set its popup options (Required, data type, placeholder, options, email-subject).
7. Optionally set **Padding**, **Theme**, and **Submit button** style/text.
8. Click **Save** (confirm the dialog). You return to the form list.

### Add / configure fields on an existing form
1. From the form list, click **Edit form** (แก้ไขฟอร์ม) on the row → builder opens at `#!/generateForm/<id>`.
2. Drag new elements in, or click an existing field to open its config popup.
3. Tick **Required** (บังคับใส่ข้อมูล) in the field's popup to make it mandatory.
4. **Save**.

### Choose where submissions are emailed
1. From the form list, click **Config** on the row.
2. Type a recipient address in **Contact name / email**, click **Save** (adds + persists immediately).
3. Remove unwanted addresses with **Delete**. These are the notification recipients for every submission of this form. New forms are pre-seeded with the site-owner email.
- To control the email **subject**, open a text/textarea/select field's popup in the builder and tick **Use this as the email subject** (ใช้ข้อมูลนี้เป็นชื่อหัวข้ออีเมล).

### View / export submissions
1. From the form list, click **History** on the row.
2. Pick a date range and click **Search**, or **View**/**Print** an individual submission.
3. Use **Export-Excel** to download all in-range submissions as `.xlsx`, or **Print all** to print them.

### Rename / delete a form
- **Rename:** click **Rename form**, edit the name, **Save**.
- **Delete:** click **Delete** and confirm.

## Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Management/ViewFormControl.cshtml` (list + overlays); `Boy_Growth_a_Man/Boy_Growth_a_Man/Views/Component/Form/generateForm.cshtml` (drag-and-drop builder). Sidebar: `Views/LayoutManager/_SlideBarHomeNew.cshtml`; top bar: `Views/Shared/_TopMenuBar.cshtml`.
- **Controller / script (admin):** `ScriptRequire/System/Formmanager/Controller.js` (`FormmanagerCtrl`) + `ScriptRequire/System/Formmanager/Service.js` (`FormmanagerService`). Builder: `ScriptRequire/Component/Form/Backend/index.js` (`GenerateFormCtrl`, with `Main/`, `DragInput/`, `DrawOnLoad/` submodules) + `ScriptRequire/Component/Form/Service.js` (`GenerateFormService`). Form-element render-by-type logic: `ScriptRequire/Component/Form/FrontEnd/DrawFormLayoutType/Type<N>.js`. Shared helpers: `ScriptRequire/domains/customform/form.domain.js` (imported as `domains/form/form.domain` — `createElementForPrint`, `convertDate`). Route table: `ScriptRequire/MainSystem/Routing/Server.js` (`/FormManagement`, `/generateForm/?:formid?`).
- **C# controller:** `Boy_Growth_a_Man/Boy_Growth_a_Man/Controllers/FormManagerController.cs` → `formRepo` (Repository → PoolNode LocalService).
- **Save endpoints (AJAX, relative URLs):**
  - `FormManager/AddForm` — create form
  - `FormManager/SetForm` — save the built form (layout + fields), called by the builder's Save
  - `FormManager/GetAllForm`, `FormManager/GetFormByID`, `FormManager/CopyFormByID`
  - `FormManager/EditFormName`, `FormManager/DelForm`
  - `FormManager/SetFormConfig` — save recipient emails + conversion script
  - `FormManager/GetFormHistoryByID`, `FormManager/countHistoryPage`, `FormManager/addFormHistoryOwner`
  - `FormManager/ExportCustomFormByRangeDate`, `FormManager/printCustomFormByDateRange`, `FormManager/printFormOneByOne`
  - Public submission side (placed form on a page) uses the separate `ManageForm/*` endpoints: `ManageForm/formSubmit`, `ManageForm/formSubmitByLayout`, `ManageForm/getFormByCmpID`, `ManageForm/setFormByCmpID`, `ManageForm/AddFormByCompID`, `ManageForm/createPreviewByLaout`.

## Gotchas / multi-tenant notes
- The route name `FormManagement` must be in the `RouteConfig.cs` controller whitelist for the page to load, and any new `FormManager`/`ManageForm` controller endpoints must be registered there too (see repo `RouteConfig` rule) — otherwise the AJAX returns the SPA shell HTML instead of JSON.
- `FormManagerController` endpoints take a single parameter named `form` of type `form` (and `formDisplay` for `ManageForm`). Per the param-name-collision rule, keep the posted JSON wrapper key (`{ form: ... }`) matching the action's parameter name.
- The sidebar entry is hidden when `bFormOptimize` is true (an optimization/"advanced" mode), and the "Table Form" / "Manage Comment" shortcuts are hidden when `Config.Optimization.bAdvanceOptimize` is true. These are config flags, not domain whitelists — no hardcoded-domain logic was found in the scoped files. Good.
- The History "Owner Name" column is intentionally `display:none` (`custom_forsaleman_itp`) — a custom/per-tenant salesman-tagging feature surfaced only by custom CSS. Don't assume it's broken because it's invisible.
- Field types are numeric (`type` 0–15). The builder's Save (`GenerateFormCtrl.save`) hand-serializes each type's inner HTML; types share ids between two "flavours" (e.g. Short Input = 2 or 15, Single Choice = 5 or 13, Multiple Choice = 6 or 14) so changing the markup template for one variant won't affect the other.
- New forms auto-seed recipients from the site-owner email (`ManageAccountService.GetsiteOwner`), so a form created with no Config edits still emails the owner.
- `ViewFormControl.cshtml` / `generateForm.cshtml` are admin views (`?manage=true`); per project rules the UTF-8 BOM requirement applies to any full rewrite.
