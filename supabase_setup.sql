-- =============================================================
-- SPARTH PoC — Supabase Database Setup
-- Run this entire file in Supabase → SQL Editor → New Query
--
-- Before running: replace the three placeholders below:
--   TENANT_PHONE    → test tenant's number  (e.g. +919876540001)
--   MANAGER_PHONE   → test manager's number (e.g. +919876540002)
--   STAFF_PHONE     → test staff's number   (e.g. +919876540003)
-- =============================================================


-- =============================================================
-- STEP 1: TABLES
-- Order matters — hubs first (reporters + tickets reference it)
-- =============================================================

CREATE TABLE IF NOT EXISTS hubs (
    hub_code            VARCHAR(10)  PRIMARY KEY,
    hub_name            VARCHAR(100) NOT NULL,
    location            VARCHAR(200),
    whatsapp_group_id   VARCHAR(100),            -- WA group ID monitored by bot (fill at go-live)
    manager_phone       VARCHAR(20),
    manager_name        VARCHAR(100),
    active              BOOLEAN      DEFAULT TRUE,
    created_at          TIMESTAMP    DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reporters (
    phone_number        VARCHAR(20)  PRIMARY KEY,
    name                VARCHAR(100),
    hub_code            VARCHAR(10)  REFERENCES hubs(hub_code),
    first_seen          TIMESTAMP    DEFAULT NOW(),
    last_seen           TIMESTAMP    DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tickets (
    id                      SERIAL       PRIMARY KEY,
    ticket_id               VARCHAR(20)  UNIQUE NOT NULL,   -- e.g. ALP-001
    hub_code                VARCHAR(10)  REFERENCES hubs(hub_code),
    hub_name                VARCHAR(100) NOT NULL,
    main_category           VARCHAR(50)  NOT NULL,          -- e.g. Facility Maintenance
    subcategory_code        VARCHAR(10)  NOT NULL,          -- e.g. FM-AC
    subcategory_label       VARCHAR(100) NOT NULL,          -- e.g. AC
    assigned_team           VARCHAR(100),                   -- e.g. HVAC Team
    priority                VARCHAR(5)   DEFAULT 'P2',      -- P1 / P2 / P3
    status                  VARCHAR(20)  DEFAULT 'Open',    -- Open / In Progress / Resolved
    reporter_phone          VARCHAR(20)  NOT NULL,
    reporter_name           VARCHAR(100),
    source_channel          VARCHAR(20)  NOT NULL,          -- WhatsApp / Email / Phone / Walk-in
    complaint_text          TEXT,
    voice_transcription     TEXT,
    photo_urls              TEXT[],
    resolution_photo_url    VARCHAR(500),
    assigned_by_manager     VARCHAR(100),
    assigned_to_staff       VARCHAR(100),
    reporter_count          INTEGER      DEFAULT 1,
    escalation_flag         BOOLEAN      DEFAULT FALSE,
    needs_review_flag       BOOLEAN      DEFAULT FALSE,     -- set when classifier is not confident
    is_billing              BOOLEAN      DEFAULT FALSE,     -- true for Billing & Commercial tickets
    is_emergency            BOOLEAN      DEFAULT FALSE,     -- true for Emergency tickets (P1 auto-escalate)
    created_at              TIMESTAMP    DEFAULT NOW(),
    assigned_at             TIMESTAMP,
    resolved_at             TIMESTAMP,
    resolution_time_minutes INTEGER,                        -- calculated on close
    notes                   TEXT
);

CREATE TABLE IF NOT EXISTS fitout_requests (
    id                      SERIAL       PRIMARY KEY,
    request_id              VARCHAR(20)  UNIQUE NOT NULL,   -- e.g. FO-ALP-001
    hub_code                VARCHAR(10)  REFERENCES hubs(hub_code),
    hub_name                VARCHAR(100) NOT NULL,
    subcategory_code        VARCHAR(10)  NOT NULL,          -- e.g. FO-WS
    subcategory_label       VARCHAR(100) NOT NULL,          -- e.g. Workstation Setup
    assigned_team           VARCHAR(100),                   -- e.g. Projects Team
    priority                VARCHAR(5)   DEFAULT 'P2',
    status                  VARCHAR(30)  DEFAULT 'Submitted', -- Submitted / Under Review / Approved / In Progress / Completed / Rejected
    requester_phone         VARCHAR(20),
    requester_name          VARCHAR(100),
    source_channel          VARCHAR(20),
    request_description     TEXT,
    photo_urls              TEXT[],
    vendor_name             VARCHAR(100),
    estimated_cost          NUMERIC(10,2),
    approved_by             VARCHAR(100),
    approved_at             TIMESTAMP,
    completion_photo_url    VARCHAR(500),
    assigned_to             VARCHAR(100),
    created_at              TIMESTAMP    DEFAULT NOW(),
    started_at              TIMESTAMP,
    completed_at            TIMESTAMP,
    notes                   TEXT
);


-- =============================================================
-- STEP 2: INDEXES
-- Optimise for the two most frequent n8n queries:
--   (a) Duplicate check: open ticket for same category + hub
--   (b) Dashboard filters: tickets by hub + status
-- =============================================================

-- Duplicate detection (FR-18): hub + subcategory + status
CREATE INDEX IF NOT EXISTS idx_tickets_dup_check
    ON tickets (hub_code, subcategory_code, status);

-- Dashboard / NocoDB filters: all open tickets per hub
CREATE INDEX IF NOT EXISTS idx_tickets_hub_status
    ON tickets (hub_code, status);

-- SLA breach scan: find old unresolved tickets efficiently
CREATE INDEX IF NOT EXISTS idx_tickets_created_status
    ON tickets (created_at, status);

-- Fit-out: hub + status for the Projects Team view
CREATE INDEX IF NOT EXISTS idx_fitout_hub_status
    ON fitout_requests (hub_code, status);

-- Reporters: look up by hub (hub manager's roster view)
CREATE INDEX IF NOT EXISTS idx_reporters_hub
    ON reporters (hub_code);


-- =============================================================
-- STEP 3: SEED — Alpha Hub
-- The single PoC hub. manager_phone and manager_name are set
-- here AND in the reporters table below so both stay in sync.
-- Replace MANAGER_PHONE with the actual test manager number.
-- =============================================================

INSERT INTO hubs (hub_code, hub_name, location, manager_phone, manager_name, active)
VALUES (
    'ALP',
    'Alpha',
    'Test Location',
    'MANAGER_PHONE',    -- ← replace with manager's number e.g. +919876540002
    'Test Manager',
    TRUE
)
ON CONFLICT (hub_code) DO NOTHING;


-- =============================================================
-- STEP 4: SEED — Test Reporters
-- Three roles for the PoC demo flow:
--   Phone 1: Tenant who files the complaint
--   Phone 2: Hub Manager who receives and assigns
--   Phone 3: Maintenance Staff who resolves
-- =============================================================

INSERT INTO reporters (phone_number, name, hub_code)
VALUES
    ('TENANT_PHONE',  'Test Tenant',  'ALP'),   -- ← replace
    ('MANAGER_PHONE', 'Test Manager', 'ALP'),   -- ← replace
    ('STAFF_PHONE',   'Test Staff',   'ALP')    -- ← replace
ON CONFLICT (phone_number) DO NOTHING;


-- =============================================================
-- STEP 5: VERIFY
-- Run these selects after the inserts to confirm everything
-- landed correctly before moving on to NocoDB setup.
-- =============================================================

SELECT * FROM hubs;
SELECT * FROM reporters;

-- Should return 0 rows (tables created empty, ready for PoC)
SELECT COUNT(*) AS ticket_count     FROM tickets;
SELECT COUNT(*) AS fitout_count     FROM fitout_requests;
