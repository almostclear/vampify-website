# VAMPIFY

Single-page marketing site for VAMPIFY — a premium website refreshment studio.

## Preview

Open `index.html` in a browser, or from this folder:

```bash
npx serve .
```

## Stack

- Static HTML
- Tailwind CSS (CDN)
- Vanilla JS
- Brand assets for dark UI: `vampify-transparent-white.png`, `vampify-small-transparent-light.png`

## Deploy

**Cloudflare Pages (recommended)**

1. Log in at [Cloudflare Pages](https://pages.cloudflare.com)
2. Create a project → connect `almostclear/vampify-website` (or upload this folder)
3. Build settings: leave build command empty; output directory `/` (or `.`)
4. Deploy, then attach a custom domain for HTTPS

**Netlify**

- Netlify Drop the folder, or connect the GitHub repo with publish directory = site root.

**GitHub Pages**

- Settings → Pages → Deploy from `main` / root.

No build step required. CDN-hosted Tailwind and fonts need network on first load.
