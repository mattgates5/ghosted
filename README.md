# 👻 Ghosted

A personal job application tracker built with Rails 8. Named for the all-too-common experience of sending applications into the void.

Track where you've applied, where you're interviewing, and — inevitably — where you've been ghosted.

---

## Features

- **Application pipeline** — track every stage from *Interested* through *Offer*, *Rejected*, or *Ghosted*
- **Multiple views** — All, Active (in-progress only), and Archived
- **Search & filter** — full-text search across company, title, notes, and tags; filter by status, location, and work type
- **Charts** — status distribution donut chart and applications-over-time trend line
- **Job descriptions** — store the full JD alongside each application so you can reference it during interviews
- **Notes** — freeform field for recruiter names, referral info, interview notes, and anything else
- **Tags** — comma-separated tags for custom grouping
- **CSV export** — export any filtered view for analysis in a spreadsheet
- **Archive** — move completed applications out of the active list without deleting them
- **JSON API** — a simple REST API for programmatic access or integrations

---

## Tech Stack

- **Rails 8.1** with Hotwire (Turbo + Stimulus)
- **SQLite3** — lightweight, no external database required
- **Propshaft + ImportMap** — no Node.js or build step required
- **Chartkick + Groupdate** — pipeline charts
- **Kamal** — Docker-based deployment

---

## Getting Started

### Prerequisites

- Ruby 3.x
- Bundler

### Setup

```bash
git clone https://github.com/yourusername/ghosted.git
cd ghosted
bundle install
rails db:setup
rails server
```

Then open [http://localhost:3000](http://localhost:3000).

---

## Application Statuses

| Status | Meaning |
|---|---|
| Interested | Saved, not yet applied |
| Applied | Application submitted |
| Phone Screen | Initial recruiter or hiring manager call |
| Interview | Active interview process |
| Offer | Offer received |
| Rejected | Formally rejected |
| Ghosted | No response after follow-up |
| Withdrawn | You withdrew your application |

---

## API

A JSON API is available for scripting or external integrations.

```
GET    /api/v1/job_applications          # list (supports same filters as UI)
GET    /api/v1/job_applications/:id      # show
POST   /api/v1/job_applications          # create
PATCH  /api/v1/job_applications/:id      # update
DELETE /api/v1/job_applications/:id      # destroy
GET    /api/v1/job_applications/:id/job_description
```

Supported filters: `status`, `location`, `location_type`, `search`, `archived`

---

## Deployment

This app includes [Kamal](https://kamal-deploy.org) configuration for Docker-based deployment to any Linux server or VPS.

```bash
kamal setup   # first deploy
kamal deploy  # subsequent deploys
```
