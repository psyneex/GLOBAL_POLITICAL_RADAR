import SourceAdapter from "./sourceAdapter";
import { CandidateDocument } from "../types";

/**
 * GDELT adapter (stub)
 * Real implementation should build targeted queries for tracked officials and
 * return normalized CandidateDocument items.
 */
export class GdeltAdapter implements SourceAdapter {
  constructor(private opts: { apiKey?: string } = {}) {}

  async fetch(fromTimestamp?: string): Promise<any[]> {
    // TODO: implement GDELT query logic limited to tracked officials
    return [];
  }

  normalize(raw: any): CandidateDocument[] | CandidateDocument {
    // TODO: map GDELT item(s) to CandidateDocument shape
    return {
      id: "",
      source_id: "",
      source_url: raw?.url ?? null,
      title: raw?.title ?? null,
      raw_text: raw?.content ?? "",
      retrieved_at: new Date().toISOString(),
      language: raw?.language ?? null
    } as CandidateDocument;
  }
}

export default GdeltAdapter;
