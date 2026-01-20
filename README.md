# Team Status (Rails)

Tiny Rails app for tracking a team’s “what am I doing right now?” statuses.

## What it does

- Create a team (name → UUID + API keys)
- Add “team users” (not accounts; just username + optional profile pic URL)
- Post async status updates for users
- Query the current team status (for things like a menu bar app)
- Extremely simple HTML view at `/teams/:uuid`

## Requirements

- Ruby `3.2+`
- Bundler

## Setup

```bash
cd team-status
bundle install
bin/rails db:prepare
```

Optional demo data (development only):

```bash
bin/rails db:seed
```

Run the server:

```bash
bin/rails server
```

## Web UI

- Create a team: `http://localhost:3000/`
- Team page: `http://localhost:3000/teams/:uuid`

The team page lists users + their current status and includes a tiny form to add users.

## API Authentication

Every API request must include these headers:

- `X-Team-Public-Key`
- `X-Team-Secret-Key`

The secret key is only shown once on team creation.

## API Endpoints

Base path: `/api/v1/team`

### List users

`GET /api/v1/team/team_users`

```bash
curl -sS \
  -H "X-Team-Public-Key: PUBLIC" \
  -H "X-Team-Secret-Key: SECRET" \
  http://localhost:3000/api/v1/team/team_users
```

### Create user

`POST /api/v1/team/team_users`

```bash
curl -sS -X POST \
  -H "Content-Type: application/json" \
  -H "X-Team-Public-Key: PUBLIC" \
  -H "X-Team-Secret-Key: SECRET" \
  -d '{"team_user":{"username":"alice","profile_pic_url":"https://example.com/a.png"}}' \
  http://localhost:3000/api/v1/team/team_users
```

### Post a status update

`POST /api/v1/team/status_updates`

Body:

- `username` (required)
- `status` (required)

```bash
curl -sS -X POST \
  -H "Content-Type: application/json" \
  -H "X-Team-Public-Key: PUBLIC" \
  -H "X-Team-Secret-Key: SECRET" \
  -d '{"username":"alice","status":"Deep work"}' \
  http://localhost:3000/api/v1/team/status_updates
```

### Fetch current team status

`GET /api/v1/team/status`

```bash
curl -sS \
  -H "X-Team-Public-Key: PUBLIC" \
  -H "X-Team-Secret-Key: SECRET" \
  http://localhost:3000/api/v1/team/status
```

Response includes users with `status` and `updated_at` (based on each user’s latest status update).

## Tests

```bash
bin/rails test
```

## Notes

- Data model is intentionally small: `Team`, `TeamUser`, `StatusUpdate`.
- Team secret key is stored as a bcrypt digest (`secret_key_digest`).
