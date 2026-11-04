# Open API+AI (beta) — REST API & MCP connector

## What it does
Lets an outside system or an **AI assistant** read and write this website's data with an **API key**. One key, two doors:

- **REST API** at `https://demo110.itopplus.com/itopplus-open-api/v1/…` — for code.
- **MCP connector** at `https://demo110.itopplus.com/itopplus-open-api/mcp` — for AI assistants (Claude, Claude Code, Codex CLI, Cursor, VS Code, Gemini CLI). The assistant sees the API as **tools** and calls them in plain language; no code needed.

Covers: Content Manager articles (read + write), Shopcart orders (read), website visitor statistics (read), and the API request log (read). Every key is bound to **one website** and to the **permissions** chosen when it was created. Beta: response shapes and endpoints may still change.

## How to get there
- **Sidebar:** Advanced Settings (ตั้งค่าขั้นสูง) > Open API+AI (beta).
- **Route (key settings):** `https://demo110.itopplus.com/?manage=true#!/open-api-settings`
- **Route (Help center):** `https://demo110.itopplus.com/?manage=true#!/api-docs` — four topics, each deep-linkable with `?topic=`: `start` (เริ่มต้นใช้งาน) · `mcp` (เชื่อมต่อ AI ผ่าน MCP) · `api` (เอกสารอ้างอิง API) · `skill` (คู่มือให้ AI ใช้ระบบ). The settings page's top-right **Help center (ศูนย์ช่วยเหลือ)** link opens it.
- **Machine-readable spec (no key needed):** `https://demo110.itopplus.com/itopplus-open-api/openapi.json` (OpenAPI 3.0).

## Fields on the screen (`#!/open-api-settings`)

### Header
| Field (EN / TH) | Type | Notes |
|---|---|---|
| Base URL (URL หลัก) | read-only slab + Copy (คัดลอก) | `https://demo110.itopplus.com/itopplus-open-api`. Always `https://` outside localhost. |
| Help center (ศูนย์ช่วยเหลือ) | link, top-right | Opens `#!/api-docs`. |

### API keys (API Keys)
| Field (EN / TH) | Type | Effect | Gotchas |
|---|---|---|---|
| Create API key (สร้าง API Key) | primary button | Opens the key form | The only green action on the page |
| Key name (ชื่อ Key) | text, max 80 | Label for the key — name it after the system that will use it | Required |
| Permissions (สิทธิ์การใช้งาน) | matrix: rows = Content (เนื้อหา), Orders (คำสั่งซื้อ), Website statistics (สถิติเว็บไซต์), API request log (บันทึกการเรียก API); columns = Read (อ่าน) / Write (เขียน) | Picks the key's scopes: `content:read`, `content:write`, `orders:read`, `stats:read`, `logs:read` | Only Content has Write. Ticking Content Write auto-ticks Read; unticking Read clears Write. At least one scope required. |
| Create key (สร้าง Key) / Cancel (ยกเลิก) | buttons | Creates the key and opens the one-time reveal | — |
| **One-time reveal:** "Copy this key now" (คัดลอก Key นี้เก็บไว้ตอนนี้) | dark panel | Shows the full key **once**; Copy (คัดลอก) button | Keys are stored **hashed** — if lost, revoke and create a new one |
| Copy MCP setup with key (คัดลอกการตั้งค่า MCP พร้อม Key) | menu in the reveal | Copies a ready-to-paste setup **with the real key filled in** for: Claude Code · Claude (claude.ai / Desktop) · Codex CLI · Cursor · VS Code · Gemini CLI | Only exists while the reveal is open; Esc closes the menu. The real key is never shown anywhere else. |
| I've stored it (เก็บเรียบร้อยแล้ว) | button | Closes the reveal | — |
| Key table: Name (ชื่อ), Key (prefix `itp_xxxxxx…`), Permissions (สิทธิ์), Last used (ใช้ล่าสุด), Created (สร้างเมื่อ) | read-only rows | — | Revoked rows are struck through with a "Revoked" (เพิกถอนแล้ว) tag |
| Revoke (เพิกถอน Key) → Confirm revoke (ยืนยันเพิกถอน) | per-row | Disables the key immediately; systems using it lose access at once | Irreversible |

### Recent API activity (การเรียกใช้ API ล่าสุด)
| Field (EN / TH) | Type | Notes |
|---|---|---|
| Filter: All (ทั้งหมด) / Succeeded (สำเร็จ) / Failed (ผิดพลาด) | segmented buttons | Filters by HTTP status |
| Columns: Time (เวลา), Request (คำขอ), Status (สถานะ), Duration (เวลาตอบ), Key / IP | table | REST rows show `METHOD /path`; MCP rows show `MCP mcp <tool>`; a failure's reason appears under the request |
| Previous / Page N of M / Next (ก่อนหน้า / หน้า / ถัดไป) | pager | 20 rows per page; appears only when there is more than one page |

Only calls that resolve to one of this site's keys are logged (including revoked keys). Calls with no key or an unknown key are **not** stored.

## Common tasks

### Issue a key for an AI assistant (read-only is the safe default)
1. Open `#!/open-api-settings` → **Create API key**.
2. Name it (e.g. "Claude — content review"), tick only the permissions it needs (e.g. Content Read + Website statistics Read). Don't tick Content Write unless the assistant should change the live site.
3. **Create key** → in the reveal, open **Copy MCP setup with key** and pick the AI app → paste into that app (see "Connect an AI assistant" below).
4. Click **I've stored it**. The key cannot be shown again.

### Revoke a leaked or unused key
`#!/open-api-settings` → key row → **Revoke** → **Confirm revoke**. Then create a new key if needed.

### See what a key has been doing
`#!/open-api-settings` → **Recent API activity** → filter Failed to find rejected calls; the reason (e.g. `This key lacks the "orders:read" permission`) is shown under the request.

---

## Calling the REST API

### Rules that apply to every request
- **Base URL:** `https://demo110.itopplus.com/itopplus-open-api` (the website's own domain). The key only works on the domain it was created on.
- **HTTPS only.** Plain `http://` is refused with `403 https_required` and is **not** redirected — the key has already crossed the wire by then; rotate it.
- **Authenticate** with either header on every call:
  ```
  Authorization: Bearer itp_…
  X-API-Key: itp_…
  ```
- **Errors** always have one shape and a meaningful status:
  ```json
  { "error": { "code": "forbidden", "message": "This key lacks the \"orders:read\" scope" } }
  ```
  | Status | code | Meaning |
  |---|---|---|
  | 400 | `validation_error`, `invalid_json`, `unknown_site` | bad input / body not JSON / domain not a tenant |
  | 401 | `unauthorized` | missing, wrong, revoked, or other-site key |
  | 403 | `forbidden` / `https_required` | key lacks the scope / plain HTTP |
  | 404 | `not_found` | no such endpoint or record |
  | 405 | `method_not_allowed` | e.g. `DELETE /v1/orders` |
- **Paging:** `?page=1&limit=20` (limit max 100). List responses are `{ items, total, page, limit }`.

### Endpoints
| Method & path | Scope | What it does |
|---|---|---|
| `GET /v1/contents` | `content:read` | List articles. Filters: `q` (title contains), `categoryId`, `published=true|false`, `languageId`, paging |
| `POST /v1/contents` | `content:write` | Create an article (`title` required) → `201` with the article |
| `GET /v1/contents/{id}` | `content:read` | One article (`languageId` optional) |
| `PATCH /v1/contents/{id}` (or `PUT`) | `content:write` | **Partial** update — only fields sent change |
| `DELETE /v1/contents/{id}` | `content:write` | Delete → `{ id, deleted: true }` |
| `GET /v1/content-categories` | `content:read` | All article categories `{ id, name, parentId, image, order }` |
| `GET /v1/orders` | `orders:read` | Orders, newest first. Filters: `paymentStatus`, `shippingStatus`, paging |
| `GET /v1/orders/{id}` | `orders:read` | One order by Mongo id **or** order number (OID) |
| `GET /v1/stats/summary` | `stats:read` | `{ allTime, today, last7Days, last30Days, devices }` |
| `GET /v1/stats/daily` | `stats:read` | Per-day `{ date, newVisitors, returningVisitors, total }`; `from`/`to` = `YYYY-MM-DD`, default last 30 days, max 366 |
| `GET /v1/logs` | `logs:read` | This site's API request log; `status=ok|error`, `keyId`, paging |

### Article fields (create / update body)
| Field | Type | Notes |
|---|---|---|
| `title` | string ≤500 | required on create |
| `subtitle`, `summary` | string | summary ≤5000 |
| `body` | string | **HTML** body (one editor block) |
| `coverImage` | string | image URL |
| `keywords`, `description`, `urlRewrite` | string | SEO fields |
| `published` | boolean | default `true` |
| `categoryIds` | string[] | must be existing category ids (`GET /v1/content-categories`) |
| `languageId` | string | which language entry to write; defaults to the site's default language |

Writes go through the same cache/search/ordering updates the admin editor uses, so the public site reflects them without a separate Apply step. A published article's response includes `id, title, subtitle, summary, body, coverImage, seo{…}, categoryIds, published, sticky, languages, views, createdAt, updatedAt`.

### Worked examples (ITOPPLUS)
```bash
# List the 5 latest published articles
curl -H "Authorization: Bearer itp_…" \
  "https://demo110.itopplus.com/itopplus-open-api/v1/contents?published=true&limit=5"

# Create a draft article
curl -X POST -H "Authorization: Bearer itp_…" -H "Content-Type: application/json" \
  -d '{"title":"โปรโมชันเดือนนี้","body":"<p>รายละเอียด</p>","published":false}' \
  "https://demo110.itopplus.com/itopplus-open-api/v1/contents"

# Visitors for the last 7 days
curl -H "X-API-Key: itp_…" \
  "https://demo110.itopplus.com/itopplus-open-api/v1/stats/daily?from=2026-10-07&to=2026-10-13"
```

---

## Connect an AI assistant (MCP)

MCP (Model Context Protocol) lets an assistant call this website's API as **tools**. Same key, same permissions, same activity log; MCP calls show as `MCP mcp <tool>`.

- **MCP URL:** `https://demo110.itopplus.com/itopplus-open-api/mcp`
- **Auth:** the API key as `Authorization: Bearer itp_…` (a static header — no OAuth sign-in).
- **Transport:** Streamable HTTP, stateless, JSON replies, tools only. Speaks MCP `2026-07-28` and the earlier `2025-03-26 … 2025-11-25` handshake, so both old and new clients connect.

### Fastest path
Create the key → in the one-time reveal use **Copy MCP setup with key** → pick the app → paste. The pasted setup already contains the real key. The per-app shapes it produces (replace `<your-api-key>` if you type them by hand):

| App | Where | Setup |
|---|---|---|
| **Claude (claude.ai / Desktop)** | Settings → Connectors → Add custom connector | Name `itopplus-<site>`, URL = MCP URL, **Request headers:** `Authorization: Bearer <your-api-key>` |
| **Claude Code** | terminal in the project | `claude mcp add --transport http itopplus-<site> https://demo110.itopplus.com/itopplus-open-api/mcp --header "Authorization: Bearer <your-api-key>"` |
| **Codex CLI** | `~/.codex/config.toml` | `[mcp_servers.itopplus-<site>]` / `url = "…/mcp"` / `bearer_token_env_var = "ITOPPLUS_API_KEY"` then `export ITOPPLUS_API_KEY="<your-api-key>"` (Codex has no inline-token field) |
| **Cursor** | `~/.cursor/mcp.json` | `{"mcpServers":{"itopplus-<site>":{"url":"…/mcp","headers":{"Authorization":"Bearer <your-api-key>"}}}}` |
| **VS Code** | `.vscode/mcp.json` | `{"servers":{"itopplus-<site>":{"type":"http","url":"…/mcp","headers":{"Authorization":"Bearer <your-api-key>"}}}}` |
| **Gemini CLI** | `~/.gemini/settings.json` | `{"mcpServers":{"itopplus-<site>":{"httpUrl":"…/mcp","headers":{"Authorization":"Bearer <your-api-key>"}}}}` |
| Other (no remote-HTTP support) | `mcp-remote` bridge | `"command":"npx","args":["mcp-remote","…/mcp","--header","Authorization:${AUTH_HEADER}"],"env":{"AUTH_HEADER":"Bearer <your-api-key>"}` — note **no space** after `Authorization:` (Windows arg quoting) |

### Tools the assistant sees (by key permission)
| Permission | Tools |
|---|---|
| `content:read` | `list_articles`, `get_article`, `list_article_categories` |
| `content:write` | `create_article`, `update_article`, `delete_article` |
| `orders:read` | `list_orders`, `get_order` |
| `stats:read` | `get_visitor_summary`, `get_daily_visitors` |
| `logs:read` | `list_api_requests` |

Tool arguments mirror the REST parameters (`get_article {id}`, `list_articles {q, categoryId, published, languageId, page, limit}`, `update_article {id, title, body, …}`). Each tool is annotated read-only or destructive, so assistants ask before `delete_article`.

### Test the connection
Ask the assistant: *"ใช้ itopplus แสดงบทความล่าสุด 5 รายการ"* / *"use itopplus to show the 5 latest articles"*. A list back means it works, and the call appears in **Recent API activity** as `MCP mcp list_articles`. With Claude Code, `claude mcp list` shows `✔ Connected`.

### Troubleshooting
| Symptom | Cause / fix |
|---|---|
| `401 Unauthorized` | Wrong, revoked, or other-site key; header must be `Authorization: Bearer <key>` |
| `403 https_required` | URL must start with `https://` |
| Assistant says it lacks permission | Key is missing that scope (readable tool error, not a connection failure) — create a key with it |
| Some tools missing | Expected: the assistant only sees tools for the key's permissions |
| `405` on the MCP URL | Something sent GET/DELETE; the connector accepts POST only (no SSE stream) |
| Connector works in Claude Code but not behind a proxy | A TLS-terminating proxy must forward `X-Forwarded-Proto: https` |

## Gotchas
- **Key shown once.** There is no "view key" later — only the prefix. Revoke + recreate.
- **One site per key.** A key from another tenant is rejected as invalid (not "wrong site"), on purpose.
- **Write tools change the live site.** Give assistants read-only keys unless they are meant to edit.
- **No rate limiting yet** (beta). A leaked key can hammer the site until revoked.
- **Local dev:** `localhost` works over plain HTTP only because the dev `Web.config` sets `OpenApiAllowHttp=true`; servers refuse HTTP.

## Key source files (for developers)
| Layer | File |
|---|---|
| Boy bridge (`/itopplus-open-api/*`, `/mcp`, admin actions) | `Controllers/Control/OpenApiController.cs`, routes in `App_Start/RouteConfig.cs` |
| Admin pages | `Views/Management/OpenApiSettings.cshtml`, `OpenApiDocs.cshtml`; `ScriptRequire/System/OpenApi/*`; copy in `ScriptRequire/domains/language/menu-by-language/open-api.js`; styles `Content/design-system/_open-api.scss` |
| PoolNode API + MCP | `LocalService/src/controllers/OpenApi/{index,mcp}.js`, `domains/openapi/{openapi.domain,openapi.document,openapi.mcp,openapi.mcp.names}.js`, `openapikey` collection in `connections/DB.js` |
