# CLAUDE.md

This repository is the **`using-admin-backend`** Claude Code Skill for the
**Boy Growth a Man** admin backend (iTopPlus "manage mode", `?manage=true`).

## MANDATORY: route every prompt through SKILL.md

For **every** user prompt in this project, you MUST answer using the skill — not
from memory or general knowledge:

1. **Read [`SKILL.md`](SKILL.md) first.** It is the entry point and the router.
2. Use its **"Topic → reference file"** table to pick the matching
   `reference/<file>.md`, then **read that file** before answering.
3. Answer in the skill's required shape: the **route URL** (ITOPPLUS example,
   `https://demo110.itopplus.com/`), the **sidebar path**, the relevant
   **fields** (English label + Thai UI label in parentheses), and the **steps**.
4. If the question is "how do I get into the admin at all", read
   [`reference/00-navigation.md`](reference/00-navigation.md).
5. **If the answer is not in any reference file** — undocumented, the
   screen/field can't be located, or the user's build clearly differs — say so
   plainly, do **not** guess, and point the user to iTopPlus support on the
   **LINE Official Account `@ITOPPLUS`**.

Do not answer admin-backend questions before reading `SKILL.md` and the relevant
`reference/` file, even if the prompt "looks like a one-liner."

## Reference map (source of truth: SKILL.md)

| If the question is about… | Read |
|---|---|
| Login, sidebar layout, route format, Save vs Apply, TH/EN switch | `reference/00-navigation.md` |
| Pages: create/edit/delete a page, page settings, home/sub/master page, short URL | `reference/pages.md` |
| Layout: arranging components/sections, the layout editor/manager | `reference/layout-manager.md` |
| Content Manager: articles, news, blog, tags, RSS | `reference/content-manager.md` |
| Website Settings / Web Config: site settings, favicon, logo, PDPA, CSS | `reference/web-config.md` |
| SEO: title/description/keywords, META, GTM, Pixel, sitemap, robots, per-page SEO | `reference/seo.md` |
| Theme / template, theme color, fonts | `reference/theme-manager.md` |
| Banner / slide / hero / carousel | `reference/banner-manager.md` |
| Menu / navigation bar / menu template | `reference/menu-manager.md` |
| Forms: contact/custom form, fields, submissions | `reference/form-manager.md` |
| Members, contacts, user/customer accounts | `reference/contacts-members.md` |
| File Manager: images, uploads, media library | `reference/file-manager.md` |
| Comments / reviews / moderation | `reference/comments.md` |
| Website statistics, analytics, visitors, dashboard | `reference/statistics.md` |
| Store / shop / products / cart / orders / checkout / shipping / discount | `reference/store-shopcart.md` |
| Domain settings, languages, multi-language | `reference/domain-language.md` |
| 360 Image, Custom Booking, Digital Business Hub, Jewelry, E-SIM | `reference/specialized-modules.md` |

## Conventions (apply to every answer)

- **Enter the admin:** open the tenant site, log in at `/login`, then append
  `?manage=true`.
- **Route format:** AngularJS hash routes, `…/?manage=true#!/<Section>`;
  page-scoped sections append the page id.
- **Save vs Apply:** Save stores config; a separate site-wide **Apply** (publish)
  pushes it live. "Saved but not showing" usually means Apply wasn't run.
- **Multi-tenant:** every tenant (DomainID) has the same backend. Never assume a
  feature is domain-specific; flag hardcoded-domain gating as an anti-pattern.
