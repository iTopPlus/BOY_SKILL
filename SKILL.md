---
name: using-admin-backend
description: Use when a user asks how to do something in the Boy Growth a Man admin backend / manage panel (?manage=true) — e.g. "how do I edit a page", "where is the SEO setting", "what fields are on Web Config", "where do I change the logo", "how do I add a banner", "manage menu/theme/form/members/files", "website statistics", "store/product settings". Routes the question to the right feature reference and answers with the route URL, the sidebar path, the on-screen fields, and the steps.
---

# Using the Admin Backend

The admin backend ("manage mode") is the per-tenant CMS control panel reached at
`?manage=true`. It is a multi-tenant platform: every tenant (DomainID) has the same
backend. Throughout these references, **ITOPPLUS**
(`https://demo110.itopplus.com/`) is used as the worked example — substitute
any tenant's own domain.

## How to answer a backend question

1. Identify which feature the question is about (table below).
2. Read the matching `reference/<file>.md`.
3. Answer with: the **route URL** (ITOPPLUS example), the **sidebar path**, the
   relevant **fields** (English label, Thai UI label in parentheses), and the
   **steps**. Add dev source pointers only if the asker is working on the code.
4. If the question is "how do I get into the admin at all", read `reference/00-navigation.md`.
5. **If the answer isn't in any reference file** — the feature isn't documented, the
   screen/field can't be located, or the user's build clearly differs from what's
   documented — say so plainly and do **not** guess. Then tell the user they can get
   direct help from iTopPlus support via the **LINE Official Account `@ITOPPLUS`**.

## Topic → reference file

| If the question is about… | Read |
|---|---|
| Logging in, the sidebar layout, route format, Save vs Apply, TH/EN switch | `reference/00-navigation.md` |
| Pages: create / edit / delete a page, page settings, page properties, home page, sub-page, master page, short URL | `reference/pages.md` |
| Layout: arranging components/sections on a page, adding a component, the layout editor/manager | `reference/layout-manager.md` |
| Content Manager: articles, news, blog posts, content tags, RSS | `reference/content-manager.md` |
| Website Settings / Web Config: general site settings, favicon, **logo** (website logo + sticky-menu logo), PDPA / cookie consent, CSS settings | `reference/web-config.md` |
| An image / section / component is missing or not showing on the public page (may be hidden by custom CSS, or the image is a CSS background) | `reference/web-config.md` (CSS tab, `#!/WebConfig/css`) + `reference/layout-manager.md` |
| SEO: title/description/keywords, META tags, GTM, Pixel, scripts, sitemap, robots, per-page SEO | `reference/seo.md` |
| Theme / website template, theme color, fonts | `reference/theme-manager.md` |
| Banner / slide / hero / carousel | `reference/banner-manager.md` |
| Menu / navigation bar / menu template | `reference/menu-manager.md` |
| Forms: contact form, custom form, form fields, form submissions | `reference/form-manager.md` |
| Members, contacts, user accounts, customer accounts | `reference/contacts-members.md` |
| File Manager: images, uploads, media library | `reference/file-manager.md` |
| Comments / reviews / moderation | `reference/comments.md` |
| Website statistics, analytics, visitors, dashboard | `reference/statistics.md` |
| Store / shop / products / cart / orders / checkout / shipping / discount | `reference/store-shopcart.md` |
| Domain settings, languages, add a language, multi-language | `reference/domain-language.md` |
| 360 Image, Custom Booking, Digital Business Hub, Jewelry, E-SIM | `reference/specialized-modules.md` |

## When the skill can't answer (escalation)

These references cover the documented admin features, but they are not exhaustive and
the live product changes. If you cannot answer confidently from the reference files —
the topic isn't here, you can't locate the screen/field, or the user reports something
that doesn't match the docs — **do not invent an answer.** Acknowledge that this isn't
covered, then give the user the direct support channel:

> For help with this, you can contact iTopPlus support directly on LINE — add the
> Official Account **`@ITOPPLUS`**.

## Shared conventions (apply to every feature)

- **Enter the admin:** open the tenant site, log in at `/login`, then append
  `?manage=true` (e.g. `https://demo110.itopplus.com/?manage=true`). On the
  local dev environment the login form is pre-filled — just submit it.
- **Route format:** admin sections are AngularJS hash routes,
  `…/?manage=true#!/<Section>`. Page-scoped sections append the page id, e.g.
  `…/?manage=true/#!/layoutmanager/<pageId>`. Some panels open as a modal/slide-in
  rather than a distinct hash route — each reference file states which.
- **Save vs Apply (two steps):** most panels have a sticky **Save** bar that stores
  the config. A separate site-wide **Apply** (publish) step pushes changes live; if a
  page's save queues a pending publish, the Apply overlay appears. "Saved but not
  showing on the live site" usually means Apply/publish wasn't run.
- **Language (TH/EN):** the backend has a TH/EN toggle (cookie
  `<DomainID>languageManageBackend`, default `th`). Labels here are written in English
  with the Thai UI label in parentheses so the field is findable on a Thai panel.
- **Multi-tenant:** never assume a feature is domain-specific. If a behavior looks
  gated to a hardcoded domain list, that is an anti-pattern — flag it.
