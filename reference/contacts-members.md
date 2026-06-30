# Contact Manager (จัดการบัญชีผู้ใช้) & Member Manager (จัดการข้อมูลสมาชิก)

> Two separate sidebar items that look related but are unrelated systems.
> - **Contact Manager** (`manageUserAccounts`) edits the **site-owner's own backend account / contact profile** (the website's own name, email, phone, address, social-media links). Despite the EN label "Contact Manager", the underlying route, view and data are a single "site owner" record — not a list of contacts.
> - **Member Manager** (`manageMemberInformation`) is the CRUD list of **site members / customers** (people who registered, subscribed to news, were added manually, etc.).
>
> Each is documented separately below.

---

# Contact Manager (จัดการบัญชีผู้ใช้)

## What it does
Edits the single **site-owner account** for this domain: full name, contact email/phone/address, account password, and the website's social-media handles (Facebook, LINE, Instagram, WeChat, YouTube, X/Twitter, Google My Business, LINE MyShop) plus up to 4 "Custom Link" icons. The English sidebar label is "Contact Manager"; the screen heading is "Edit profile".

## How to get there
- **Sidebar:** Website Settings sidebar > **Contact Manager** (จัดการบัญชีผู้ใช้) — `.setting-account` item with `webpage_10.png` icon.
- **Route:** `https://demo110.itopplus.com/?manage=true#!/ManageAccount/`
  - The route renders `Views/MainManageAccount/index.cshtml`, which `ng-include`s `MainManageAccount/ManageAccount`. Controller: `ManageAccountController`.
  - Note the trailing slash — the registered route is `.when('/ManageAccount/', …)`.

## Fields on the screen
The page has a tabbed menu (`type` 1–5); only **type 1 ("Edit profile" / แก้ไขข้อมูลส่วนตัว)** is active. Type 2 (Google), 3 (Facebook), 4 (Twitter) and 5 (SMS) blocks exist in markup but are `hidden`/commented out. Type 1 is split into section **1 "Edit profile (change password)"** and section **2 "Social Media"**.

### Section 1 — Edit profile (แก้ไขข้อมูลส่วนตัว)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Full name (ชื่อ-นามสกุล) | text (required) | `GetsiteOwner.Name` — site owner display name | Sent URL-encoded (`encodeURIComponent`) on save. Form is `required`; empty blocks save with a warning toast. |
| Email (อีเมล) | text (required) | `GetsiteOwner.Email` — contact email | Helper note: "If multiple Emails, separate with a comma `,`". |
| Phone (เบอร์โทรศัพท์) | text | `GetsiteOwner.Telephone` | `ng-change` strips everything except `+` and digits. A leading `+` is escaped to `<!plus!>` before saving (un-escaped server-side). |
| Address (ที่อยู่) | textarea (3 rows) | `GetsiteOwner.Address` | — |
| Username | text (readonly) | `GetsiteOwner.Username` — login username | Only shown in the password sub-form (`update == 'password'`), which is reached via a button block that is currently commented out. Read-only. |
| Old password (รหัสผ่านเก่า) | password | `Oldpass` | Password sub-form only. |
| New password (รหัสผ่านใหม่) | password | `Newpass` | Must equal "Confirm new password" or save is rejected with an error toast. |
| Confirm new password (รหัสผ่านใหม่อีกครั้ง) | password | `ReNewpass` | Compared to `Newpass` client-side. |

### Section 2 — Social Media
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Facebook (Fan Page) | text | `GetsiteOwner.Facebookfanpage` | — |
| LINE, (LINE@) | text | `GetsiteOwner.LINEat` | Any `%40` in the value is replaced with `<!nfix!>` before saving (escapes the `@`). |
| Instagram username | text | `GetsiteOwner.InstragramContact` | "username only" — do not paste a full URL. |
| WeChat ID | text | `GetsiteOwner.WeChatContact` | — |
| Youtube Channel | text | `GetsiteOwner.YoutubeChannel` | — |
| Line My Shop | text | `GetsiteOwner.LineMyShopChannel` | "no need to include @". |
| Google My Business | text | `GetsiteOwner.GoogleMyBusinessChannel` | — |
| X/Twitter Account | text | `GetsiteOwner.TwitterAccount` | — |
| Custom Link / Custom Link2 / Custom Link3 / Custom Link4 (Enable / เปิดใช้) | checkbox + image upload + text | Each = `GetsiteOwner.CustomIconLinkN` object with `.flagShowCustomIcon` (toggle), `.CustomIconImage` (uploaded icon), `.CustomIconUrl` (link). | Checkbox reveals an icon uploader + URL input. Icon uploads POST to `FilesRender/UploadFileServer/` (separate from the main save). Supports `.png .jpg .jpeg .gif` only. |

A single **Save settings** (บันทึกการตั้งค่า) button at the bottom persists sections 1 + 2 together via `UpdateAccount()`.

## Common tasks
### Edit the site contact info / social links
1. Open `#!/ManageAccount/`.
2. Edit Full name / Email / Phone / Address in section 1, and any social handles in section 2.
3. Click **Save settings** (บันทึกการตั้งค่า). A success toast "Edit personal info / เรียบร้อยแล้ว" confirms.

### Add a custom social icon link
1. Tick **Enable** (เปิดใช้) under Custom Link (1–4).
2. Choose an image file (`.png/.jpg/.jpeg/.gif`) — it uploads immediately and shows a thumbnail.
3. Fill the **Custom url** field, then click **Save settings**.

### Change the account password
1. The password sub-form (`update == 'password'`) is reached only when its switch button block (currently commented out in markup) is enabled. When visible: enter Old / New / Confirm password and click **Save settings**.
2. Server checks the old password; wrong old password or non-matching new passwords are rejected with an error toast.

## Wired in (for developers)
- **View(s):** `Views/MainManageAccount/Index.cshtml` (route target, ng-includes the next), `Views/MainManageAccount/ManageAccount.cshtml` (the form), `Views/MainManageAccount/smsPackage.cshtml` (legacy SMS-credit modal, disabled), `Views/MainBackend/ManageAccountInfo.cshtml` (first-login "Account Information" modal that prompts for Email + Mobile — separate from this page).
- **Controller / script:** `ScriptRequire/System/ManageAccount/Controller.js` (`ManageAccountController`), `ScriptRequire/System/ManageAccount/Service.js` (`ManageAccountService`), `ScriptRequire/System/ManageAccount/index.js`. C# controller: `Controllers/MainManageAccountController.cs`.
- **Save endpoint:** `MainManageAccount/UpdatesiteOwner` (profile + social, returns `'END'`); `MainManageAccount/UpdatePassWord` (password); load via `MainManageAccount/Getsiteowner`. Custom-icon image upload: `FilesRender/UploadFileServer/`.

## Gotchas / multi-tenant notes
- Save handlers escape special characters before POST: `+` → `<!plus!>` in Telephone/Mobile, `%40` → `<!nfix!>` in LINEat. Don't double-encode.
- `DomainName.indexOf('itopplus') != -1` sets `$scope.check = 1` (vs 0). This in-code domain-name check gates the (commented-out) password-edit button visibility — a hardcoded-domain branch in shared code; flag if you touch it.
- SMS / Google / Facebook / Twitter connection tabs and the Paysbuy SMS-credit purchase flow (`AuthenPaysbuy` → paysbuy.com) are legacy and disabled (commented out / `hidden`). Don't document them as live.
- This is a single site-owner record per domain, not a multi-contact address book.

---

# Member Manager (จัดการข้อมูลสมาชิก)

## What it does
Lists, searches, adds, edits, deletes and exports **site members / customers** for the domain — people who subscribed to news, registered, were added from the admin, came from the webboard or the contact-us form. Supports per-member registration approval, member level (Regular / VIP), and (if the courses module is on) per-member course management.

## How to get there
- **Sidebar:** Website Settings sidebar > **Member Manager** (จัดการข้อมูลสมาชิก) — `.setting-member` item with `webpage_11.png` icon.
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Member`
  - Renders `Views/Management/ViewMember.cshtml`. The route's controller line is commented out; the view declares `ng-controller="MemberController"` itself (defined at `ScriptRequire/Component/Member/Controller.js`).

## Fields on the screen
The screen has two views toggled by `managerView`: the **list/search view** and the **Add/Edit member form**.

### List view (toolbar + table)
| Control (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Member List (ข้อมูลสมาชิก) | button | Shows the list view | — |
| Add Member (เพิ่มสมาชิก) | button | Opens the blank Add form | — |
| Export Member | button/link | Downloads `Member_List_<MM-DD-YYYY>.xlsx` of all members | Pulls up to 100000 rows (`pagesize: 100000`). |
| Search (ค้นหา) | text + buttons | Free-text member search; **Clear** (เคลียร์ค่าการค้นหา) resets | Empty search is ignored. Enter key triggers search. |
| Filter by Status (แสดงข้อมูลตามสถานะ) | dropdown | Searches by a fixed status string | Options are hardcoded **Thai** strings: ติดตามข่าวสาร (Subscribe), เพิ่มจากระบบจัดการ (System member), ระบบสมัครสมาชิก (Registerform), ระบบเว็บบอร์ด (Webboardform), ระบบติดต่อเรา (ContactUsform). |
| Require Registration Approval (ตั้งค่ายืนยันการสมัครสมาชิก) | toggle/checkbox | Saves domain `bAllowRegister` config; when on, an **Approve** button appears per row | Toggling writes the whole Config via `Localconfig/saveConfig`. |

Table columns: Member ID (รหัสสมาชิก, inline-editable `MemberCode`, saved on blur), Name (ชื่อ), Email, Phone (เบอร์โทร), Date/Time (วันเวลา, `DateTimeText`), Status (สถานะ, `MemberStatus`), Actions, and — only when `Config.bMemberCoursesSystem` is true — a Course (คอร์ส) column with a **Manage Courses** (จัดการคอร์ส) button.

Per-row action buttons: **Approve** (ยืนยันการสมัคร, only if approval mode on & not yet allowed), **Edit** (แก้ไข), **Delete** (ลบ).

### Add / Edit form (panels)
**Company Info (ข้อมูลบริษัท):**
| Field (EN / TH) | Type | Effect |
|---|---|---|
| Company Name (ชื่อบริษัท) | text | `MemberEdit.MemberCompanyName` |
| Branch Number (เลขที่สาขา) | text | `MemberEdit.MemberBranchNumber` |
| Tax ID (เลขประจำตัวผู้เสียภาษี) | text | `MemberEdit.MemberTaxID` |

**General Info (ข้อมูลทั่วไป):**
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Full Name (ชื่อ นามสกุล) | text | `MemberEdit.MemberName` | — |
| National ID (รหัสบัตรประชาชน) | text (markup `type="email"`) | `MemberEdit.MemberIDCard` | Input type is `email` in markup despite being an ID number. |
| Phone (เบอร์โทร) | text (maxlength 10) | `MemberEdit.MemberTelephone` | — |
| Date of Birth (วันเกิด, DD/MM/YYYY) | date (jQuery datepicker) | `MemberEdit.MemberBorn` | Sent to server formatted `MM-DD-YYYY` via moment. |
| Line ID | text | `MemberEdit.MemberLineID` | — |
| Address block | composite (`address-ui` directive) | `MemberAddress`, `MemberDistrict`, `MemberAmphure`, `MemberProvince`, `MemberPostoffice`, `Membercountry` | Thai address auto-cascade (province → amphur → district → zip) only when country = Thailand; needs ShopcartService present. |
| Member photo | file upload (multiple) | `MemberEdit.MemberFilePath` | JPG/PNG/GIF only. Uploads to `/MemberCtrl/UploadMember`; placeholder `404.jpg` = no image. |

**Login Info (ข้อมูลเข้าสู่ระบบ):**
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Email (อีเมล) | email | `MemberEdit.MemberEmail` | Login identifier. |
| Password (รหัสผ่าน) | password (toggle visibility) | `MemberEdit.MemberNewPassWord` | — |
| Confirm Password (ยืนยันรหัสผ่าน) | password (toggle visibility) | `MemberEdit.MemberConfirmPassWord` | Must equal Password or Add/Save is blocked with a warning toast. |
| Show Password (แสดงรหัสผ่าน) | checkbox | toggles input type text/password | — |

**Member Level:**
| Field (EN / TH) | Type | Effect |
|---|---|---|
| Member Level (ระดับของสมาชิก) | dropdown/select | `MemberEdit.MemberLevel` — `A` = Regular Member (สมาชิกทั่วไป), `B` = VIP Member (สมาชิกVIP) |

Footer buttons: **Add** (เพิ่มข้อมูล, new) or **Save** (แก้ไขข้อมูล, edit), and **Back** (ย้อนกลับ).

## Common tasks
### Find a member
1. Open `#!/Member`.
2. Type in **Search** and press Enter or click Search, OR use **Filter by Status** to list by status. **Clear** resets to all.

### Add a member manually
1. Click **Add Member** (เพิ่มสมาชิก).
2. Fill Company/General/Login info; set Member Level; upload a photo if wanted.
3. Ensure Password = Confirm Password, then click **Add** (เพิ่มข้อมูล). A registration mail is sent (`sendMailregister`).

### Edit / delete a member
1. In the list, click **Edit** (แก้ไข) on the row → form opens prefilled → adjust → **Save** (แก้ไขข้อมูล).
2. Or click **Delete** (ลบ) and confirm the SweetAlert dialog.
3. The Member ID (`MemberCode`) cell is editable inline and saves automatically on blur.

### Approve a pending registration
1. Turn on **Require Registration Approval** (ตั้งค่ายืนยันการสมัครสมาชิก).
2. Click **Approve** (ยืนยันการสมัคร) on the member's row and confirm. Sets `MemberAllow`/`bVerify` and sends a verification email.

### Export members to Excel
1. Click **Export Member** → downloads `Member_List_<date>.xlsx`.

### Manage a member's courses (only if courses module enabled)
1. With `Config.bMemberCoursesSystem` on, click **Manage Courses** (จัดการคอร์ส) on the row → opens the `MemberCoursesConfig.cshtml` modal showing the member's purchased courses + expiry dates.

## Wired in (for developers)
- **View(s):** `Views/Management/ViewMember.cshtml` (the page). `Views/Management/Member/VerifyEmail.cshtml` is the **public** post-confirmation page shown to a member after email verification — not part of this admin screen. Modals: `Views/Component/MemberCtrl/MemberCoursesConfig.cshtml`.
- **Controller / script:** `ScriptRequire/Component/Member/Controller.js` (`MemberController` — admin list/CRUD lives in the `system member` region from ~line 358), `ScriptRequire/Component/Member/Service.js` (`MemberService`). C# controller: `Controllers/Control/MemberCtrlController.cs`.
- **Save endpoint(s):** all under `MemberCtrl/` —
  - List: `MemberCtrl/GetAllMember`, count `MemberCtrl/GetCountMember`
  - Search: `MemberCtrl/searchMember`, count `MemberCtrl/GetCountSearchMember` (`searchMemberSocial` for social)
  - Add: `MemberCtrl/AddMemberAdmin` (returns `true`/`false`)
  - Edit / inline code / approve: `MemberCtrl/EditMember` (returns `'END'`)
  - Delete: `MemberCtrl/DeleteMember`
  - Export: `MemberCtrl/ExportAllMember` (arraybuffer → .xlsx)
  - Photo upload: `MemberCtrl/UploadMember`; groups: `MemberCtrl/getGroup`
  - Approval toggle saves Config via `Localconfig/saveConfig` (`ConfigService.saveConfig`).

## Gotchas / multi-tenant notes
- The **Filter by Status** dropdown options are hardcoded Thai strings (ติดตามข่าวสาร, เพิ่มจากระบบจัดการ, ระบบสมัครสมาชิก, ระบบเว็บบอร์ด, ระบบติดต่อเรา) used directly as the search text, even when the admin UI is in English. `changeLangMemberStatus()` maps them to EN labels elsewhere but the dropdown itself is not localized.
- The Course column / Manage Courses button is feature-gated by `Config.bMemberCoursesSystem` (Razor `@if`). The MemberCourses controller must also be registered in `RouteConfig.cs` (see repo CLAUDE.md) to work.
- The **Require Registration Approval** toggle reads `bAllowRegister` (global) and writes the entire Config object — it is a domain config flag, applied per-domain.
- `MemberController` is shared between the public-facing member login/register component and this admin screen; the admin CRUD only runs after `memberinit()` (called from `ViewMember.cshtml` ng-init). Editing the controller can affect both surfaces.
- National ID field uses markup `type="email"` (likely a copy-paste artifact) — not a validation rule you can rely on.
