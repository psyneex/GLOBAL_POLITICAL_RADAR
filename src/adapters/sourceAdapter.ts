import { CandidateDocument } from "../types";

export interface SourceAdapter {
  // Fetch raw items from the source (network calls, RSS, API, etc.)
  fetch(fromTimestamp?: string): Promise<any[]>;

  // Convert a raw source item into the normalized CandidateDocument shape
  normalize(raw: any): CandidateDocument[] | CandidateDocument;
}

// Example placeholder export to make it easy to scaffold implementations
export default SourceAdapter;
