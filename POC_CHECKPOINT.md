# SPARTH PoC — Build Checkpoint
**Date:** 10 May 2026  
**Session:** PoC Build Day 1  
**Status:** In Progress

---

## What Is Done

### Step 1 — Supabase Database ✅
- All 4 tables created and verified:
  - `hubs` — seeded with Alpha hub (code: `ALP`, location: Test Location)
  - `reporters` — seeded with 3 test phones (Tenant, Manager, Staff)
  - `tickets` — empty, ready for PoC
  - `fitout_requests` — empty, ready for PoC
- 5 indexes created (duplicate detection, dashboard filters, SLA scan)
- RLS: disabled (safe for PoC — all access via n8n and NocoDB direct connection)

**Test phone roster:**
| Role | Phone |
|---|---|
| Tenant / Reporter | +919108291265 |
| Hub Manager | +919538945599 |
| Maintenance Staff | +919945277899 |

---

### Step 2 — NocoDB Cloud ✅
- Connected to Supabase via **session pooler** (port 5432)
  - Host: `aws-0-[region].pooler.supabase.com`
  - Username format: `postgres.[project-ref]`
- All 4 tables auto-discovered
- 3 views created on the `tickets` table:
  1. **All Tickets — Founders** (default grid, no filter)
  2. **Kanban — All Hubs** (grouped by `status`: Open / In Progress / Resolved)
  3. **Alpha Hub — Manager View** (grid filtered by `hub_name = Alpha`)
- `status` field changed to Single Select type with options: Open, In Progress, Resolved
- **Allow Schema Change: OFF** (re-enable temporarily if field type changes needed)

---

### Step 3 — n8n Local Setup ✅
- Node.js 20 LTS installed via nvm (Node 25 was too new — broke native module compilation)
- n8n installed globally: `npm install -g n8n`
- Running at: `http://localhost:5678`
- ngrok installed and authenticated
- Active tunnel: `https://flagman-mollusk-brute.ngrok-free.dev → http://localhost:5678`

> **Note:** ngrok free URL changes on every restart. Update Twilio webhook URL each session.

---

### Step 4 — Twilio WhatsApp Sandbox ✅
- All 3 test phones joined the sandbox
- Sandbox number: `+14155238886`
- Webhook configured in Twilio:
  ```
  https://flagman-mollusk-brute.ngrok-free.dev/webhook-test/whatsapp-intake
  ```
- Method: HTTP POST
- End-to-end message receipt confirmed: tenant phone → Twilio → ngrok → n8n ✅

---

### Step 5 — n8n Workflow: SPARTH — Intake (Partial) 🔄

**Workflow name:** `SPARTH — Intake`  
**Nodes built so far:**

| # | Node | Type | Status | Notes |
|---|---|---|---|---|
| 1 | Webhook | Webhook | ✅ Done | Path: `whatsapp-intake`, Method: POST |
| 2 | Extract Fields | Code | ✅ Done | Outputs: sender_phone, message_text, num_media, media_url, message_type, hub_code, received_at |
| 3 | Classify Issue | Code | ✅ Done | English-only keywords, 15 categories, fallback to GN-OT |
| 4 | Duplicate Check | Postgres | 🔄 Next | Query ready, credentials not yet saved |

**Twilio fields confirmed from live test:**
| Twilio Field | Value Example | Used As |
|---|---|---|
| `body.From` | `whatsapp:+919108291265` | sender_phone (strip prefix) |
| `body.Body` | `Hi` | message_text |
| `body.NumMedia` | `0` | num_media |
| `body.MediaUrl0` | null | media_url |
| `body.MessageType` | `text` | message_type |
| `body.To` | `whatsapp:+14155238886` | maps to hub ALP (hardcoded for PoC) |

---

## What Is Remaining

### Workflow 1: SPARTH — Intake (complete)
- [ ] Node 4: Postgres — Duplicate Check query
- [ ] Node 5: IF node — branch on duplicate vs new ticket
- [ ] Node 6a (new): Generate ticket ID (ALP-001 format), INSERT into tickets
- [ ] Node 6b (duplicate): UPDATE reporter_count, attach message to existing ticket
- [ ] Node 7: Twilio HTTP Request — notify hub manager via WhatsApp
- [ ] Node 8: Twilio HTTP Request — notify founders group via WhatsApp
- [ ] Activate workflow (switch from test URL to production URL)

### Workflow 2: SPARTH — Assignment
- [ ] Webhook trigger (listens for "ASSIGN" replies from hub manager)
- [ ] Parse staff name from message
- [ ] Postgres UPDATE — set assigned_to, assigned_at, status = In Progress
- [ ] Twilio — send task to maintenance staff via WhatsApp

### Workflow 3: SPARTH — Resolution
- [ ] Webhook trigger (listens for "DONE #ID" replies from staff)
- [ ] Parse ticket ID from message
- [ ] Postgres UPDATE — set resolved_at, calculate resolution_time_minutes, status = Resolved
- [ ] Twilio — notify reporter: issue resolved
- [ ] Twilio — notify founders: ticket closed with time

### Full PoC Demo Run (Section 11.6 Step 9)
- [ ] Phone 1 sends photo + voice note + text → ALP-001 appears in NocoDB
- [ ] Phone 2 (manager) replies ASSIGN Test Staff → Phone 3 notified
- [ ] Phone 3 replies DONE ALP-001 + photo → ticket closed, all notified
- [ ] Verify full record in NocoDB: assigned_by, assigned_to, resolution_time_minutes populated

---

## How To Resume Next Session

### Terminal commands to run first:
```bash
# Terminal 1 — start n8n
nvm use 20
n8n start

# Terminal 2 — start ngrok
ngrok http 5678
```

### After ngrok starts:
1. Copy the new ngrok URL (e.g. `https://xxxx.ngrok-free.app`)
2. Update Twilio webhook: Console → Messaging → WhatsApp Sandbox Settings → "When a message comes in"
3. Paste: `https://xxxx.ngrok-free.app/webhook-test/whatsapp-intake`

### Pick up from:
Open n8n at `http://localhost:5678` → open `SPARTH — Intake` workflow → add **Postgres node** after the Classify Issue node for the duplicate check.

**Duplicate check query:**
```sql
SELECT id, ticket_id, reporter_count
FROM tickets
WHERE hub_code = '{{ $json.hub_code }}'
AND subcategory_code = '{{ $json.subcategory_code }}'
AND status IN ('Open', 'In Progress')
LIMIT 1;
```

**Supabase connection for n8n Postgres node:**
- Host: session pooler host (from Supabase Connect panel)
- Port: 5432
- Database: postgres
- User: postgres.[project-ref]
- Password: Supabase DB password
- SSL: ON

---

## Key Files in This Repo

| File | Purpose |
|---|---|
| `SPARTH_PRD.md` | Full Product Requirements Document (v1.1) |
| `supabase_setup.sql` | Database schema + seed SQL (run in Supabase SQL Editor) |
| `POC_CHECKPOINT.md` | This file — build progress tracker |

---

*SPARTH PoC Checkpoint — Day 1 complete. Intake pipeline 60% built.*
