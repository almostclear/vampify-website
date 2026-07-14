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
- Brand assets live in `assets/` (`vampify-transparent-white.png`, `vampify-small-transparent-light.png`)
- Case-study screenshots: `assets/pe-before.png`, `assets/pe-new.png` (2559×1354)

## Deploy

### Cloudflare Workers (static assets) — current default

Cloudflare’s dashboard now creates **Workers**, not classic Pages. This repo includes [`wrangler.jsonc`](wrangler.jsonc) so a Git-connected Worker serves the site as **static files** (no Worker script).

1. Workers & Pages → Create → Connect to Git → `vampify-website`
2. Build command: leave empty, or `exit 0`
3. Deploy / asset settings should pick up `wrangler.jsonc` (`assets.directory` = `./`)
4. After deploy you get a `*.workers.dev` URL; attach a custom domain in the Worker settings

Local check (optional):

```bash
npx wrangler deploy
```

### Classic Cloudflare Pages (still fine)

1. Create a **Pages** project (not a Worker) → connect the same repo  
2. Build command: empty / `exit 0`  
3. Output directory: `/` or `.`

**Netlify** / **GitHub Pages**: publish the repo root; no build step.
