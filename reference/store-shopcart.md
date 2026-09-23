# Store / Shopcart admin configuration (จัดการร้านค้า)

## What it does
The e-commerce store admin ("Manage Shop") is where a tenant configures everything about its online shop: shop identity/address, general behaviour (currency, tax, checkout, members, stock), payment accounts, shipping providers, notification messages, and coupons — plus the product catalog (products, categories, brands, tags, filters, attributes) and order management. It is a large area split across a settings hub (six setting screens sharing one top tab bar) and a product/order back end.

## How to get there
- **Sidebar:** Website Settings menu > **Manage Shop (จัดการร้านค้า)** — links to `?manage=true#!/Shopcart` (defined in `Views/Shared/BackEnd/_MainMenu.cshtml`).
- **Route (shop dashboard / hub):** `https://demo110.itopplus.com/?manage=true#!/Shopcart`
  - The dashboard (`ShopBackEnd/Home.cshtml`, controller `ShopcartHomeCTRL`) shows order statistics + sales summary, and tiles linking to **Shop settings** (`#!/Shopcart/DetailShop`), **Product categories** (`#!/Shopcart/Collection`), **Manage products** (`#!/Shopcart/Product`), **Export products** (`#!/Shopcart/ExportProductList`), and **All orders** (`#!/Shopcart/Order`).

### Six settings screens (shared top tab bar, partial `ShareShop/MenuShopcart.cshtml`)
The tab bar `$rootScope.shopSettingMenuList` (defined in `ScriptRequire/Store/System/Shopcart/Setting/Service/menu/loadmenu.js`) renders these six tabs across every settings screen:

| Tab (EN / TH) | Route |
|---|---|
| Shop Detail / About Store (ข้อมูลร้านค้า) | `#!/Shopcart/DetailShop` |
| General Settings (ตั้งค่าทั่วไป) | `#!/Shopcart/GeneralSetting` |
| Finance / Payment (การเงิน) | `#!/Shopcart/PaymentSetting` |
| Supplying / Shipping (การจัดส่ง) | `#!/Shopcart/Shipping` |
| Notifications / Alert (การแจ้งเตือน) | `#!/Shopcart/AlertShop` |
| Coupon | `#!/Shopcart/couponSetting` |

### Catalog / order routes (reached from the dashboard tiles or directly)
| Screen (EN / TH) | Route |
|---|---|
| Product categories & brands (หมวดหมู่และแบรนด์) | `#!/Shopcart/Collection` |
| Add category / brand / tag / filter1-8 | `#!/Shopcart/Collection/AddCategory/`, `/AddBrand/`, `/AddTag/`, `/AddFilter1` … `/AddFilter8` |
| Manage products (จัดการสินค้า) | `#!/Shopcart/Product` |
| Add / edit product (V2) | `#!/Shopcart/Product/AddProductsV2/:param1` (legacy `AddProducts/`) |
| Attribute management | `#!/Shopcart/Attribute` |
| Export product list | `#!/Shopcart/ExportProductList` |
| Orders (คำสั่งซื้อ) | `#!/Shopcart/Order` (controller `OrderCTRL`); newer flow `#!/Shopcart/PreOrder` |
| New Promotion (โปรโมชั่น) | `#!/Shopcart/newpromotion` (controller `NewPromotionCTRL`) |
| Print receipt / label | `#!/Shopcart/printReceipt/:id`, `#!/Shopcart/label/:id` |

All of the above are AngularJS hash routes registered in `ScriptRequire/MainSystem/Routing/Server.js`; each loads a Razor partial under `Views/Shopcart/` via `FilesRender/RenderPartial`.

## Fields on the screen
This area is large; the table summarises the main config groups per screen rather than every field. The six settings screens all share a top-right **language selector** (`DefaultLang`, switches the language whose values you are editing) and the shop tab bar.

### Shop Detail — `#!/Shopcart/DetailShop` (controller `FirstStepCTRL`)
| Field group (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Shop logo (โลโก้ร้านค้า) | File/image upload | Store logo (`Setting.LogoShop`); uploads via `FilesRender/UploadFileServer` | Falls back to a "no picture" placeholder |
| Business name (ชื่อร้านค้า/ธุรกิจ) | Text input | `Setting.OwnerShopName` | Label from `websiteSettingByLangauge.businessName` |
| Company registration number (เลขทะเบียนบริษัท) | Text input | `Setting.commercialRegister` | |
| Tax ID (เลขประจำตัวผู้เสียภาษี) | Text input | `Setting.TaxID` | |
| Social links: Facebook, X/Twitter, Google+, Instagram, Youtube, LineID, Whatsapp | Text inputs | Stored in `SocialNetWork` | |
| Shop address: Building/Village (อาคาร/หมู่บ้าน), House no (บ้านเลขที่), Moo (หมู่), Lane (ซอย), Road (ถนน), Subdistrict (แขวง/ตำบล), District (เขต/อำเภอ), Province (จังหวัด), Postal code (รหัสไปรษณีย์), Phone (เบอร์โทร) | Text inputs | Stored in `ShopAddress` | |
| All languages (รองรับทุกภาษา) | Toggle/checkbox | Per-language shop detail (`shopOwnerConfigs` keyed by `languageID`) | Only shown under "advance setting"; controlled by `bLangSupport` |

Save: **Save (บันทึก)** button `ng-click="AddShopDetailData()"` (also Ctrl+S). NOTE: this is the **global** shop detail (the `1FirstStepSetting` controller), not a per-page config — there is no per-page DetailShop variant in this route set; the same screen edits per-language copies when "All languages" is on.

### General Settings — `#!/Shopcart/GeneralSetting` (controller `SecondCTRL`)
Grouped into sections (each a `tab-title`):
| Section (EN / TH) | Representative fields / types |
|---|---|
| Shop Email (อีเมลร้านค้า) | Admin email (`mailadmin`, text), CS email prefix (`mailtoCS`, text + domain suffix) |
| Finance (การเงิน) | Currency dropdown (`currency`: THB/USD or custom `NewCurrency`), **Add currency** button (modal); VAT radio (`vat`); Conversion-mode radio (`currenmode`) + exchange-rate table (repeater: currency name + rate + delete); Show 2 decimals radio (`decimal2pos`) |
| Checkout Setting (ตั้งค่าการชำระเงิน) | Payment-slip required (`StatuspaymentSlip`), Paid-time required (`StatuspaymentSlipPaidTime`), Show other countries (`bCountryOpen`), autocomplete (`autocomplete`), shop-email required (`bShopEmail`), disable skipping payment step (`skipPayment`), disable last-name requirement (`surnameRequire`, hidden), order-complete popup (`popupFinish`), show bank account on payment form (`showBankAccount`), show shop/receipt address (hidden), checkout template select (`checkOutTemplate`, hidden), payment reminder before confirm (`alertPopupBeforeCheckout`) — all radio On/Off pairs |
| Product and Member (สินค้าและสมาชิก) | Member system on/off (`bMember`), Skip login (`skiplogin`), Member registration (`member`), Registration promotion text (`bRegisterPromotion`), Member price (`bMemberPrice`); Coupon system (`openCoupon`, shown when `hideCoupon==2`); Promotion system (`bPromotion`, shown when `hidePromotion==2`) with a tiered-promotion table (purchase threshold, type Discount/Free, %/THB discount); cart button name (`btnCartName`), discount description (`discountWording`), Custom Button (`bCartDefault`) + button icon upload; image Zoom (`bZoom`) + zoom type (`zoomType`) |
| Stock (คลังสินค้า) | Ordering mode radio (`stocktype` 1/2/3); when not "1": out-of-stock display (`status`) with custom text (`statustext`) |
| Rating Product | On/Off radio (`Rating`) |
| Product Status (สถานะสินค้า) | `bStatusProduct` (on/off/per-product), status select, status-tag position select (4 corners), status-tag image upload; New Attribute Mode (`bNewModeAttribute`) |

Save: `AddSettingShop` (the page's own save handler). This screen also drives the **Apply** overlay (`$rootScope.applyReady`).

### Finance / Payment — `#!/Shopcart/PaymentSetting` (controller `ThirdCTRL`)
| Group (EN / TH) | Type | Fields |
|---|---|---|
| Bank account (บัญชีธนาคาร) | Form (panel) | Bank dropdown (`Bankname`), account number / PromptPay phone-or-ID, account name, branch, account type dropdown |
| Other payment (อื่นๆ) | Text input | Free-text payment method (`PaymentDetail`) |
| Online Payment (บัญชีออนไลน์) | Toggleable gateway cards | **PayPal** (email/ID/secret/signature, fee form+amount, sandbox toggle); **Pay Social / pay.sn** (MerchantID, fee, return/postback URL); **Omise** (public/secret key, fee, optional minimum); **2C2P** (merchant ID, secret key, fee, postback/return URL) |
| My Finance Setting | Table/list | Saved payment methods with Edit/Delete |

Save per card: `AddPaymentSetting()`. Gateways only render when enabled for the domain (`Paypal`, `PaySocial`, `Omise`, `twoCtwoP` flags).

### Shipping — `#!/Shopcart/Shipping` (controller `FourStepCTRL`)
| Element (EN / TH) | Type | Effect |
|---|---|---|
| Add shipping provider (เพิ่มผู้จัดส่ง) | Button → form (`ShippingForm.cshtml`) | Create a carrier |
| Price rate by weight (เรทราคาคำนวนตามน้ำหนัก) | Button → modal (`Shippinglate.cshtml`) | Weight-tier rate table |
| Search (ค้นหา) | Text input | Filter provider list |
| Provider list | Table | Status toggle, Name, Logo, Shipping time, and **Shipping condition** (`CagShipping`) — a large enum of fee models: free, fixed-per-shipment, per-piece, by total weight, by discounted price, by category, by country/province/postal code, and combinations; Edit/Delete |

Save: `AddShopShipping` (carrier), shipping-rate save handlers.

### Notifications / Alert — `#!/Shopcart/AlertShop` (controller `SecondCTRL`)
| Field (EN / TH) | Type | Effect |
|---|---|---|
| Send SMS to customer (ส่งSMSถึงลูกค้า) | Radio Enable/Disable (`SmsCus`) | Only if siteowner `smsUsing=='true'` |
| Order notification message (`Alert1`) | Textarea (`Orders`) | Email text sent when order placed |
| Order-received message (`Alert2`) | Textarea (`reciveOrder`) | Email text on order received |
| SMS content on order (`smsOrder`) | Textarea (max 70) | SMS body; only if SMS enabled |
| Line Notify Token (`lineToken`) | Text input | Line notification (section currently `display:none`) |

Save: **Save (บันทึก)** `ng-click="beforeAddSetting()"` → `AddSettingShop`.

### Coupon — `#!/Shopcart/couponSetting` (controller `SecondCTRL`)
| Element (EN / TH) | Type | Effect |
|---|---|---|
| Add coupon (เพิ่มคูปอง) | Button → modal (`couponConfig.cshtml`) | Create/edit a coupon |
| Coupon list | Table (repeater `allCoupon`) | Per-coupon: status toggle (`statusCheckopen`), name, expiry (`dateEndText` or "no limit"), used count, limit (or unlimited), Edit/Delete |

Save: `addCoupon` (endpoint `shopcart/addCoupon`).

### Catalog / Collection — `#!/Shopcart/Collection` (`Category.cshtml`)
Manage **categories and brands** (จัดการหมวดหมู่และแบรนด์): product categories, product brands (แบรนด์สินค้า), tags, and up to **8 product filters** (สร้างฟิลเตอร์ / ชื่อฟีลเตอร์). Each opens its own add/edit screen (`AddCategoriesV2`, `AddBrandsV2`, `AddTagsV2`, `AddFilters1V2`…`AddFilters8V2`). Product attributes are managed at `#!/Shopcart/Attribute`.

### Products — `#!/Shopcart/Product` (`Products.cshtml`) and Add/Edit (`AddProductV2.cshtml`)
List/search products with a cookie-backed page size (10/30/50). Add/edit product holds name, price, stock, images (crop), category/brand/tag/filter assignment, attributes, status — managed by `ManageProduct` / `ManageProductNew` controllers. (Per-field product form not enumerated here; it is its own large screen.)

### Orders — `#!/Shopcart/Order` (controller `OrderCTRL`)
Order list with customer name, status (Unpaid/Paid), totals; receipt/label printing via `#!/Shopcart/printReceipt/:id` and `#!/Shopcart/label/:id`.

## Common tasks
### Change the shop's currency or turn on VAT
1. Go to `?manage=true#!/Shopcart/GeneralSetting`.
2. Under **Finance (การเงิน)**, pick the **Currency** dropdown (or **Add currency** for a custom one), set the **VAT** radio.
3. Save (the General Settings save button) and click **Apply** if prompted.

### Add a bank account or online payment gateway
1. Go to `?manage=true#!/Shopcart/PaymentSetting`.
2. Click **Add bank account** (or **Add online account**), fill the form / enable the gateway card and enter its keys.
3. Click **Save (บันทึก)** on that card. The method appears in **My Finance Setting**.

### Add a shipping provider with a fee rule
1. Go to `?manage=true#!/Shopcart/Shipping`.
2. Click **Add shipping provider (เพิ่มผู้จัดส่ง)**, set name/logo/time and choose a **shipping condition** (fixed, by weight, by province, etc.).
3. Save. Use **Price rate by weight** for weight-tier tables.

### Edit shop identity / address
1. Go to `?manage=true#!/Shopcart/DetailShop`.
2. Upload the logo, fill business name / tax ID / address / social links.
3. Save with the bottom save bar or **Ctrl+S**.

### Create a coupon
1. Go to `?manage=true#!/Shopcart/couponSetting`.
2. Click **Add coupon (เพิ่มคูปอง)**, configure code/discount/limit/expiry in the modal, save. Toggle the row's status to enable it.
   (Coupon system must be enabled in General Settings when `hideCoupon==2`.)

## Checkout — ปุ่ม Copy เลขบัญชีธนาคาร (feature/checkout-bank-account-copy-button)

หน้า Checkout (checkoutTemplate1) มีปุ่ม **คัดลอก** ข้างเลขบัญชีธนาคาร เพื่อให้ลูกค้า copy เลขบัญชีได้ง่าย

### พฤติกรรมบนหน้าจอ
| องค์ประกอบ | รายละเอียด |
|---|---|
| เลขบัญชี (label `bank-account-number`) | แสดงพร้อม format XXX-X-XXXXX-X ผ่าน AngularJS filter `bankAccountFormat` |
| ปุ่ม **คัดลอก** (`bank-account-copy-btn`) | `ng-click="copyBankAccount(pay.opt2, $event)"` — ใช้ `navigator.clipboard.writeText()` |
| feedback เมื่อ copy สำเร็จ | label บนปุ่มเปลี่ยนเป็น **"คัดลอกแล้ว!"** + ขอบเขียว; คืนเป็น "คัดลอก" หลัง 1.5 วินาที |

### Wired in (for developers)
- **View:** `Views/Component/Shopcart/cart/checkoutTemplate1.cshtml`
- **Controller function:** `copyBankAccount(accountNumber, $event)` ใน `ScriptRequire/MainSystem/Controller/Global/Controller.js`
- **Filter:** `bankAccountFormat` จัด format เลขบัญชีเป็น XXX-X-XXXXX-X
- **CSS classes:** `.bank-account-copy-btn`, `.bank-account-copy-btn.copied` (สีเขียว)

---

## Wired in (for developers)
- **View(s):** `Boy_Growth_a_Man/Views/Shopcart/GlobalSetting/` — `DetailShop.cshtml`, `GeneralSetting.cshtml`, `PaymentSetting.cshtml` (+ `addPaymentOnline`), `Shipping.cshtml` (+ `ShippingForm.cshtml`, `Shippinglate.cshtml`), `AlertShop.cshtml`, `couponSetting.cshtml` (+ `couponConfig.cshtml`), `AddNewCurrency.cshtml`, `newpromotion.cshtml`. Shared tab bar: `Views/Shopcart/ShareShop/MenuShopcart.cshtml`. Catalog/orders: `Views/Shopcart/ShopBackEnd/` (`Home.cshtml`, `Category.cshtml`, `Products.cshtml`, `AddProductV2.cshtml`, `Order.cshtml`, etc.).
- **Controller / script:** `ScriptRequire/System/Shopcart/Controller.js` + `Service.js` (Pattern A); per-screen controllers `Backend/1FirstStepSetting/Controller.js` (`FirstStepCTRL` — Shop Detail), `Backend/2SecondStep/Controller.js` (`SecondCTRL` — General/Alert/Coupon), `Backend/3ThirdStep/Controller.js` (`ThirdCTRL` — Payment, + `addPaymentOnline.js`), `Backend/4FourStep/Controller.js` (`FourStepCTRL` — Shipping), `Backend/ShopcartHome/` (`ShopcartHomeCTRL`), `Backend/Order/Controller.js` (`OrderCTRL`), `Backend/NewPromotion/Controller.js`. Routes: `ScriptRequire/MainSystem/Routing/Server.js`. Setting-tab menu: `ScriptRequire/Store/System/Shopcart/Setting/Service/menu/loadmenu.js`. Business logic: `ScriptRequire/domains/shopcart/` (currency, coupon, promotion, shipping, cart, attribute, price domains). C# controller: `Controllers/ShopcartController.cs` (and `Controllers/ShopPaymentController.cs`).
- **Save endpoint:** AngularJS Services POST to `shopcart/<Action>` → `ShopcartController`:
  - Shop Detail → `shopcart/AddShopSiteOwner` (`AddShopSiteOwner`)
  - General / Alert → `shopcart/AddSettingShop` (`AddSettingShop`)
  - Shipping → `shopcart/AddShopShipping` (`AddShopShipping`)
  - Coupon → `shopcart/addCoupon`
  - Read config → `shopcart/getShopSetting` (`getShopSetting`)
  - Payment add via `AddPaymentSetting()` in `ThirdCTRL`.
  These do NOT use the WebConfig `Localconfig/saveConfig` pipeline — shop settings have their own `ShopcartController` actions that persist to PoolNode/Mongo.

## Checkout: member company info pre-fill (feature/register-company-info)

When a member **logs in during checkout**, the system now automatically pre-fills the shipping and billing address forms with the member's company data stored in their member profile:

| Auto-filled field | Source (member profile) |
|---|---|
| Company Name (ชื่อบริษัท) | `memberDetail.MemberCompanyName` → `order.company` / `order.company1` |
| Branch Number (เลขที่สาขา) | `memberDetail.MemberBranchNumber` → `order.companyBranch` / `order.companyBranch1` |
| Tax ID (เลขประจำตัวผู้เสียภาษี) | `memberDetail.MemberTaxID` → `order.TaxID` / `order.TaxID1` |

The branch number is also displayed after the company name in all checkout preview boxes and order summary. Member company data is set via **Member Manager** (`?manage=true#!/Member` > Edit member > Company Info panel).

## Gotchas / multi-tenant notes
- **Per-domain feature gates are config-driven, not hardcoded whitelists (good).** Online payment gateway cards (`Paypal`, `PaySocial`, `Omise`, `twoCtwoP`), the SMS notification row (siteowner `smsUsing`), and the Coupon/Promotion rows (`hideCoupon`/`hidePromotion`) all render based on per-domain settings — they are per-tenant flags, not in-code domain lists. No hardcoded `DomainID` whitelist was observed in these views.
- **Language scoping:** every settings screen has its own `DefaultLang` selector; values like shop detail and notification text are stored per language. When "All languages" is on, Shop Detail writes a `shopOwnerConfigs[]` entry keyed by `languageID`. Always test the language you intend to edit.
- **Apply overlay:** `GeneralSetting` and `DetailShop` save handlers set `$rootScope.applyReady = false`, so their save bars use the `--with-apply` slide-up; other shop screens save directly. See `ScriptRequire/CLAUDE.md` "applyReady savebar scoping".
- **`.cshtml` BOM rule** applies if you ever rewrite one of these views (see `Views/CLAUDE.md`).
- **Currency normalisation quirk:** order/stat code in `ShopcartHome/index.js` rewrites legacy currency strings `'บาท'`/`'THB.'`→`'THB'` and `'USD.'`→`'USD'` at runtime — legacy data may carry the un-normalised values.

---

## Feature: ปุ่มสั่งซื้อผ่านโซเชียล (Social Order Button) — DEV-1922 (`feature/social-order-button`)

### What it does
เพิ่มระบบ **"สั่งซื้อผ่านโซเชียล"** บนหน้ารายละเอียดสินค้า — แสดงปุ่มช่องทางโซเชียล (LINE, Facebook, หรือช่องทางที่กำหนดเอง) **ควบคู่ไปกับปุ่มใส่ตะกร้าปกติ** ลูกค้าที่อยากทักแชทสั่งซื้อกดปุ่มโซเชียลได้เลย โดยไม่ต้องผ่าน checkout

### How to get there
- **Route (ตั้งค่าต่อสินค้า):** `https://demo110.itopplus.com/?manage=true#!/Shopcart/Product/AddProductsV2/<productId>`
- อยู่ในฟอร์ม **เพิ่ม/แก้ไขสินค้า (V2)** — ส่วน Social Order Channel

### Fields
| Field (EN / TH) | ชนิด | ผล | ข้อควรระวัง |
|---|---|---|---|
| เปิดใช้งานปุ่มสั่งซื้อผ่านโซเชียล | toggle | เปิด/ปิดระบบ social order ของสินค้านี้ | เปิดแล้วปุ่มใส่ตะกร้ายังแสดงอยู่ ไม่ได้ถูกแทนที่ |
| Channel list | รายการช่องทาง | ช่องทางที่จะแสดงเป็นปุ่ม (preset LINE / Facebook หรือเพิ่มเอง) | — |
| ButtonText | text input ต่อช่องทาง | ข้อความบนปุ่ม | ใช้เป็นฐานในการ generate `Key` ถ้าเป็น channel ที่เพิ่มเอง |
| Url | text input ต่อช่องทาง | ลิงก์ปลายทางของปุ่ม | **ต้องขึ้นต้น `http://` หรือ `https://`** ไม่งั้น channel ถูกข้ามตอน save (`continue`) |
| IconUrl | text input ต่อช่องทาง | URL ไอคอนบนปุ่ม | **ต้องขึ้นต้น `http://`, `https://` หรือ `/`** ไม่งั้น channel ถูกข้ามตอน save |
| Key | สร้างอัตโนมัติ | identifier ภายในของช่องทาง | ดูกฎด้านล่าง |

### กฎการสร้าง Key อัตโนมัติ
ช่องทางที่ admin เพิ่มเอง (ไม่ได้มาจาก preset) จะมี `Key` ว่าง — ระบบสร้างให้ตอน save:
1. ถ้ามี `Key` อยู่แล้ว → ล้างเหลือเฉพาะ `[a-z0-9-]`
2. ถ้า `Key` ว่างแต่มี `ButtonText` → แปลง ButtonText เป็นตัวพิมพ์เล็ก ตัดทุกอย่างที่ไม่ใช่ `[a-z0-9-]` ออก แล้วตัดเหลือ **30 ตัวอักษร**
3. ถ้าผลลัพธ์ยังว่าง (เช่น ButtonText เป็นภาษาไทยล้วน ไม่มีอักษร ASCII เลย) → ใช้ `custom-{index}` แทน
4. ช่องทาง preset (LINE, Facebook ฯลฯ) มี `Key` กำหนดตายตัว ไม่ถูกเขียนทับ

### สิ่งที่แสดงบนหน้าสินค้า (ฝั่งลูกค้า)
- ป้ายข้อความ **"สั่งซื้อผ่านโซเชียล"** อยู่เหนือแถวปุ่มช่องทาง
- ปุ่มแต่ละช่องทางแสดง `IconUrl` + `ButtonText`
- ปุ่ม **ใส่ตะกร้า / Add to Cart** ปกติยังคงแสดงพร้อมกัน (ไม่ได้ถูกซ่อน)

### Wired in (for developers)
- **View (ตั้งค่า):** `Views/Shopcart/ShopBackEnd/AddProductV2.cshtml` — ส่วน social order channel config (branch นี้แตะ 38 ไฟล์, 1035+/189-)
- **Validate + สร้าง Key:** `ScriptRequire/Store/System/Shopcart/Setting/Service/shopconfig/addshopsetting.js` — ลูป validate `url` / `icon` ด้วย regex แล้ว push เข้า `safeCh.push({ Key, IconUrl, ButtonText, Url })`; บล็อก `if (!key && text) { ... }` คือจุดสร้าง Key อัตโนมัติ
- **Commits:** `e4c1d176b` (DEV-1922 ปุ่มสั่งซื้อผ่านโซเชียล), `1c7df13f7`, `ab0c1647a` (auto-generate Key จาก ButtonText)

### Gotchas
- **Channel ที่ URL หรือ Icon ผิดรูปแบบจะหายเงียบ ๆ** — validate ตอน save ใช้ `continue` ข้ามไป ไม่มี error แจ้ง admin; ถ้าปุ่มที่เพิ่มไว้ไม่ขึ้น ให้เช็คว่า URL ขึ้นต้นด้วย `http://` / `https://` และ IconUrl ขึ้นต้นด้วย `http://` / `https://` / `/` หรือยัง
- **ButtonText ภาษาไทยล้วนได้ Key เป็น `custom-0`, `custom-1`, …** ซึ่งผูกกับ **ลำดับใน array** — สลับลำดับช่องทางแล้ว Key อาจเปลี่ยนตาม

---

## Feature: ตั้งค่า Attribute Selector และ Auto-select อิสระต่อกัน (`feature/shopsetting-attr-display-autoselect`)

ก่อนหน้านี้ setting "Show All Attributes" และ "Auto-Select First Attribute" เป็น mutually exclusive (เปิดอันหนึ่งอีกอันจะซ่อน) บัดนี้ทั้งสอง toggle เป็นอิสระต่อกัน — admin สามารถเปิดทั้งคู่ ปิดทั้งคู่ หรือเปิดแค่อันใดอันหนึ่งก็ได้ นอกจากนี้ยังเพิ่มการ persist การเลือก attribute/size ลง `sessionStorage` เพื่อ restore เมื่อ reload

### วิธีเข้าถึง

- **Route:** `https://demo110.itopplus.com/?manage=true#!/ShopSetting/GeneralSetting`
- **Sidebar:** Store → Shop Setting → **General Setting** tab

### Fields

| Field (EN / TH) | Type | ng-model | ค่าที่ใช้ | ผลลัพธ์ |
|---|---|---|---|---|
| Show All Attributes (แสดง Attribute ทุกระดับ) | radio ON/OFF | `Setting.showallAttribute` | `'1'` / `'2'` | ON = แสดง attribute ทุก level พร้อมกันตั้งแต่โหลด |
| Auto-Select First Attribute (เลือก Attribute แรกอัตโนมัติ) | radio ON/OFF | `Setting.defaultAttributeLandingPage` | `'1'` / `'2'` | ON = auto-pick size แรก + cascade attribute ตามลำดับ |

### พฤติกรรม 4 กรณี

| Case | showallAttribute | defaultAttributeLandingPage | ผลบนหน้าสินค้า |
|---|---|---|---|
| 1 | ON (`1`) | ON (`1`) | แสดงทุก level + auto-pick size แรก + auto cascade ทุก attribute |
| 2 | OFF (`2`) | ON (`1`) | auto-pick size แรก + cascade attribute ทีละระดับ |
| 3 | ON (`1`) | OFF (`2`) | แสดงทุก level แต่ไม่ auto-pick (shoppers เลือกเอง) |
| 4 | OFF (`2`) | OFF (`2`) | แสดงแค่ size; attribute unlock ทีละ level หลัง size ถูกเลือก |

### Wired in (for developers)

- **Admin view:** `Views/Shopcart/GlobalSetting/GeneralSetting.cshtml` — นำ `ng-if` visibility gate และ `ng-click="checkShowAllAttribute(...)"` ออกหมด ทั้งสอง radio group แสดงอยู่เสมอ
- **ลบออก:** `$rootScope.checkShowAllAttribute(event, setting)` (ใน `getshopsetting.js` + `Checkout/Step/Controller.js`) — mutual-exclusion enforcer ถูก remove ทั้งหมด
- **Storefront JS:** `ScriptRequire/Shopcart/FrontEnd/PickSize/Controller.js` — `getSizepick()` ถูกเรียกตั้งแต่ load เมื่อ `showallAttribute=='1'`; `groupAttributeSizeColor()` ใช้กับทุก case
- **Storefront JS:** `ScriptRequire/Shopcart/FrontEnd/Attr/Controller.js` — `clickAttr()` cascade guarded ด้วย `isAutoSelectOff`; `reUpdateAttribute()` / `clearAttrPick()` อัปเดตแล้ว
- **Domain ใหม่:** `ScriptRequire/domains/shopcart/shopcart-picks-persist.domain.js` — `loadShopcartPicks()` / `restoreAttrPicks()` บันทึก/restore การเลือก attribute+size ใน `sessionStorage`

### Gotchas

- **ไม่มี endpoint ใหม่** — ทั้งหมดอ่านจาก `ShopSettingReturn[0].showallAttribute` / `.defaultAttributeLandingPage` ที่มีอยู่แล้ว ไม่ต้อง migrate ข้อมูล
- **Case 3 auto-pick แค่ level 0** แม้ showAll จะ ON แต่ cascade ถูกบล็อกด้วย `isAutoSelectOff` — ระดับที่สูงขึ้นยังต้องเลือกเอง
- **sessionStorage** เก็บ pick ทุก interaction และ restore ทุก init — ถ้า browser block sessionStorage (เช่น private mode บางราย) attribute จะไม่ restore แต่ไม่ crash

---

## Feature: Social Order Button + Hide Cart แบบ Per-Product (`feature/shopcart-per-product-social-order-and-hide-cart`)

ต่อยอดจาก Social Order Button (batch 3) เพิ่มการควบคุมระดับ per-product 3 อย่าง: (1) Show/Hide ปุ่ม Social Order สำหรับสินค้านี้ (2) Hide/Show ปุ่ม Add to Cart สำหรับสินค้านี้ (3) เปิด/ปิดทีละ channel สำหรับสินค้านี้ และเพิ่ม mode ใหม่ `perproductfull` ใน Shopcart Setting

### วิธีเข้าถึง
- **ตั้ง mode:** `https://demo110.itopplus.com/?manage=true#!/ShopSetting` → Social Order Button section → Mode radio
- **Per-product:** `https://demo110.itopplus.com/?manage=true#!/AddProductV2` → เปิด/แก้ไขสินค้า → scroll ลงถึงส่วน "ตั้งค่าปุ่มสั่งซื้อผ่านโซเชียล (เฉพาะสินค้านี้)"

### Fields (per-product)

| Field (EN / TH) | Type | ng-model | ค่า Default | เงื่อนไขแสดง |
|---|---|---|---|---|
| Show Social Order Button (แสดงปุ่ม Social Order) | radio Yes/No | `productTH.SocialOrderVisible` | `true` (แสดง) | เฉพาะ mode `perproduct` |
| Hide Cart Button (ซ่อนปุ่มเพิ่มลงตะกร้า) | radio Hide/Show | `productTH.HideCartButton` | `false` (แสดง) | ทุก Social Order mode |
| Per-channel toggles (เปิด/ปิดแต่ละช่องทาง) | checkbox array | `productTH.SocialOrderChannelEnabled[$index]` | `true` ทุก channel | เฉพาะ mode `perproduct` |

### Mode ของ Social Order Button

| Mode Value | ความหมาย |
|---|---|
| `global` | ใช้ channel URLs จาก Shopcart Setting ทุกสินค้า |
| `perproduct` | แต่ละสินค้ามี URL + ตั้งค่า channel เป็น per-product |
| `perproductfull` | mode ใหม่ — pass-through เหมือน perproduct บน frontend (ยังรอ UI distinct) |

### C# Model fields ที่เพิ่ม

```csharp
// ShopComponent.cs > Shopproduct class
public bool? SocialOrderVisible { get; set; }   // null = แสดง (backward safe)
public bool? HideCartButton { get; set; }        // null = แสดง Cart (backward safe)
public List<bool?> SocialOrderChannelEnabled { get; set; }
```

### Wired in (for developers)

- **Admin view:** `Views/Shopcart/ShopBackEnd/AddProductV2.cshtml` — Social Order section แสดงแม้ไม่ใช่ perproduct mode (สำหรับ HideCartButton); เพิ่ม radio + checkbox + warning div
- **Public views:** `Views/Component/Shopcart/cart/ProductDetail.cshtml` + `ProductDetail_Custom_01.cshtml` — Cart button wrap ด้วย `@if (!productHideCart)`; Social block wrap ด้วย `@if (socialEnabled && productSocialVisible)`; per-channel loop skip disabled channel
- **PoolNode schema:** `shop_productsSchema` เพิ่ม `SocialOrderVisible: Boolean` + `HideCartButton: Boolean`
- **PoolNode controller:** `shopproduct.js` — ทุก save path (create/update/duplicate) write ทั้งสอง field ด้วย case-insensitive boolean parse (`!== false && !== 'false'`)
- **Admin JS:** `ScriptRequire/System/Shopcart/Backend/getproductbyid.js` + `Controller.js (ManageProduct)` — load/save `SocialOrderVisible`, `HideCartButton`, `SocialOrderChannelEnabled`

### Gotchas

- **Guard ทำงานเฉพาะเมื่อ `socialEnabled`** — ถ้า Shopcart Setting ปิด Social Order Button field เหล่านี้ไม่มีผลใดๆ
- **ค่า null = แสดงตามปกติ** — สินค้าเก่าที่ไม่มี field นี้จะ render เหมือนเดิม ไม่ต้อง migrate
- **Warning ใน admin** จะแจ้งเตือนเมื่อ HideCartButton=true + SocialOrderVisible=false พร้อมกัน (ลูกค้าจะสั่งซื้อไม่ได้เลย)
- **`SocialOrderChannelEnabled` checkbox** ใช้ `ng-init` default-true บน `ng-repeat` iteration แรก — idempotent เพราะ read ค่าตัวเองก่อน flip
---

## Feature: อัปเดต 2C2P เป็น API v4.3 (`feature/shopcart-2c2p-v43-api`)

อัปเดต integration ของ payment gateway **2C2P** จาก API เวอร์ชันเก่าเป็น **v4.3** และเพิ่มการยืนยัน postback ผ่าน Order Inquiry API ก่อนส่ง email ยืนยันคำสั่งซื้อ เพื่อป้องกัน fake/replay postback

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/PaymentSetting` → card **2C2P**

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Merchant ID | Text input | รหัสร้านค้าที่ได้จาก 2C2P | ต้องตรงกับที่จดทะเบียนใน 2C2P dashboard |
| Secret Key | Text input | ใช้ sign/verify payload v4.3 | Key เวอร์ชันเก่าอาจใช้ไม่ได้ ต้อง regenerate จาก 2C2P |
| Postback URL | Text input | URL ที่ 2C2P จะ POST แจ้งผลชำระ | ต้องเป็น HTTPS และเข้าถึงได้จาก internet |
| Return URL | Text input | URL redirect หลังลูกค้าชำระ | — |

### Gotchas
- **ไม่มี toggle ใหม่** — เป็นการ update gateway ที่มีอยู่แล้ว; admin ที่ใช้ 2C2P อยู่แล้วจะได้รับ behavior ใหม่โดยอัตโนมัติหลัง deploy
- ระบบจะเรียก **Order Inquiry API** ก่อนส่ง confirmation email ทุกครั้ง — ถ้า 2C2P ยืนยันว่า order ยังไม่ชำระจริง email จะไม่ถูกส่ง
- ถ้าค่า Secret Key ผิดหรือเป็นเวอร์ชันเก่า postback จะ verify ไม่ผ่านและ order จะค้างที่สถานะ Unpaid

---

## Feature: New Attribute Mode Toggle (`feature/shopcart-new-attribute-mode-toggle`)

เพิ่ม toggle **"New Attribute Mode"** ใน General Setting เพื่อสลับ UI ของการเลือก attribute บนหน้าสินค้า — จาก dropdown แบบเดิมเป็น **image cards** แบบใหม่

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/GeneralSetting` → section **Product Status (สถานะสินค้า)**

### พฤติกรรม / Fields
| Field (EN / TH) | Type | ng-model | Effect | Gotchas |
|---|---|---|---|---|
| New Attribute Mode (โหมดแอตทริบิวต์ใหม่) | radio ON/OFF | `Setting.bNewModeAttribute` | ON = attribute แสดงเป็น image card แทน dropdown | feature อื่นที่เกี่ยวกับ attribute ใหม่ (hide single, sort numeric, image upload) ต้องเปิด mode นี้ก่อนถึงจะมีผล |

### Gotchas
- การเปิด/ปิด mode นี้กระทบ UI ทุกสินค้าในร้าน ทันทีที่ Save + Apply
- ถ้าเปิดแล้วยังไม่ได้ upload รูปให้ attribute values card จะแสดงเป็น placeholder

---

## Feature: ซ่อน Attribute ที่มี Option เดียว (`feature/shopcart-hide-single-attribute`)

toggle ซ่อน attribute ที่มีตัวเลือก (option) เพียงตัวเดียว — เนื่องจากระบบ auto-select ให้อยู่แล้ว ลูกค้าไม่ต้องเห็นหรือเลือก

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/GeneralSetting`

### พฤติกรรม / Fields
| Field (EN / TH) | Type | ng-model | Effect | Gotchas |
|---|---|---|---|---|
| ซ่อน Attribute ที่มี Option เดียว | radio ON/OFF | `Setting.bHideSingleAttr` | ON = attribute ที่มีแค่ 1 option จะถูกซ่อนบนหน้าสินค้า (ระบบ auto-select ให้) | **ต้องเปิด New Attribute Mode ก่อน** จึงจะมีผล |

### Gotchas
- ถ้าปิด New Attribute Mode (`bNewModeAttribute = OFF`) field นี้จะไม่มีผลแม้จะเปิดไว้
- ตรวจสอบว่า stock ของ option เดียวนั้นยังมีอยู่ก่อน ไม่งั้นสินค้าอาจดูเหมือน "ไม่มี attribute" แต่สั่งไม่ได้

---

## Feature: เรียง Attribute ตัวเลขจากน้อยไปมาก (`feature/shopcart-sort-numeric-attribute`)

per-domain toggle สำหรับเรียง option ของ attribute ที่เป็นตัวเลข (เช่น ไซส์ 38, 40, 42) จากน้อยไปมากอัตโนมัติ

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/GeneralSetting`

### พฤติกรรม / Fields
| Field (EN / TH) | Type | ng-model | Effect | Gotchas |
|---|---|---|---|---|
| เรียง Attribute ตัวเลขจากน้อยไปมาก | radio ON/OFF | `Setting.bSortNumericAttr` | ON = ระบบตรวจว่า values ทุกตัวใน attribute นั้น parse เป็น number ได้หรือไม่ ถ้าใช่ → sort ascending | ถ้า values ผสมกัน (เช่น "38", "S", "M") จะไม่ sort — ปล่อยไว้ตามลำดับเดิม |

### Gotchas
- Sort ทำ runtime บน frontend ไม่เปลี่ยนลำดับที่เก็บใน DB
- ถ้าต้องการ sort แบบ custom (ไม่ใช่ numeric ascending) ให้ลากเรียงลำดับด้วย Attribute Value Reorder แทน

---

## Feature: Attribute Image Upload & Numeric Input Sanitize ใน New Mode (`feature/shopcart-attr-newmode-image-and-number-input`)

ใน **New Attribute Mode** admin สามารถ upload/ลบรูปสำหรับแต่ละ attribute value ได้โดยตรง + ระบบ sanitize ตัวเลขที่มี comma หรือ space ก่อน save อัตโนมัติ

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/Attribute` → เลือก attribute → จัดการ values

### พฤติกรรม / Fields
| องค์ประกอบ | Type | Effect | Gotchas |
|---|---|---|---|
| Image upload ต่อ attribute value | File picker / upload | อัปโหลดรูป thumbnail สำหรับ value นั้น (แสดงบนหน้าสินค้าเป็น image card) | ต้องเปิด New Attribute Mode ก่อน |
| ปุ่มลบรูป | Button | ลบรูปของ value นั้น โดยไม่ต้อง re-upload รูปว่าง | — |
| Numeric input sanitize | อัตโนมัติ | value ที่มี comma (`,`) หรือ space (` `) จะถูก strip ก่อน save | เช่น `"1,000"` → `"1000"`, `"42 "` → `"42"` |

### Gotchas
- รูปที่ upload ผูกกับ value นั้น — ถ้าเปลี่ยนชื่อ value รูปยังคงอยู่ แต่ถ้าลบ value รูปจะถูกลบด้วย
- Sanitize numeric ทำก่อน save เสมอ — ถ้า admin ใส่ comma เพื่อ format จะหายไปทันที

---

## Feature: ปุ่มลบรูป Attribute (`feature/shopcart-attr-image-delete`)

เพิ่มปุ่ม **"ลบรูป"** ใน Attribute Manager สำหรับลบรูปที่ผูกกับ attribute value โดยเฉพาะ — ไม่ต้อง re-upload ไฟล์ว่างเพื่อลบรูปเหมือนเดิม

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/Attribute`

### พฤติกรรม / Fields
| องค์ประกอบ | Effect | Gotchas |
|---|---|---|
| ปุ่มลบรูป (delete image button) ต่อ attribute value | ลบ image URL ออกจาก value นั้น ทันที | การลบรูปไม่ได้ลบ value ออกจาก attribute แค่เอารูปออก |

### Gotchas
- Feature นี้แยกออกมาจาก `feature/shopcart-attr-newmode-image-and-number-input` เพื่อให้ใช้ได้แม้ไม่ได้เปิด New Attribute Mode ครบ

---

## Feature: Drag-and-Drop เรียง Attribute Values ต่อสินค้า (`feature/shopcart-attribute-value-reorder-per-product`)

admin ลากเรียงลำดับ attribute values ได้ใน **หน้า Edit สินค้า** แบบ per-product — ลำดับที่ลากจะถูก save เฉพาะสินค้านั้น แตกต่างจาก global order ใน Attribute Manager

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/Product/AddProductsV2/<productId>` → section **Attribute**

### พฤติกรรม / Fields
| องค์ประกอบ | Effect | Gotchas |
|---|---|---|
| Drag handle บนแต่ละ attribute value row | ลากขึ้น/ลงเพื่อเรียงลำดับ | ลำดับนี้ใช้สำหรับสินค้านี้เท่านั้น — global order ใน `#!/Shopcart/Attribute` ไม่เปลี่ยน |
| Save สินค้า | บันทึก per-product order | ถ้าไม่ Save order ที่ลากไว้จะหาย |

### Gotchas
- ถ้าเพิ่ม attribute value ใหม่ใน global Attribute Manager value ใหม่จะอยู่ท้ายสุดในทุกสินค้าที่ใช้ attribute นั้น
- Per-product order ไม่กระทบหน้า Attribute Manager

---

## Feature: Toggle Active/Inactive สินค้าจาก Product List (`feature/shopcart-product-status-toggle`)

admin สลับสถานะ **active ↔ inactive** ของสินค้าได้โดยตรงจากหน้ารายการสินค้า ไม่ต้องเข้าหน้า edit ทีละชิ้น

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/Product`

### พฤติกรรม / Fields
| องค์ประกอบ | Effect | Gotchas |
|---|---|---|
| Toggle badge สถานะ (แต่ละแถวสินค้า) | คลิกเพื่อเปลี่ยน active ↔ inactive ทันที | เปลี่ยนแบบ optimistic update — ถ้า API ล้มเหลว badge จะ revert |

### Gotchas
- ไม่ต้องกด Save หรือ Apply เพิ่มเติม — toggle บันทึกและมีผลทันที
- ถ้าสินค้ามีสถานะพิเศษ (เช่น หมด stock ทุก variant) badge อาจไม่ตรงกับ "เหตุผล" ที่ซ่อนสินค้า

---

## Feature: Shopcart "Tabs by Tag" บังคับเลือก Tag (`feature/shopcart-tabs-by-tag-require-tag`)

config Shopcart component แบบ **"Tabs by tag"** มี validation บังคับให้เลือก tag ก่อน save และ auto-select tag แรกถ้าไม่มีการเลือกไว้

### วิธีเข้าถึง
- **Route:** Layout Manager → เลือก/เพิ่ม Shopcart component → gear icon config → เลือก display mode "Tabs by tag"

### พฤติกรรม / Fields
| องค์ประกอบ | Effect | Gotchas |
|---|---|---|
| Tag selector ใน component config | ต้องเลือก tag อย่างน้อย 1 tag | ถ้าไม่เลือก ระบบป้องกัน save config พร้อมแสดง warning |
| Auto-select tag แรก | ถ้า config ถูก load แล้วไม่มี tag ที่เลือก ระบบ auto-pick tag แรกใน list | เพื่อป้องกัน component แสดงผิดพลาดบน frontend |

### Gotchas
- ถ้าลบ tag ที่ถูก select ออกจากระบบ component อาจ fallback เป็น tag อื่นอัตโนมัติ
- Apply หลัง save เสมอถ้าต้องการให้ผลมีผลบนหน้าจริง

---

## Feature: Related Products Type ใหม่ = Same Tag (`feature/shopcart-related-same-tag-type`)

เพิ่ม **Related Product type 4 (same tag)** ใน Shopcart component config — แสดงสินค้าที่มี tag เดียวกันเป็น related products

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart` → เลือก component → gear config icon → Related Products section

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Related Product Mode | Radio / select | เลือก type 4 = "Same Tag" | สินค้าต้องมี tag ที่ตรงกัน ถ้าไม่มีจะไม่แสดง related |

### Mode ทั้งหมด
| Mode | ความหมาย |
|---|---|
| 1 | Same category |
| 2 | Same brand |
| 3 | Manual select |
| **4** | **Same tag (ใหม่)** |
| 5 | Specific select (server-side search) |

### Gotchas
- Tag matching ใช้ exact match — ถ้า tag เขียนต่างกัน (uppercase/lowercase) อาจไม่ match

---

## Feature: Related Products Mode 5 — Specific Select (Server-side Search) (`feature/shopcart-related-mode-specific`)

เพิ่ม **Related Product mode 5** ให้ admin เลือกสินค้า specific สำหรับ related โดย search แบบ server-side — ไม่ต้อง load รายการสินค้าทั้งหมดก่อน

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/Product/AddProductsV2/<productId>` → section **Related Products** → เลือก mode 5

### พฤติกรรม / Fields
| องค์ประกอบ | Effect | Gotchas |
|---|---|---|
| Search box (ค้นหาสินค้า) | พิมพ์ชื่อ/keyword → ระบบ query server แล้วแสดงผลลัพธ์ | ต้องพิมพ์อย่างน้อย 2 ตัวอักษรก่อน search จะ trigger |
| เลือกสินค้าจากผลลัพธ์ | เพิ่มสินค้าที่เลือกเข้า related list ของสินค้านี้ | — |

### Gotchas
- Mode 5 เก็บ list ของ ProductID ไว้ per-product — ถ้าสินค้าใน list ถูกลบออกจากระบบ จะไม่แสดงบน frontend (ไม่ error แค่หาย)
- Server-side search ค้นได้เฉพาะสินค้า active เท่านั้น

---

## Feature: Max Items สำหรับ Related Products (`feature/multiple-tag-items`)

เพิ่ม field **"max items"** ใน Shopcart component config สำหรับจำกัดจำนวนสินค้าที่แสดงใน Related Products section — รองรับทุก mode

### วิธีเข้าถึง
- **Route:** Layout Manager → Shopcart component → gear config → Related Products section

### พฤติกรรม / Fields
| Field (EN / TH) | Type | ng-model | Default | Effect | Gotchas |
|---|---|---|---|---|---|
| Max Items (จำนวนสินค้าสูงสุด) | Number input | `shopConfig.nRelatedMaxItems` | `0` (ไม่จำกัด) | จำกัดจำนวน related products ที่แสดง | ค่า 0 หมายถึงไม่จำกัด — แสดงทั้งหมดที่หาได้ |

### Gotchas
- ใช้ร่วมกับ pagination ได้ — ถ้าเปิด pagination ด้วย max items จะถูก apply ก่อนแล้วค่อย paginate
- เปลี่ยนค่านี้แล้ว Apply เสมอถ้าต้องการให้มีผลบนหน้าจริง

---

## Feature: Pagination สำหรับ Related Products (`feature/product-related-pagination`)

เพิ่ม **pagination** สำหรับ Related Products section บนหน้าสินค้า (frontend) — admin config เปิด/ปิด + กำหนด items per page ใน Shopcart component

### วิธีเข้าถึง
- **Route:** Layout Manager → Shopcart component → gear config → Related Products section

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| เปิด Pagination | radio ON/OFF | แสดง pagination control ใต้ Related Products | ต้องมีสินค้า related มากกว่า items per page จึงจะแสดง pagination |
| Items per page (จำนวนต่อหน้า) | Number input | จำนวนสินค้าต่อ 1 หน้า | ค่าแนะนำ 4–8 ให้พอดีกับ grid layout |

### Gotchas
- Template ใหม่คือ `_ShopcartRelatedProductsPaged.cshtml` — ต้องแน่ใจว่า theme ที่ใช้ render template นี้ได้
- Pagination เป็น client-side (จาก data ที่ load มาแล้ว) ไม่ใช่ server-side — ถ้า related products มีจำนวนมากมาก ควรตั้ง Max Items ด้วย

---

## Feature: Level-3 Category Tree ใน Deep Search (`feature/shopcart-deep-level-l2-l3-tree`)

เพิ่ม **Level-3 (L3) tree** รองรับ Spare Part Explorer / Deep Search — admin config category tree ได้ถึง 3 ระดับ (L1 → L2 → L3)

### วิธีเข้าถึง
- **Route (config):** `https://demo110.itopplus.com/?manage=true#!/Shopcart/Collection` → category tree config
- **ใช้งาน:** หน้าสินค้าที่มี deep search filter (Spare Part Explorer component)

### พฤติกรรม / Fields
| องค์ประกอบ | Effect | Gotchas |
|---|---|---|
| L3 Category (ระดับ 3) | เพิ่ม sub-category ใต้ L2 ได้ | ต้องสร้าง L1 → L2 ก่อนจึงจะเพิ่ม L3 ได้ |
| Deep Search filter แสดง L3 | เมื่อ user เลือก L2 จะแสดง L3 ถัดไป | — |

### Gotchas
- ถ้า L2 ไม่มี L3 children — Deep Search จะแสดง product list ทันทีหลังเลือก L2 (ไม่แสดง L3 panel ว่าง)
- Category tree ลึก 3 ระดับอาจซับซ้อนสำหรับ user — ควรจัด naming ให้ชัดเจน

---

## Feature: Deep Search URL State (L1/L2/L3 + keyword ใน URL) (`feature/shopcart-deepsearch-url-state`)

Deep search state — การเลือก L1/L2/L3 + keyword — ถูก **บันทึกลงใน URL hash และ cookie** โดยอัตโนมัติ เมื่อ user กลับมาหน้าเดิม state จะคืนมาเอง

### วิธีเข้าถึง
- ทำงานอัตโนมัติในทุกหน้าที่มี Deep Search / Spare Part Explorer component — ไม่ต้อง config ใดๆ

### พฤติกรรม
| พฤติกรรม | รายละเอียด |
|---|---|
| บันทึก URL hash | เมื่อ user เลือก L1/L2/L3 หรือพิมพ์ keyword URL จะอัปเดต hash เพื่อให้ share/bookmark ได้ |
| บันทึก cookie | state ถูก save ลง cookie เพิ่มเติม — restore ได้แม้ reload โดยไม่มี hash ใน URL |
| Restore on load | เมื่อเปิดหน้า component อ่าน hash / cookie แล้วตั้งค่า filter ตาม state ที่บันทึกไว้ |

### Gotchas
- **ไม่มี admin toggle** — ทำงานอัตโนมัติ; ถ้าต้องการปิดต้องแก้ code
- Cookie มี expiry — ถ้าหมดอายุ state จะไม่ restore (แต่ URL hash ยังใช้ได้)

---

## Feature: ประวัติคำสั่งซื้อของลูกค้าใน Order Detail Sidebar (`feature/shopcart-customer-order-history`)

ขณะ admin เปิด order detail จะมี **sidebar ด้านขวา** แสดงประวัติคำสั่งซื้อทั้งหมดของลูกค้าคนนั้น ไม่ต้องออกไปค้นหาต่างหาก

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/Order` → คลิก order ใดก็ได้ → sidebar ด้านขวาแสดงประวัติ

### พฤติกรรม / Fields
| องค์ประกอบ | Effect | Gotchas |
|---|---|---|
| Order History sidebar | แสดงรายการ order ทั้งหมดของลูกค้าคนนั้น (เรียงตามวันที่ล่าสุด) | ต้องมีข้อมูลอีเมล/ชื่อลูกค้าในระบบจึงจะ match ได้ |
| คลิก order ใน sidebar | เปิด detail ของ order นั้นได้เลย | — |

### Gotchas
- ถ้าลูกค้าสั่งซื้อในฐานะ guest (ไม่ได้ login) การ match อาจใช้ email ของ order นั้น — ถ้าเคยใช้ email ต่างกันจะไม่รวมกัน

---

## Feature: Order History Tab ในหน้า Member Admin (`feature/member-order-history`)

เพิ่ม tab **"Order History"** ในหน้า Member Management สำหรับดูประวัติคำสั่งซื้อของ member แต่ละคน

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Member` → เลือก/เปิด member → tab **Order History**

### พฤติกรรม / Fields
| องค์ประกอบ | Effect | Gotchas |
|---|---|---|
| Tab "Order History" | แสดงรายการ order ทั้งหมดของ member คนนั้น | ถ้า member ไม่เคยสั่งซื้อ tab จะว่างเปล่า (ไม่ error) |
| คลิก order row | เปิด order detail ได้เลย | — |

### Gotchas
- ข้อมูลดึงจากการ match `MemberID` — ถ้า order ถูกสร้างโดย guest email เดียวกันแต่ไม่ได้ link กับ member จะไม่แสดงที่นี่

---

## Feature: คลิก Row ใน Order List เพื่อเปิด Detail (`feature/order-row-click-opens-detail`)

ปรับ UX ให้สามารถ **คลิกที่แถว (row) ใดก็ได้** ในหน้า Order List เพื่อเปิด order detail ได้เลย ไม่ต้องหาปุ่มเฉพาะ

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart/Order`

### พฤติกรรม
| พฤติกรรม | รายละเอียด |
|---|---|
| คลิก row | เปิด order detail ทันที เหมือนคลิกปุ่ม "ดูรายละเอียด" |
| ปุ่มเฉพาะ (ถ้ามี) | ยังคงทำงานได้ปกติ — row-click เป็นการเพิ่มเติม ไม่ได้แทนที่ |

### Gotchas
- ระวัง click propagation — ถ้า row มี toggle หรือ checkbox อื่น การคลิกที่ element เหล่านั้นยังทำงาน action ของตัวเองก่อน (stopPropagation)

---

## Feature: Bell Notification ใน Admin สำหรับ Omise Payment (`feature/omise-admin-bell-notification`)

เพิ่ม **bell notification** ใน admin header เมื่อมีการชำระเงินผ่าน Omise สำเร็จหรือล้มเหลว — แสดงเป็น badge จำนวน + toast notification

### วิธีเข้าถึง
- ทำงานอัตโนมัติเมื่อเปิดใช้งาน Omise gateway (`?manage=true#!/Shopcart/PaymentSetting` → เปิด Omise card)
- Bell icon อยู่ใน admin header bar

### พฤติกรรม / Fields
| องค์ประกอบ | Effect | Gotchas |
|---|---|---|
| Bell badge (จำนวนการแจ้งเตือน) | แสดงจำนวน Omise events ที่ยังไม่ได้อ่าน | หายเมื่อ admin คลิกอ่านแล้ว |
| Toast notification | popup แจ้งเมื่อมี Omise payment event ใหม่ | แสดงชั่วคราวแล้วหาย |

### Gotchas
- **ไม่มี toggle** — ทำงานอัตโนมัติเมื่อ Omise enabled; ถ้าไม่ต้องการต้องปิด Omise gateway
- Notification ใช้ polling หรือ webhook ขึ้นกับ infrastructure — ถ้าชำระแล้วไม่มีแจ้งให้ตรวจสอบ Omise webhook config

---

## Feature: Embed รูป Payment Slip ใน Email Body (`feature/paymentform-email-slip-inline`)

แนบรูป payment slip โดย **embed ตรงใน email body** (inline image) แทนที่จะส่งเป็น href link ที่อาจหมดอายุหรือถูก block โดย email client

### วิธีเข้าถึง
- ไม่มี admin toggle — ทำงานอัตโนมัติสำหรับทุก order confirmation email ที่มี slip

### พฤติกรรม
| พฤติกรรม | รายละเอียด |
|---|---|
| Slip ใน email | แสดงรูปเลย ไม่ต้องคลิก link เพื่อเปิด | ขนาดไฟล์ใน email เพิ่มขึ้นตามขนาด slip |

### Gotchas
- Email ที่มี inline image ขนาดใหญ่อาจถูก Gmail/Outlook ย่อ preview หรือ warn ว่า "รูปถูกบล็อก" (ขึ้นกับ email client settings ของลูกค้า)
- ถ้า slip ไม่ได้ upload ไว้ในระบบ (เช่น ลูกค้าส่งเป็น link ภายนอก) อาจไม่สามารถ embed ได้

---

## Feature: ส่ง Slip ทุกรูปไปยัง Admin Inbox (`feature/paymentform-multi-slip-admin-preview`)

ปรับให้ email ยืนยันที่ส่งให้ admin แนบ **slip ทุกรูปที่ลูกค้าอัปโหลด** (เดิมส่งแค่รูปแรก)

### วิธีเข้าถึง
- ไม่มี admin toggle — ทำงานอัตโนมัติสำหรับทุก order ที่ลูกค้า upload slip หลายรูป

### พฤติกรรม
| พฤติกรรม | รายละเอียด |
|---|---|
| Admin email | ได้รับ slip ครบทุกรูปที่ลูกค้าส่ง ไม่ใช่แค่รูปแรก | ขนาด email เพิ่มขึ้นตามจำนวนรูป |

### Gotchas
- ถ้าลูกค้า upload slip จำนวนมาก email อาจมีขนาดเกิน limit ของ mail server บางราย
- ไม่มีผลกับ customer confirmation email — ลูกค้ายังได้รับ email เหมือนเดิม

---

## Feature: Sales Overview Dashboard (`feature/mainbackend-sales-dashboard`)

เพิ่ม **Sales Overview card** ใน Main Backend dashboard สำหรับดูยอดขายและจำนวน order แบบ quick overview

### วิธีเข้าถึง
- **Route:** `https://demo110.itopplus.com/?manage=true#!/Shopcart` หรือ `https://demo110.itopplus.com/?manage=true` (home dashboard)

### พฤติกรรม / Fields
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| ยอดขายรวม (Total Revenue) | Display card | แสดงยอดรวมตาม date range ที่เลือก | ตัวเลขอ้างอิงจาก order ที่ "ชำระแล้ว" เท่านั้น |
| จำนวน Order (Order Count) | Display card | แสดงจำนวน order ตาม date range | — |
| This month / Last month | Filter toggle | เปลี่ยน date range สำหรับ card ทั้งสอง | ค่า default = This month |
| Date range picker | Date picker | กำหนด date range เอง | — |

### Gotchas
- Dashboard card อ่านข้อมูลแบบ near-realtime (ไม่ใช่ cached report) — อาจช้าเล็กน้อยถ้ามี order จำนวนมาก
- Currency ที่แสดงตาม config ร้านค้า — ถ้ามีหลาย currency อาจต้อง normalize ก่อน compare

---

## Feature: Shop Settings Header เป็น Pill Tabs (`feature/shopcart-settings-header-pills`)

redesign header ของ shop settings **ทุกหน้า** จาก tab bar แบบเดิมเป็น **pill tabs** style ใหม่ — เป็น UX/UI improvement ไม่มีอะไรต้อง config

### วิธีเข้าถึง
- ทำงานอัตโนมัติในทุก shop settings route (`#!/Shopcart/DetailShop`, `#!/Shopcart/GeneralSetting`, ฯลฯ)

### Gotchas
- ถ้า theme มี CSS override สำหรับ shop settings header อาจต้องตรวจสอบว่า pill tabs ยังแสดงผลถูกต้อง
- ไม่มีผลต่อ functionality — เป็นการ restyle เท่านั้น

---

## Feature: Shopcart Component Config แบ่งเป็น 2 Tabs (`feature/shopcart-manager-2tab-redesign`)

redesign **Shopcart component config dialog** (gear icon ใน Layout Manager) แบ่งออกเป็น **2 tabs**:
- **Display** — การแสดงผล layout, จำนวนคอลัมน์, style
- **Related/Filter** — Related Products config, filter settings

### วิธีเข้าถึง
- **Route:** Layout Manager → เลือก Shopcart component → คลิก gear (⚙) config icon → dialog ปรากฏเป็น 2 tabs

### Gotchas
- Settings เดิมทั้งหมดยังอยู่ครบ แค่ถูกแบ่งไปอยู่ใน tab ที่เหมาะสม
- ถ้าเคย save config แล้ว — ไม่ต้อง re-save; การ redesign ไม่กระทบ saved config

---

## Feature: Tab URL + Video ใน KendoImage Modal (`feature/shopcart-image-manager-video-tab`)

tab **"URL"** และ **"Video"** ใน KendoImage modal ถูก **unlock แล้ว** (เดิมซ่อน/disabled) — admin เพิ่มรูปจาก URL หรือแนบ video link ได้โดยตรง

### วิธีเข้าถึง
- ใช้ได้ในทุกที่ที่มี KendoImage picker: product image manager, attribute value image, และ component อื่นๆ ที่ใช้ `KendoImage` modal

### พฤติกรรม
| Tab | Effect | Gotchas |
|---|---|---|
| URL tab | วาง URL รูปภาพโดยตรง — ไม่ต้อง upload | URL ต้องเป็น public accessible HTTPS; CORS อาจบล็อก preview ถ้า server ปลายทางไม่อนุญาต |
| Video tab | แนบ video link (YouTube, Vimeo หรือ direct) | ระบบแสดงเป็น embed player ไม่ใช่รูปนิ่ง — ตรวจสอบว่า component ที่ใช้ render video ได้ |

### Gotchas
- **เดิม 2 tab นี้ hidden** ด้วย CSS/ng-if — ถ้า admin เคยใช้ modal นี้มาก่อนจะเห็น tab ใหม่โดยไม่ต้องทำอะไร
- Video URL ที่ไม่รองรับ embed (เช่น direct `.mp4` โดยไม่มี player wrapper) อาจแสดงผลไม่ถูกต้องใน component บางชนิด

---

## Feature: ปุ่มคัดลอกเลขบัญชีธนาคาร (Bank Account Copy Button) (`feature/checkout-bank-account-copy-button`)

### What it does
เพิ่ม **ปุ่ม "คัดลอก"** ถัดจากเลขบัญชีธนาคารในหน้า Checkout (ขั้นตอนชำระเงิน) — ลูกค้ากดปุ่มเดียวเพื่อ copy เลขบัญชีเข้า clipboard โดยไม่ต้องลากเมาส์เลือกเอง พร้อม feedback ข้อความ "คัดลอกแล้ว!" ชั่วคราว

### พัฒนาใน 3 ขั้นตอน (3 commits)

| Commit | สิ่งที่เพิ่ม |
|---|---|
| `144b5f9e7` | เพิ่มปุ่ม copy (icon ✂️ glyphicon-copy) + `$scope.copyBankAccount()` + CSS `.bank-account-number` (monospace) + `.bank-account-copy-btn` + `.copied` (สีเขียว) |
| `eae9ef45b` | เพิ่ม filter `bankAccountFormat` — format เลขบัญชีเป็น `XXX-X-XXXXX-X` (dash separator) |
| `521d2fb71` | เปลี่ยนปุ่มจาก icon เป็น **text label** `<span class="btn-copy-label">คัดลอก</span>` → `"คัดลอกแล้ว!"` เมื่อกด (UX ที่ชัดเจนกว่า) |

### พฤติกรรมปุ่ม
1. กดปุ่ม → `$scope.copyBankAccount(accountNumber, $event)` เรียก `navigator.clipboard.writeText(accountNumber)`
2. Success → เปลี่ยน label เป็น **"คัดลอกแล้ว!"** + เพิ่ม class `copied` (สีเขียว `#e6f4e6`)
3. หลัง 2 วินาที → reset label กลับ "คัดลอก" + ลบ class `copied`

### Format เลขบัญชี
Filter `bankAccountFormat` แปลงเลขบัญชีดิบ (string ตัวเลขล้วน) → รูปแบบ `XXX-X-XXXXX-X` ก่อนแสดงผลบนหน้าจอและก่อน copy ลง clipboard

### Fields / Elements ใหม่
| Element | CSS class / scope | ความหมาย |
|---|---|---|
| เลขบัญชี label | `.bank-account-number` | font-family: monospace; ทำให้ตัวเลขเรียงชัดเจน |
| ปุ่มคัดลอก | `.bank-account-copy-btn` | ปุ่มข้างๆ เลขบัญชี |
| สถานะ copied | `.bank-account-copy-btn.copied` | background สีเขียวอ่อน `#e6f4e6` ชั่วคราว |
| label ข้อความ | `.btn-copy-label` | "คัดลอก" → "คัดลอกแล้ว!" |

### Wired in (for developers)
- **Controller:** `ScriptRequire/System/Shopcart/FrontEnd/` (หรือ Checkout controller) — `$scope.copyBankAccount(accountNumber, $event)` ใช้ `navigator.clipboard` API; filter `bankAccountFormat`
- **View:** Checkout payment step — `<label class="bank-account-number">{{pay.opt2 | bankAccountFormat}}</label>` + `<button class="bank-account-copy-btn" ng-click="copyBankAccount(pay.opt2, $event)"><span class="btn-copy-label">คัดลอก</span></button>`
- **Commits:** `144b5f9e7` (icon copy button + monospace), `eae9ef45b` (bankAccountFormat filter), `521d2fb71` (text label + copied feedback)
