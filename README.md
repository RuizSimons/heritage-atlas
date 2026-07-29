# Heritage Architecture Atlas

A globally-scalable cultural-heritage architecture atlas built with Hugo.
Live at **https://ruizsimons.github.io/heritage-atlas/**

## What This Is

This site documents significant architectural heritage buildings worldwide,
presenting them as a living record of cultural and technical information.
The current collection includes four seed buildings:

- **Westerkerk** (Amsterdam, NL) — Dutch Renaissance church, 1620
- **Groninger Museum** (Groningen, NL) — Postmodern museum, 1994
- **Rietveld Schröder House** (Utrecht, NL) — De Stijl, UNESCO, 1924
- **Historic Inner City of Paramaribo** (Paramaribo, SR) — Dutch colonial, UNESCO, 1667

## Architecture

```
heritage-app/              ← Data source (not in this repo)
├── seed/
│   ├── westerkerk.json    ← Full building records (JSON Schema v0.1.0)
│   ├── westerkerk.md      ← Hugo markdown with YAML front matter
│   └── ...
├── building.example.json  ← Rietveld record (stored at root, not seed/)
├── building.schema.json   ← JSON Schema definition
├── scripts/
│   ├── build_index.py     ← Aggregates .json records into index.json
│   ├── add_building.py    ← Interactive CLI to add new buildings
│   └── validate_record.py ← Schema validator
├── admin_panel.py         ← Local web admin panel (Flask)
└── deploy-and-push.bat    ← Syncs data + rebuilds + stages

heritage-app-site/         ← This repo (Hugo site)
├── hugo.toml              ← Site config (baseURL, module mounts)
├── layouts/               ← Hugo templates (index, single, baseof, 404)
├── static/css/style.css   ← Stylesheet
├── content/_index.md      ← Home page stub
├── data/
│   ├── index.json         ← Building index (summaries for homepage)
│   ├── building.example.md ← Rietveld (mounted as content)
│   └── seed/
│       ├── westerkerk.md
│       ├── groninger-museum.md
│       └── historic-inner-city-paramaribo.md
└── .github/workflows/
    └── deploy.yml         ← GitHub Actions: build + deploy to gh-pages
```

## Data Flow

1. Building data lives as `.json` + `.md` pairs in `heritage-app/seed/`
2. `build_index.py` validates all `.json` records against the schema and
   generates `index.json` (a lightweight summary with name, city, year,
   architect, style, heritage status, description, thumbnail, and slug)
3. The `deploy-and-push.bat` script copies data files into this repo's
   `data/` directory and rebuilds the Hugo site
4. Hugo reads `data/index.json` for the homepage cards and mounts the
   `.md` files as content pages under `/buildings/<slug>/`

## Adding a Building

### Option A: Web Admin Panel (recommended)

Start the local admin panel:

```bash
cd C:\Users\simon\heritage-app
python admin_panel.py
```

Open http://127.0.0.1:5375 in your browser. The panel lets you:
- View all existing buildings as rich cards
- Add new buildings with a guided form
- Edit existing buildings (all fields, including events/sources/images)
- Delete buildings (with confirmation)

On submit, the panel automatically:
1. Saves `.md` + `.json` to `heritage-app/seed/`
2. Copies `.md` to `heritage-app-site/data/seed/`
3. Rebuilds `index.json`
4. Syncs `index.json` to `heritage-app-site/data/`
5. Rebuilds the Hugo site

### Option B: CLI

```bash
cd C:\Users\simon\heritage-app
python scripts/add_building.py
python scripts/add_building.py --wiki "Building Name"
python scripts/add_building.py --dry-run --wiki "Building Name"
```

After adding via CLI, run the deploy script to sync and rebuild.

## Deployment

### Automated (GitHub Actions)

Every push to `main` triggers the workflow in `.github/workflows/deploy.yml`:
1. Checks out the repo
2. Installs Hugo 0.147.0 extended
3. Builds with `hugo --minify`
4. Deploys `public/` to the `gh-pages` branch
5. GitHub Pages serves it at the live URL

### Local Deploy Script

```bash
C:\Users\simon\heritage-app\deploy-and-push.bat
```

This script:
1. Syncs data files from `heritage-app/` to `heritage-app-site/data/`
2. Rebuilds the Hugo site
3. Rebuilds `index.json`
4. Rebuilds the Hugo site again (picks up index changes)
5. Stages all changes with `git add -A`

You then manually commit and push:
```bash
cd C:\Users\simon\heritage-app-site
git commit -m "Add new building"
git push
```

## Local Development

```bash
# Preview the site locally
C:\Users\simon\bin\hugo.exe server --source C:\Users\simon\heritage-app-site

# Build the site
C:\Users\simon\bin\hugo.exe --source C:\Users\simon\heritage-app-site

# Admin panel
cd C:\Users\simon\heritage-app && python admin_panel.py
```

## Tech Stack

- **Hugo** v0.147.0 extended — static site generator
- **JSON Schema v0.1.0** — building data model
- **GitHub Actions** — CI/CD pipeline
- **GitHub Pages** — hosting
- **Flask** — local admin panel (Python, stdlib + Flask only)

## Repository Structure

Only source files are tracked. Hugo build output (`public/`, `404.html`,
`index.html`, `buildings/`, etc.) is gitignored and regenerated on every
build. The `gh-pages` branch contains the deployed build output.