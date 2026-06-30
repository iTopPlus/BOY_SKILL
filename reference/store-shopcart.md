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

## Gotchas / multi-tenant notes
- **Per-domain feature gates are config-driven, not hardcoded whitelists (good).** Online payment gateway cards (`Paypal`, `PaySocial`, `Omise`, `twoCtwoP`), the SMS notification row (siteowner `smsUsing`), and the Coupon/Promotion rows (`hideCoupon`/`hidePromotion`) all render based on per-domain settings — they are per-tenant flags, not in-code domain lists. No hardcoded `DomainID` whitelist was observed in these views.
- **Language scoping:** every settings screen has its own `DefaultLang` selector; values like shop detail and notification text are stored per language. When "All languages" is on, Shop Detail writes a `shopOwnerConfigs[]` entry keyed by `languageID`. Always test the language you intend to edit.
- **Apply overlay:** `GeneralSetting` and `DetailShop` save handlers set `$rootScope.applyReady = false`, so their save bars use the `--with-apply` slide-up; other shop screens save directly. See `ScriptRequire/CLAUDE.md` "applyReady savebar scoping".
- **`.cshtml` BOM rule** applies if you ever rewrite one of these views (see `Views/CLAUDE.md`).
- **Currency normalisation quirk:** order/stat code in `ShopcartHome/index.js` rewrites legacy currency strings `'บาท'`/`'THB.'`→`'THB'` and `'USD.'`→`'USD'` at runtime — legacy data may carry the un-normalised values.
