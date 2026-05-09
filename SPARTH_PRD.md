# SPARTH
## Product Requirements Document (PRD)
**Version:** 1.0  
**Date:** May 2026  
**Prepared for:** myofficespace  
**Founders:** Manjunath & Sharath  
**Status:** Draft — Awaiting Review

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Business Context](#2-business-context)
3. [Actors & Stakeholders](#3-actors--stakeholders)
4. [Problem Statement](#4-problem-statement)
5. [Product Vision](#5-product-vision)
6. [Functional Requirements](#6-functional-requirements)
7. [Non-Functional Requirements](#7-non-functional-requirements)
8. [Design Decisions Log](#8-design-decisions-log)
9. [System Architecture — Production](#9-system-architecture--production)
10. [Technology Stack](#10-technology-stack)
11. [PoC Build Specification](#11-poc-build-specification)
12. [Phase Roadmap](#12-phase-roadmap)
13. [Issue Category Taxonomy](#13-issue-category-taxonomy)
14. [Open Questions & Assumptions](#14-open-questions--assumptions)

---

## 1. Executive Summary

**SPARTH** is a lean, WhatsApp-native operations management system built for co-working and managed office space operators. It captures maintenance complaints and operational issues from any channel — WhatsApp, phone, email, or walk-in — and converts them automatically into tracked, accountable tickets without requiring any new behaviour or app download from the people who report or resolve them.

SPARTH is built first for **myofficespace**, a multi-hub co-working operator founded by Manjunath and Sharath, and is designed from the ground up to be commercialised as a standalone SaaS product for any co-working or managed office operator at scale.

The name SPARTH is a deliberate blend of both founders' names — **Sh**arath and Manju**nath** — anchoring the product's origin while positioning it as an independent, scalable brand.

**The core promise:** A complaint sent on WhatsApp in Kannada, with a photo and a voice note, becomes a fully tracked ticket — categorised, assigned, resolved, and logged with accountability — without the hub manager or maintenance staff ever touching a computer.

---

## 2. Business Context

### 2.1 About myofficespace

myofficespace is a co-working and managed office space operator with multiple hubs across locations. The business provides flexible workspace to individuals, startups, and enterprises and manages all associated facilities and maintenance operations.

**Current scale:** 20 hubs  
**Target scale:** 100–200 hubs within 2–3 years  
**Geographies:** India (initial), with potential for expansion

### 2.2 The Operational Reality Today

Every hub generates a continuous stream of maintenance and operational complaints — ACs not working, plumbing issues, electrical faults, cleaning lapses, security concerns, STP malfunctions, and more. These complaints arrive through:

- WhatsApp messages (approximately 80% of all complaints)
- Direct phone calls to hub managers or founders
- Emails to relevant contacts
- In-person walk-ins or verbal complaints at the hub

There is no unified intake system. Each complaint either gets acted on or gets lost, depending entirely on whether a human noticed it, remembered it, and followed through.

### 2.3 Current Workaround and Why It Fails

The co-founders have appointed hub managers who monitor a shared WhatsApp group for their respective hub. When a complaint arrives, the hub manager manually reads it, then logs a ticket in HubSpot.

**This fails for five reasons:**

1. **Manual translation from WhatsApp to HubSpot** — every ticket requires a human to copy information from one place to another. This is slow, inconsistent, and dependent on the hub manager's availability and attentiveness.

2. **No accountability trail** — when a ticket is eventually created, there is no reliable record of who reported it, who was assigned to fix it, who actually did the work, and how long it took from report to resolution.

3. **Duplicate blind spots** — if the same issue is reported by multiple people, multiple tickets may be created or the subsequent reports may be ignored entirely. There is no deduplication logic.

4. **Language and literacy barriers** — hub managers and maintenance staff are often more comfortable in Hindi or Kannada than English. HubSpot is an English-heavy, interface-heavy tool. This creates adoption friction that undermines the entire process.

5. **No founder visibility** — the co-founders have no real-time window into what is happening across all hubs. They depend on manual updates or periodic check-ins.

---

## 3. Actors & Stakeholders

### 3.1 Primary Actors

| Actor | Role | Tech Comfort | Primary Tool |
|---|---|---|---|
| Tenant / Member | Reports complaints | Low to medium | WhatsApp |
| Hub Manager | Receives, assigns tickets | Medium | WhatsApp |
| Maintenance Staff | Resolves tickets on ground | Low | WhatsApp |
| Founders (Manjunath, Sharath) | Oversight, escalation | Medium to high | WhatsApp + NocoDB |

### 3.2 Secondary Actors

| Actor | Role |
|---|---|
| SPARTH Bot (n8n) | Automated backbone — reads, creates, routes, closes tickets |
| Gemini Flash (Vision AI) | Analyses complaint photos |
| Whisper (Voice AI) | Transcribes voice notes |

### 3.3 Actor Constraints

- **Maintenance staff and some hub managers** are semi-literate or uncomfortable with English-heavy web interfaces. Any interface they must use must be WhatsApp — a tool they already use daily.
- **Founders** need mobile-first visibility. They cannot be expected to be at a computer to monitor operations.
- **Tenants** must experience zero change in behaviour. They must be able to report a complaint exactly as they would today — by sending a message to their hub's WhatsApp group.

---

## 4. Problem Statement

> myofficespace cannot efficiently manage the operational health of its hubs because complaints arrive from multiple channels in multiple formats and languages, with no automated mechanism to capture, deduplicate, assign, and track them — resulting in missed issues, unknown accountability, and no data on resolution performance.

### 4.1 Pain Points Prioritised

| Pain Point | Severity | Current Impact |
|---|---|---|
| No automatic ticket creation | Critical | Complaints routinely missed |
| No accountability trail | Critical | Founders cannot track who did what |
| No resolution time tracking | High | No SLA visibility or staff performance data |
| Duplicate complaints create noise | High | Same issue logged multiple times or ignored |
| Language barriers to existing tools | High | HubSpot adoption is poor |
| No real-time founder visibility | Medium | Co-founders rely on manual updates |

---

## 5. Product Vision

### 5.1 SPARTH for myofficespace (Phase 1)

A zero-friction operational backbone for myofficespace's 20 hubs. Every complaint becomes a ticket automatically. Every ticket has an owner. Every resolution is logged with proof and time. Founders see everything in real time.

### 5.2 SPARTH as a Commercial SaaS Product (Phase 2 and Beyond)

SPARTH is designed from day one to be productised and sold to any co-working or managed office operator in India and beyond. myofficespace is the first customer and the validation engine. Once the system is proven operationally, SPARTH becomes a standalone SaaS offering with:

- Multi-tenant architecture (each operator is an isolated tenant)
- White-label capability (operators can brand it as their own)
- A self-serve onboarding flow for new co-working operators
- A pricing model based on number of hubs or active tickets per month
- A marketplace for future integrations (payment, vendor management, lease management)

The commercial opportunity: India alone has thousands of co-working operators. Most of them have the same problem myofficespace has today. SPARTH solves it at a price point and simplicity level that no current enterprise product addresses.

---

## 6. Functional Requirements

### 6.1 Complaint Intake

**FR-01** — The system must accept complaints from WhatsApp as the primary channel.

**FR-02** — The system must accept complaints via email as a secondary channel.

**FR-03** — The system must allow hub managers to log complaints received via phone call or walk-in through a simple WhatsApp command or text entry.

**FR-04** — The system must accept multimodal input: text, photos, and voice notes, individually or in any combination.

**FR-05** — The system must support complaint text in Hindi, Kannada, and English without requiring the reporter to change language.

**FR-06** — The system must monitor one WhatsApp group per hub. Tenants send complaints to their hub's group exactly as they do today — no change in behaviour required.

**FR-07** — A dedicated founders-only WhatsApp group must receive notification of every ticket created across all hubs, in real time.

### 6.2 Message Buffering and Bundling

**FR-08** — When a complaint arrives, the system must open a 3-minute silence window before processing it as a complete complaint bundle.

**FR-09** — Any additional messages from the same sender within the 3-minute window must be added to the same bundle — not treated as separate complaints.

**FR-10** — After 3 minutes of silence from the sender, the bundle is finalised and processed as a single complaint.

**FR-11** — Voice notes within a bundle must be transcribed and their text content included in the ticket summary.

**FR-12** — Photos within a bundle must be attached to the ticket record and analysed by the vision AI layer.

### 6.3 AI Processing

**FR-13** — The system must use a vision model (Gemini Flash) to analyse complaint photos and extract: the likely issue type, and any contextual clues about the hub location.

**FR-14** — The system must transcribe voice notes using Whisper, supporting Hindi, Kannada, and English.

**FR-15** — The system must classify every complaint into one of the predefined issue categories (see Section 13).

**FR-16** — The system must identify which hub the complaint belongs to based on which WhatsApp group it came from, supplemented by AI context from photos and text where needed.

**FR-17** — If the AI cannot confidently classify an issue or identify a hub, the ticket must be created with a "Needs Review" flag and the hub manager must be asked to confirm the category.

### 6.4 Duplicate Detection

**FR-18** — Before creating a new ticket, the system must check for an existing open ticket of the same issue category at the same hub.

**FR-19** — If a matching open ticket exists, the new complaint must be attached to it — incrementing the reporter count and appending the new message content — rather than creating a duplicate ticket.

**FR-20** — The reporter must receive an automatic WhatsApp reply acknowledging their complaint and referencing the existing ticket ID: *"Your complaint has been noted. We are already working on this — Ticket #[ID]."*

**FR-21** — If the reporter count on a ticket reaches 5 or more, an escalation flag must be set and the founders group must receive an alert: *"⚠️ [N] people have reported [Category] at [Hub]. Ticket #[ID] is still open."*

### 6.5 Reporter Identity

**FR-22** — Every reporter must be identified by their phone number as the unique identifier.

**FR-23** — The first time a phone number sends a complaint, the system must send that number a private one-on-one WhatsApp message requesting their name.

**FR-24** — Once a name is provided, it must be permanently linked to that phone number in the system. All future complaints from that number are auto-tagged with their name.

**FR-25** — If a reporter does not respond to the name request, the ticket must still be created using the phone number as the reporter identifier. The hub manager may fill in the name manually.

### 6.6 Ticket Creation

**FR-26** — Every valid complaint bundle must result in exactly one ticket being created automatically without any human intervention.

**FR-27** — Every ticket must contain the following fields at creation:
- Unique Ticket ID (format: [HUB CODE]-[SEQUENCE], e.g. KRM-042)
- Hub name and location
- Issue category
- Priority (auto-assigned based on category and reporter count; editable)
- Reporter name or phone number
- Source channel (WhatsApp / Email / Phone / Walk-in)
- Complaint text (original + translated summary if non-English)
- Attached photos
- Voice note transcription (if applicable)
- Timestamp of report
- Status: Open

**FR-28** — Tickets must be stored in PostgreSQL via the NocoDB API. No ticket data may reside only in WhatsApp or n8n memory.

### 6.7 Assignment and Workflow

**FR-29** — Upon ticket creation, the relevant hub manager must receive a WhatsApp notification containing: Ticket ID, issue summary, category, priority, reporter name, and a prompt to assign it.

**FR-30** — The hub manager must be able to assign a ticket by replying to the WhatsApp notification with: *"ASSIGN [Staff Name]"*

**FR-31** — Upon assignment, the assigned staff member must receive a WhatsApp message with: Ticket ID, issue summary, hub location, and any attached photos.

**FR-32** — The ticket status must automatically update to "In Progress" when assignment is confirmed.

**FR-33** — The founders group must be notified of the assignment: *"Ticket #[ID] assigned to [Staff Name] by [Manager Name]."*

### 6.8 Resolution

**FR-34** — Maintenance staff must be able to close a ticket by replying to their assignment WhatsApp message with: *"DONE #[ID]"* optionally followed by a resolution photo.

**FR-35** — Upon receiving the DONE command, the system must automatically:
- Update ticket status to "Resolved"
- Log the resolution timestamp
- Calculate and store the time elapsed from Open to Resolved
- Attach the resolution photo to the ticket record
- Record the names of the assigning manager and the resolving staff member

**FR-36** — The original reporter must receive a WhatsApp notification that their issue has been resolved.

**FR-37** — The founders group must be notified: *"✅ Ticket #[ID] closed. [Category] at [Hub]. Resolved by [Staff] in [Time]."*

**FR-38** — If a ticket remains Open or In Progress beyond a configurable SLA threshold (default: 4 hours for high priority, 24 hours for normal), the system must send an escalation alert to the founders group.

### 6.9 Ticket Visibility

**FR-39** — Hub managers must be able to view all tickets for their hub via a shared NocoDB filtered view accessible on a mobile browser — no login required beyond a shared link.

**FR-40** — Founders must be able to view all tickets across all hubs in a single NocoDB view, filterable by hub, status, category, priority, and date.

**FR-41** — The NocoDB Kanban view must display tickets in columns: Open / In Progress / Resolved.

**FR-42** — No actor (hub manager, staff) must be able to delete a ticket record. Only system-level and admin-level access may modify or archive records.

### 6.10 Basic Reporting (Phase 1 — via NocoDB)

**FR-43** — Founders must be able to filter and sort all tickets by: hub, category, status, assigned staff, date range, and resolution time.

**FR-44** — Founders must be able to see at a glance, for any hub: total open tickets, tickets in progress, and tickets resolved in the last 7 days.

**FR-45** — Founders must be able to identify which staff member has the most open or unresolved tickets at any point in time.

---

## 7. Non-Functional Requirements

### 7.1 Scale

**NFR-01** — The system must support 20 hubs at launch and scale to 200 hubs without architectural changes.

**NFR-02** — The system must handle a minimum of 500 complaint messages per day across all hubs at 20-hub scale, and 5,000 per day at 200-hub scale.

**NFR-03** — The PostgreSQL database must support a minimum of 500,000 ticket records without performance degradation.

### 7.2 Performance

**NFR-04** — From the moment a complaint is received on WhatsApp to the moment a ticket is created in the database must not exceed 60 seconds under normal conditions (excluding the 3-minute buffer window).

**NFR-05** — WhatsApp notifications to hub managers and founders must be delivered within 30 seconds of ticket creation.

### 7.3 Availability

**NFR-06** — The system must target 99% uptime during business hours (7am–10pm IST).

**NFR-07** — Planned maintenance must be communicated 24 hours in advance and scheduled outside business hours.

### 7.4 Language

**NFR-08** — The system must accept and process text input in Hindi, Kannada, and English without manual language selection.

**NFR-09** — All automated WhatsApp messages sent by the system must be available in English as the default. Hindi localisation must be added before commercial launch.

### 7.5 Access Control

**NFR-10** — Hub managers must only have visibility of tickets for their own hub.

**NFR-11** — Maintenance staff must only see tickets assigned to them.

**NFR-12** — Founders must have visibility of all hubs and all tickets.

**NFR-13** — No hub manager or staff member may delete or permanently modify a ticket record.

### 7.6 Data Integrity

**NFR-14** — All ticket data must be persisted in PostgreSQL. No ticket may exist only in n8n memory or a messaging platform.

**NFR-15** — All photos and voice notes attached to tickets must be stored in persistent object storage (local VPS storage in Phase 1, cloud object storage in Phase 2).

**NFR-16** — The database must be backed up daily with a minimum 30-day retention period.

### 7.7 Security

**NFR-17** — The VPS running all services must be hardened with UFW firewall, fail2ban, and SSH key-only access.

**NFR-18** — All inter-service communication within the VPS must use localhost bindings — no services exposed to the public internet except n8n's webhook endpoint and NocoDB's web interface (both behind HTTPS).

**NFR-19** — API keys (Gemini, WhatsApp provider, Whisper if cloud) must be stored as environment variables and never hardcoded in workflow files.

---

## 8. Design Decisions Log

Every major decision made during the design of SPARTH is recorded here with the reasoning, so future teams can understand the context and make informed changes.

---

### DD-01: WhatsApp as Primary Interface for All Ground-Level Actors

**Decision:** All intake, assignment, and resolution interactions for tenants, hub managers, and maintenance staff happen through WhatsApp. No new app, no website login.

**Reason:** Approximately 80% of complaints already arrive via WhatsApp. Hub managers and maintenance staff are semi-literate or uncomfortable with English-heavy interfaces. WhatsApp is already installed, already used daily, and already trusted. Any solution requiring a new app download or a web login would face adoption failure. The lowest-friction path is to work within the tool people already use.

**Trade-off accepted:** WhatsApp commands (ASSIGN, DONE) are less intuitive than a UI button, but this is offset by the fact that the actors are already in WhatsApp and the command vocabulary is minimal.

---

### DD-02: One WhatsApp Group Per Hub

**Decision:** Each hub has its own dedicated WhatsApp complaint group. One founders-only group aggregates notifications from all hubs.

**Reason:** A single company-wide group creates noise — a tenant in Koramangala has no reason to see issues from Whitefield. Hub-specific groups keep signal clean for tenants and hub managers. The bot monitors each group independently and tags the hub automatically. Founders see a unified view via their own group without needing to join 20 hub groups.

**Trade-off accepted:** Managing 20+ groups has some overhead, but this is managed by the bot, not by humans.

---

### DD-03: 3-Minute Message Buffer

**Decision:** When a complaint arrives, the system waits 3 minutes of silence from the same sender before treating the bundle as a complete complaint.

**Reason:** Real users rarely send a complaint in one message. They send a photo, then a voice note explaining it, then a follow-up text. Without buffering, this becomes three separate tickets. A 3-minute window — consistent with natural human messaging pauses between topics — correctly bundles the vast majority of multi-message complaints into single tickets.

**Trade-off accepted:** There is a 3-minute delay before ticket creation. This is acceptable for maintenance complaints, which are not emergency services. The buffer is configurable and can be reduced if operational feedback demands it.

---

### DD-04: NocoDB Over Google Sheets

**Decision:** NocoDB on PostgreSQL is used as the ticket management database and UI, not Google Sheets.

**Reason:** Google Sheets presents several operational risks: concurrent write conflicts between the n8n bot and human viewers, deletion vulnerability (any authorised user can wipe data), performance degradation at scale (hundreds of thousands of rows), and structural limitations (one sheet per hub vs. one unified database with filtered views). NocoDB provides a spreadsheet-like UI that non-technical users are comfortable with, backed by a proper relational database with no row limits, proper access control, and no deletion risk through the UI.

**Trade-off accepted:** NocoDB requires self-hosting setup, unlike Google Sheets which requires no setup. This is a one-time configuration cost and is offset by the elimination of all Sheet-related risks.

---

### DD-05: NocoDB Over Airtable

**Decision:** Self-hosted NocoDB is used instead of Airtable.

**Reason:** Airtable is an excellent product but adds a recurring SaaS subscription cost. Since the system already requires a VPS for n8n, running NocoDB on the same VPS adds zero marginal cost. NocoDB is open-source, functionally equivalent to Airtable for this use case, and connects directly to PostgreSQL — making the data layer independent of any specific UI tool.

**Trade-off accepted:** NocoDB is less polished than Airtable and has a smaller ecosystem. This is acceptable for Phase 1 and will be re-evaluated if commercial launch requires a more robust UI layer.

---

### DD-06: Gemini Flash for Vision AI, Not GPT-4o

**Decision:** Google Gemini 1.5 Flash is used for photo analysis, not OpenAI GPT-4o.

**Reason:** GPT-4o is a capable multimodal model but is pay-per-use at a rate that adds up quickly across 20 hubs. Gemini Flash offers a free tier of 15 requests per minute and 1 million tokens per day — sufficient for this use case at 20-hub scale and for a sustained period even after scaling. It is also the cheapest capable vision model currently available on a pay-as-you-go basis when the free tier is eventually exceeded. The quality difference for the specific task of photo classification (identify issue type, identify hub context) is negligible.

**Trade-off accepted:** Gemini Flash is less capable than GPT-4o on complex reasoning tasks. For photo classification of maintenance issues in a co-working space, this capability gap is irrelevant.

---

### DD-07: Whisper for Voice Transcription

**Decision:** OpenAI Whisper (open-source, self-hosted) is used for voice note transcription.

**Reason:** Whisper is free, handles Hindi and Kannada reasonably well, and can be run on the same VPS as n8n and NocoDB. Voice notes are a primary input method for users who are more comfortable speaking than typing. Transcribing them into text allows the same classification and ticket-creation pipeline to work for voice as for text.

**Trade-off accepted:** Whisper's Hindi and Kannada accuracy is good but not perfect. The transcription is used for classification and ticket summary, not for legal records. Imperfect transcription is acceptable as long as the original voice note is also attached to the ticket.

---

### DD-08: n8n Over Zapier or Make

**Decision:** n8n (self-hosted) is used as the automation engine.

**Reason:** Zapier and Make are SaaS automation platforms with per-task or per-execution pricing models that become expensive at operational volume. n8n is open-source and self-hosted — once the VPS is running, all workflow executions are free. n8n has native WhatsApp Business API support, PostgreSQL connectors, HTTP request nodes for Gemini and Whisper, and an active open-source community. The self-hosted nature also means all data stays within the operator's control — no complaint photos or tenant information pass through a third-party automation platform.

**Trade-off accepted:** n8n requires a developer to set up and maintain. It does not have the drag-and-drop simplicity of Zapier for non-technical users. This is acceptable given that setup is a one-time cost and workflows rarely need modification once built.

---

### DD-09: Rule-Based Classification First, LLM as Fallback

**Decision:** Issue classification uses a keyword lookup table as the primary mechanism, with an LLM call only when the keyword approach fails.

**Reason:** For approximately 80% of complaints, the issue type is evident from simple keyword matching across Hindi, Kannada, and English vocabulary. "AC", "ಏಸಿ", "ठंडा", "air condition" all map to the same category without needing a language model. Reserving LLM calls for genuinely ambiguous cases keeps AI costs near zero for the majority of tickets.

**Trade-off accepted:** The keyword list requires initial effort to build and periodic maintenance as new complaint patterns emerge. This is a one-time investment with occasional updates.

---

### DD-10: Slack Dropped in Favour of WhatsApp for Founder Notifications

**Decision:** Slack was considered as the founders' monitoring interface but was dropped. WhatsApp + NocoDB is used instead.

**Reason:** Slack is an additional tool that requires setup, a new account, and habitual checking of a new application. The founders are already on WhatsApp. A dedicated founders WhatsApp group that receives live ticket notifications achieves the same outcome with zero learning curve. For deeper visibility and filtering, NocoDB's mobile browser view is available. Adding Slack would add complexity without adding capability that WhatsApp + NocoDB doesn't already provide.

---

### DD-11: PostgreSQL as the Database Layer

**Decision:** PostgreSQL is the primary data store for all ticket data.

**Reason:** PostgreSQL is the most widely used open-source relational database, with proven stability at scale, strong support for concurrent writes, and excellent tooling. It runs on any VPS at zero cost. Its data model (structured tables, relationships, indices) is a natural fit for ticket management. It also provides the foundation for Phase 2 analytics — any reporting or business intelligence tool can connect directly to PostgreSQL.

---

## 9. System Architecture — Production

### 9.1 High-Level Flow

```
COMPLAINT SOURCES
      │
      ├── WhatsApp Group (per hub) ──────────────────┐
      ├── Email                                        │
      ├── Phone / Walk-in (manual entry via WA)        │
      └── Future: QR code / web form                  │
                                                       ▼
                                          ┌─────────────────────┐
                                          │   n8n Automation    │
                                          │   (Webhook intake)  │
                                          └─────────┬───────────┘
                                                    │
                              ┌─────────────────────┼────────────────────┐
                              ▼                     ▼                    ▼
                    ┌─────────────────┐   ┌──────────────────┐  ┌───────────────┐
                    │ Whisper         │   │ Gemini Flash     │  │ Keyword       │
                    │ (Voice → Text)  │   │ (Photo Analysis) │  │ Classifier    │
                    └────────┬────────┘   └────────┬─────────┘  └───────┬───────┘
                             │                     │                     │
                             └─────────────────────┴─────────────────────┘
                                                    │
                                          ┌─────────▼───────────┐
                                          │   Complaint Bundle   │
                                          │   Assembled          │
                                          └─────────┬───────────┘
                                                    │
                                          ┌─────────▼───────────┐
                                          │  Duplicate Check     │
                                          │  (PostgreSQL query)  │
                                          └──────┬──────┬────────┘
                                          DUPE   │      │  NEW
                                                 │      │
                            ┌────────────────────┘      └──────────────────┐
                            ▼                                               ▼
                   ┌─────────────────┐                           ┌─────────────────┐
                   │ Attach to       │                           │ Create New      │
                   │ existing ticket │                           │ Ticket (PG)     │
                   │ + auto-reply    │                           └────────┬────────┘
                   └─────────────────┘                                   │
                                                               ┌──────────▼──────────┐
                                                               │ Notify Hub Manager  │
                                                               │ + Founders (WA)     │
                                                               └──────────┬──────────┘
                                                                          │
                                                               ┌──────────▼──────────┐
                                                               │ Manager assigns     │
                                                               │ via WA reply        │
                                                               └──────────┬──────────┘
                                                                          │
                                                               ┌──────────▼──────────┐
                                                               │ Staff receives task │
                                                               │ via WhatsApp        │
                                                               └──────────┬──────────┘
                                                                          │
                                                               ┌──────────▼──────────┐
                                                               │ Staff replies       │
                                                               │ DONE #ID + photo    │
                                                               └──────────┬──────────┘
                                                                          │
                                                               ┌──────────▼──────────┐
                                                               │ Ticket closed       │
                                                               │ Time logged         │
                                                               │ All notified (WA)   │
                                                               └─────────────────────┘
```

### 9.2 VPS Component Layout

All services run on a single Linux VPS (Ubuntu 22.04 LTS recommended):

```
VPS (₹800–1,500/month)
├── n8n                (port 5678, reverse-proxied via Nginx)
├── NocoDB             (port 8080, reverse-proxied via Nginx)
├── PostgreSQL         (port 5432, localhost only — not public)
├── Whisper            (local model, called by n8n via script)
├── Nginx              (reverse proxy + SSL via Let's Encrypt)
└── UFW Firewall       (only ports 80, 443, 22 open to public)
```

### 9.3 Data Flow for a Single Complaint

1. Tenant sends photo + voice note + text to Hub WA group
2. WhatsApp Business API provider (Interakt/Wati) receives the messages and fires webhook events to n8n
3. n8n collects events into a 3-minute buffer keyed by sender phone number + hub group ID
4. After buffer expires: voice note sent to Whisper → text returned; photo sent to Gemini Flash → issue type and context returned; text passed through keyword classifier
5. n8n queries PostgreSQL: any open ticket for same category + hub?
6. If YES: attach, increment counter, auto-reply via WhatsApp API
7. If NO: insert new ticket row into PostgreSQL via NocoDB API; send WhatsApp notifications to hub manager and founders group
8. Hub manager replies ASSIGN → n8n updates ticket row → sends WhatsApp to staff
9. Staff replies DONE → n8n closes ticket, calculates time delta, updates row, notifies all parties

---

## 10. Technology Stack

### 10.1 Production Stack

| Layer | Tool | Justification | Monthly Cost |
|---|---|---|---|
| Complaint intake | WhatsApp Business API (Interakt / Wati / AiSensy) | Indian provider, lower cost than Twilio, native WA support | ₹1,500–2,500 |
| Automation engine | n8n (self-hosted) | Open-source, no execution limits, full WA + DB support | ₹0 (on VPS) |
| Voice transcription | Whisper (self-hosted, open-source) | Free, good Hindi/Kannada accuracy | ₹0 |
| Vision AI | Gemini 1.5 Flash | Free tier covers 20-hub scale; cheapest capable vision model | ₹0 (free tier) |
| Database | PostgreSQL (self-hosted) | Production-grade, open-source, no row limits | ₹0 (on VPS) |
| Ticket UI | NocoDB (self-hosted) | Airtable-like UI on PostgreSQL, no subscription | ₹0 (on VPS) |
| Web server / SSL | Nginx + Let's Encrypt | Free reverse proxy and HTTPS | ₹0 |
| VPS hosting | Any provider (Hetzner, DigitalOcean, Linode, AWS Lightsail) | Runs all above services | ₹800–1,500 |

**Total estimated monthly cost: ₹2,300–4,000**  
*(The WhatsApp API is the only significant cost. Everything else is free.)*

### 10.2 WhatsApp API Provider Comparison

| Provider | Free Trial | Pricing Model | India Support | Setup Time |
|---|---|---|---|---|
| Interakt | Yes | Per conversation | Strong | 1–2 days |
| Wati | Yes | Monthly flat + conversations | Strong | 1–2 days |
| AiSensy | Yes | Per conversation | Strong | 1–2 days |
| Meta Cloud API (direct) | 1,000 free conversations/month | Per conversation | Direct | 3–5 days (verification) |

**Recommendation for PoC:** Twilio WhatsApp Sandbox (free, instant, no verification)  
**Recommendation for Production:** Interakt or Meta Cloud API direct

---

## 11. PoC Build Specification

### 11.1 PoC Objective

Demonstrate the complete end-to-end user journey on real devices, for free, before any infrastructure or subscription commitment is made.

### 11.2 What the PoC Proves

- A WhatsApp message (text, photo, voice) triggers automatic ticket creation
- The 3-minute buffering correctly bundles multiple messages into one ticket
- Basic duplicate detection prevents double ticket creation
- Hub manager receives WhatsApp notification and can assign via reply
- Maintenance staff receives task via WhatsApp
- Staff can close ticket with DONE command
- Ticket record is visible in NocoDB with full accountability trail

### 11.3 What the PoC Deliberately Excludes

- Production-grade VPS hosting (runs on local laptop)
- All 20 hub groups (test with 1 hub group)
- Full keyword library in Hindi and Kannada (English only for PoC)
- Whisper self-hosting (uses Whisper API with negligible cost)
- SLA breach alerts
- Founder-level reporting views

### 11.4 PoC Stack — Zero Upfront Cost

| Component | PoC Tool | Cost |
|---|---|---|
| WhatsApp intake | Twilio WhatsApp Sandbox | ₹0 |
| Automation engine | n8n on local laptop | ₹0 |
| Voice transcription | OpenAI Whisper API | < ₹20 total |
| Vision AI | Gemini Flash free tier | ₹0 |
| Database | Supabase free tier (hosted PostgreSQL) | ₹0 |
| Ticket UI | NocoDB Cloud free tier | ₹0 |
| WhatsApp notifications | Twilio Sandbox | ₹0 |

**Total PoC cost: ₹0–20**

### 11.5 PoC Prerequisites

The following accounts and tools must be set up before build begins:

1. **Node.js** installed on the build laptop (v18 or above)
2. **n8n** installed locally: `npm install -g n8n`
3. **Twilio account** created at twilio.com (free, no credit card required for sandbox)
4. **Twilio WhatsApp Sandbox** activated — testers join by sending a join code to the Twilio sandbox number
5. **Google Cloud account** with Gemini API key generated (free tier, no billing required for Flash model)
6. **OpenAI account** with Whisper API key (minimal credit required — ₹500 covers months of PoC usage)
7. **Supabase account** created at supabase.com (free tier, no credit card)
8. **NocoDB Cloud account** created at nocodb.com, connected to Supabase PostgreSQL database

### 11.6 PoC Build Steps

**Step 1 — Database Setup (Supabase)**
- Create a new Supabase project
- Create the `tickets` table with the schema defined in Section 11.7
- Copy the Supabase PostgreSQL connection string

**Step 2 — NocoDB Setup**
- Create NocoDB Cloud account
- Connect to Supabase using the PostgreSQL connection string
- Create filtered views: one for "All Tickets" (founders), one for "Hub 1 Only" (hub manager demo)
- Enable Kanban view grouped by status

**Step 3 — n8n Workflow: Intake**
- Install n8n locally and open at localhost:5678
- Create workflow: Webhook trigger (receives Twilio WhatsApp webhook) → message buffer logic (using n8n's Wait node or a simple in-memory approach) → bundle assembly

**Step 4 — n8n Workflow: AI Processing**
- Add Gemini Flash API call node (HTTP Request) for photo analysis
- Add Whisper API call node for voice transcription
- Add keyword classification function node (English keywords for PoC)

**Step 5 — n8n Workflow: Ticket Creation**
- Add PostgreSQL node connecting to Supabase
- Add duplicate check query
- Add conditional: if duplicate → auto-reply branch; if new → ticket creation branch
- Add ticket insert to PostgreSQL

**Step 6 — n8n Workflow: Notifications**
- Add Twilio WhatsApp API call to notify hub manager
- Add Twilio WhatsApp API call to notify founders group

**Step 7 — n8n Workflow: Assignment**
- Create second workflow triggered by incoming WhatsApp message containing "ASSIGN"
- Parse staff name from message
- Update ticket status in PostgreSQL
- Send WhatsApp to assigned staff

**Step 8 — n8n Workflow: Resolution**
- Create third workflow triggered by incoming WhatsApp message containing "DONE"
- Parse ticket ID from message
- Update ticket status, log timestamp and time delta
- Send resolution notifications to reporter and founders

**Step 9 — PoC Demo Run**
- With 3 test phones (tenant, hub manager, staff)
- Tenant sends photo + voice note to Twilio sandbox WhatsApp number
- Observe ticket appear in NocoDB within 3 minutes
- Hub manager receives WhatsApp, replies ASSIGN
- Staff receives WhatsApp, replies DONE with photo
- Founders group receives resolution notification
- Verify full ticket record in NocoDB

### 11.7 Tickets Table Schema

```sql
CREATE TABLE tickets (
    id                  SERIAL PRIMARY KEY,
    ticket_id           VARCHAR(20) UNIQUE NOT NULL,       -- e.g. KRM-042
    hub_name            VARCHAR(100) NOT NULL,
    hub_code            VARCHAR(10) NOT NULL,
    category            VARCHAR(50) NOT NULL,
    priority            VARCHAR(20) DEFAULT 'Normal',      -- Low / Normal / High / Critical
    status              VARCHAR(20) DEFAULT 'Open',        -- Open / In Progress / Resolved
    reporter_phone      VARCHAR(20) NOT NULL,
    reporter_name       VARCHAR(100),
    source_channel      VARCHAR(20) NOT NULL,              -- WhatsApp / Email / Phone / Walk-in
    complaint_text      TEXT,
    voice_transcription TEXT,
    photo_urls          TEXT[],                            -- Array of photo file paths or URLs
    resolution_photo_url VARCHAR(500),
    assigned_by_manager VARCHAR(100),
    assigned_to_staff   VARCHAR(100),
    reporter_count      INTEGER DEFAULT 1,
    escalation_flag     BOOLEAN DEFAULT FALSE,
    created_at          TIMESTAMP DEFAULT NOW(),
    assigned_at         TIMESTAMP,
    resolved_at         TIMESTAMP,
    resolution_time_minutes INTEGER,                       -- Calculated on close
    notes               TEXT
);

CREATE TABLE reporters (
    phone_number        VARCHAR(20) PRIMARY KEY,
    name                VARCHAR(100),
    hub_code            VARCHAR(10),
    first_seen          TIMESTAMP DEFAULT NOW(),
    last_seen           TIMESTAMP DEFAULT NOW()
);

CREATE TABLE hubs (
    hub_code            VARCHAR(10) PRIMARY KEY,
    hub_name            VARCHAR(100) NOT NULL,
    location            VARCHAR(200),
    whatsapp_group_id   VARCHAR(100),                      -- WA group ID monitored by bot
    manager_phone       VARCHAR(20),
    manager_name        VARCHAR(100),
    active              BOOLEAN DEFAULT TRUE,
    created_at          TIMESTAMP DEFAULT NOW()
);
```

### 11.8 Migration Path: PoC → Production

Every PoC component maps directly to a production equivalent with only a configuration change:

| PoC Component | Production Equivalent | Change Required |
|---|---|---|
| Twilio Sandbox | Interakt / Wati / Meta API | Update API credentials in n8n |
| n8n on laptop | n8n on VPS | Export workflows → import on VPS |
| Supabase | PostgreSQL on VPS | Update connection string in n8n and NocoDB |
| NocoDB Cloud | NocoDB on VPS | Reconnect to VPS PostgreSQL |
| Whisper API | Whisper self-hosted on VPS | Update n8n node to call local Whisper |

**No workflow logic is thrown away. The PoC is the production system on free infrastructure.**

---

## 12. Phase Roadmap

### Phase 1 — Operational Foundation (Months 1–3)

**Goal:** End-to-end ticket lifecycle working reliably across all 20 hubs. Founders have real-time visibility. Accountability trail is complete for every ticket.

**Deliverables:**
- WhatsApp intake for all 20 hub groups
- Automatic ticket creation with AI classification
- Duplicate detection and escalation
- Assignment via WhatsApp command
- Resolution via WhatsApp command with photo proof
- Reporter identity registration
- Full ticket record in PostgreSQL / NocoDB
- Founders and hub manager WhatsApp notifications
- NocoDB views for founders and hub managers
- Basic reporting via NocoDB filters and Kanban view

**Success Criteria:**
- 95%+ of complaints result in a ticket being automatically created
- Zero tickets require manual HubSpot entry
- Every resolved ticket has: assigned_by, assigned_to, and resolution_time_minutes populated
- Founders can answer "what is open at Hub X right now?" in under 30 seconds

---

### Phase 2 — Analytics and Commercialisation Readiness (Months 4–8)

**Goal:** Actionable performance data for founders. System ready to onboard a second operator.

**Deliverables:**
- Advanced reporting dashboard (Looker Studio or Metabase connected to PostgreSQL)
- SLA tracking and automatic breach alerts
- Per-hub and per-staff performance metrics
- Trend analysis (most common issues by hub, by month)
- Multi-tenant architecture (each operator is isolated)
- Self-serve hub onboarding (add a new hub by sending a WhatsApp command)
- SPARTH branding applied to all customer-facing messages
- Pricing model defined and billing infrastructure chosen

---

### Phase 3 — SaaS Launch (Months 9–18)

**Goal:** SPARTH available as a standalone product for any co-working operator in India.

**Deliverables:**
- SPARTH marketing website
- Self-serve signup and onboarding flow
- Stripe or Razorpay billing integration
- Multi-language support (Hindi, Kannada, English confirmed; Tamil and Telugu considered)
- Mobile-optimised NocoDB replacement with a purpose-built SPARTH web app
- Customer success process for new operator onboarding
- API for third-party integrations (accounting, lease management, vendor management)

---

## 13. Issue Category Taxonomy

The following categories cover the known universe of complaints in a co-working hub. This list drives the keyword classifier and the AI classification fallback. Categories are designed to be mutually exclusive and collectively exhaustive.

| Code | Category | Example Keywords (EN / HI / KN) |
|---|---|---|
| AC | Air Conditioning | AC, air condition, cooling, ठंडा नहीं, ಏಸಿ |
| PLMB | Plumbing | leaking, pipe, water, drainage, टपक, ನೀರು |
| ELEC | Electrical | power, electricity, socket, switch, बिजली, ವಿದ್ಯುತ್ |
| FLOOD | Flooding / Water Logging | flood, waterlog, basement, बाढ़, ನೀರು ತುಂಬಿದೆ |
| STP | Sewage / STP | STP, sewage, smell, odour, बदबू, ವಾಸನೆ |
| CLNS | Cleanliness | clean, dirty, dust, washroom, साफ, ಸ್ವಚ್ಛ |
| SECU | Security | security, access, lock, key, door, सुरक्षा, ಬಾಗಿಲು |
| INTL | Internet / Network | wifi, internet, network, slow, वाई-फाई, ಇಂಟರ್ನೆಟ್ |
| LIFT | Elevator / Lift | lift, elevator, stuck, लिफ्ट, ಲಿಫ್ಟ್ |
| PEST | Pest Control | pest, cockroach, rat, insect, कीड़े, ಕ್ರಿಮಿ |
| FURN | Furniture / Fixtures | chair, table, broken, desk, कुर्सी, ಕುರ್ಚಿ |
| PARK | Parking | parking, vehicle, car, bike, पार्किंग, ಪಾರ್ಕಿಂಗ್ |
| GNRL | General / Other | (fallback for anything unclassified) |

---

## 14. Open Questions & Assumptions

The following items were identified during design but not yet resolved. They must be decided before or during Phase 1 build.

| # | Question | Impact | Owner |
|---|---|---|---|
| OQ-01 | Which WhatsApp Business API provider — Interakt, Wati, AiSensy, or Meta direct? | High — drives all intake setup | Founders |
| OQ-02 | Final list of issue categories — any categories missing from Section 13? | High — drives AI classification accuracy | Operations team |
| OQ-03 | SLA thresholds — how many hours before a ticket triggers an escalation by category? | High — drives escalation logic in n8n | Founders |
| OQ-04 | Hub naming and coding convention — e.g. KRM for Koramangala. Full list needed. | High — drives ticket ID format | Operations team |
| OQ-05 | Who are all the maintenance staff by hub? Phone numbers and names needed to pre-register them. | High — drives assignment notification | Hub managers |
| OQ-06 | What language should automated WhatsApp messages be sent in — English only, or bilingual? | Medium — affects reporter experience | Founders |
| OQ-07 | Should voice notes from staff (DONE command) also be accepted, or text-only for commands? | Medium — affects resolution workflow design | Operations team |
| OQ-08 | Is there a vendor / contractor layer? (External plumber, electrician hired per job) | Medium — may need a fourth actor type | Founders |
| OQ-09 | Data retention policy — how long should resolved tickets be retained before archival? | Low — affects storage planning | Founders |
| OQ-10 | VPS provider preference — Hetzner (European, cheapest), DigitalOcean, or AWS Lightsail? | Low — all work; pricing varies slightly | Tech team |

---

*SPARTH PRD v1.0 — Prepared May 2026*  
*Built for myofficespace. Designed to scale.*  
*Founders: Manjunath & Sharath*
