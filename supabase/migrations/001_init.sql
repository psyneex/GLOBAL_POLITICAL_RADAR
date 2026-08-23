-- Initial schema for GLOBAL POLITICAL RADAR
-- Designed for Supabase (Postgres)

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Countries
CREATE TABLE IF NOT EXISTS countries (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  iso2 char(2),
  iso3 char(3),
  created_at timestamptz DEFAULT now()
);

-- Organizations (ministries, offices)
CREATE TABLE IF NOT EXISTS organizations (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  country_id uuid REFERENCES countries(id) ON DELETE SET NULL,
  name text NOT NULL,
  created_at timestamptz DEFAULT now()
);

-- Officials
CREATE TABLE IF NOT EXISTS officials (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  country_id uuid REFERENCES countries(id) ON DELETE SET NULL,
  organization_id uuid REFERENCES organizations(id) ON DELETE SET NULL,
  name text NOT NULL,
  position text NOT NULL,
  active boolean DEFAULT true,
  latitude double precision,
  longitude double precision,
  notes text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Sources registry
CREATE TYPE source_type_enum AS ENUM ('official_rss','official_web','official_api','gdelt','google_news_rss','other_discovery');
CREATE TYPE trust_level_enum AS ENUM ('primary','secondary','discovery');

CREATE TABLE IF NOT EXISTS sources (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  official_id uuid REFERENCES officials(id) ON DELETE SET NULL,
  country_id uuid REFERENCES countries(id) ON DELETE SET NULL,
  source_name text,
  source_url text,
  source_type source_type_enum,
  trust_level trust_level_enum,
  poll_interval_seconds integer DEFAULT 300,
  last_checked_at timestamptz,
  last_success_at timestamptz,
  status text,
  active boolean DEFAULT true,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Scan run audit
CREATE TABLE IF NOT EXISTS scan_runs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  started_at timestamptz DEFAULT now(),
  completed_at timestamptz,
  status text,
  sources_checked integer DEFAULT 0,
  candidates_found integer DEFAULT 0,
  events_created integer DEFAULT 0,
  duplicates_found integer DEFAULT 0,
  errors integer DEFAULT 0,
  metadata jsonb
);

-- Source fetch audit
CREATE TABLE IF NOT EXISTS source_fetches (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  scan_run_id uuid REFERENCES scan_runs(id) ON DELETE SET NULL,
  source_id uuid REFERENCES sources(id) ON DELETE SET NULL,
  started_at timestamptz DEFAULT now(),
  completed_at timestamptz,
  status text,
  items_found integer DEFAULT 0,
  error_message text,
  raw_response jsonb
);

-- Candidates (normalized documents, kept for auditing)
CREATE TABLE IF NOT EXISTS candidates (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  source_id uuid REFERENCES sources(id) ON DELETE SET NULL,
  source_url text,
  source_name text,
  title text,
  raw_text text,
  published_at timestamptz,
  retrieved_at timestamptz DEFAULT now(),
  language text,
  author text,
  metadata jsonb,
  created_at timestamptz DEFAULT now()
);

-- Events (immutable political statements)
CREATE TABLE IF NOT EXISTS events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  country_id uuid REFERENCES countries(id) ON DELETE SET NULL,
  official_id uuid REFERENCES officials(id) ON DELETE SET NULL,
  organization_id uuid REFERENCES organizations(id) ON DELETE SET NULL,
  official_name_snapshot text,
  official_position_snapshot text,
  source_id uuid REFERENCES sources(id) ON DELETE SET NULL,
  source_url text,
  source_name text,
  original_text text NOT NULL,
  original_language text,
  english_translation text,
  published_at timestamptz,
  detected_at timestamptz DEFAULT now(),
  created_at timestamptz DEFAULT now(),
  latitude double precision,
  longitude double precision,
  event_fingerprint text,
  provenance_type text,
  source_trust_level trust_level_enum,
  metadata jsonb
);

-- Deduplication index / uniqueness on event_fingerprint when present
CREATE UNIQUE INDEX IF NOT EXISTS events_event_fingerprint_unique ON events(event_fingerprint) WHERE event_fingerprint IS NOT NULL;

-- Basic indexes
CREATE INDEX IF NOT EXISTS idx_events_published_at ON events(published_at);
CREATE INDEX IF NOT EXISTS idx_candidates_retrieved_at ON candidates(retrieved_at);

-- End of migration
