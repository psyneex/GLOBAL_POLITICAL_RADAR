export type CandidateDocument = {
  id: string;
  source_id: string;
  source_url?: string;
  source_name?: string;
  title?: string;
  raw_text: string;
  published_at?: string | null;
  retrieved_at: string;
  language?: string | null;
  author?: string | null;
  metadata?: Record<string, any> | null;
};

export type EventRecord = {
  id?: string;
  country_id?: string | null;
  official_id?: string | null;
  organization_id?: string | null;
  official_name_snapshot?: string | null;
  official_position_snapshot?: string | null;
  source_id?: string | null;
  source_url?: string | null;
  source_name?: string | null;
  original_text: string;
  original_language?: string | null;
  english_translation?: string | null;
  published_at?: string | null;
  detected_at?: string;
  created_at?: string;
  latitude?: number | null;
  longitude?: number | null;
  event_fingerprint?: string;
  provenance_type?: string | null;
  source_trust_level?: string | null;
};
