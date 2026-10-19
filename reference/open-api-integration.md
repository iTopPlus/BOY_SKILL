# Open API+AI / MCP integration (acting, not just explaining)

## What this is

The other reference files in this skill teach you **how a human would do something
by clicking through `?manage=true`**. Separately, Boy Growth a Man exposes a real
**Open API+AI** (REST + an MCP connector at `/itopplus-open-api/mcp`) that lets an AI
assistant perform some of those actions directly — read/write Content Manager
articles, read orders, read visitor stats, read the API log. Settings are at
`?manage=true#!/open-api-settings`; the live machine-readable description of what it
can do right now is always `GET https://<tenant-domain>/itopplus-open-api/openapi.json`
(public, no key needed to read it).

Treat this file as the **decision procedure** for choosing between "do it for them"
and "tell them the steps" — not as a list of tool names to memorize.

## When to check this

The user is asking you to **perform** something on their website, not just asking
"how do I…" or "where is…". Examples: "create a draft article about X", "show me
today's visitor stats", "what orders came in today". For a pure how-to question,
skip this file and answer from `SKILL.md`'s routing table as usual.

## How to check — do this every time, never hardcode a tool/endpoint list

The API is explicitly in **beta** (`betaHint` in the product itself says so) and new
endpoints get added over time. A list you memorize today will be wrong later. So:

1. **If you are already connected to this tenant's MCP server** (the user's AI
   client has the `itopplus-open-api` connector configured with their key), you
   already receive a scope-filtered `tools/list` — it only shows tools this specific
   key is allowed to use, and it reflects today's API exactly. Look at the tool
   names/descriptions returned right now; match the user's request against those,
   not against this document's coverage table below.
2. **If you are not connected** (you're answering purely as this `using-admin-backend`
   skill, no MCP session) — fetch `GET https://<tenant-domain>/itopplus-open-api/openapi.json`
   and read its `paths`, `tags`, and each operation's `summary`/`x-scope`. This spec
   is public and always current; it is the single source of truth for what the API
   can do *right now*, not the table in this file.
3. Match the user's request to an operation by what it actually does (summary/tags),
   not by assuming a name exists. If nothing matches, there is no API path for this
   yet — stop here and fall through to step 5.
4. If a match exists: tell the user it's possible via the API, and either call it
   (when you have an active MCP/API connection with a key that has the scope) or
   explain that they can have their own AI assistant/integration do it once their
   key is set up. Prefer this over walking them through the `?manage=true` UI.
5. If no match exists: fall back to the normal routing in `SKILL.md`'s "Topic →
   reference file" table and answer with UI steps as always. Don't tell the user a
   capability exists "soon" or guess at a timeline.

## Today's coverage (reference only — always re-check live per step 1/2 above)

| Reference file | Open API scope | Status (as of this writing) |
|---|---|---|
| `content-manager.md` | `content:read`, `content:write` | ✅ read + write via API/MCP |
| `store-shopcart.md` (orders only) | `orders:read` | ⚠️ read-only; no order-write endpoint yet |
| `statistics.md` | `stats:read` | ✅ available |
| *(this file's own log)* | `logs:read` | ✅ available (API call history) |
| pages, layout, banner, menu, theme, forms, members, file-manager, comments, web-config, domain-language, specialized-modules, shopcart products/attributes/settings | — | ❌ UI-only for now; answer from the normal routing table |

This table will go stale as the API grows — it exists so you have a rough starting
point, not so you can skip steps 1–2.

## Prerequisite

This only applies once the tenant has created an Open API key (Settings →
Open API+AI, `?manage=true#!/open-api-settings`) **and**, for step 1, the AI client
is connected to `/itopplus-open-api/mcp` with that key. If neither exists yet, there
is nothing to check — answer with UI steps as normal, and mention the Open API+AI
settings page only if the user is asking about automation in general.
