import Fastify from "fastify";
import { createClient } from "@supabase/supabase-js";

// Small scheduler skeleton that will run a scan cycle every 60s.
// It queries the "sources" table to find active sources that are due
// and should call their adapters to fetch/normalize candidates.

export function startScheduler(opts: { supabaseUrl: string; supabaseKey: string }) {
  const supabase = createClient(opts.supabaseUrl, opts.supabaseKey);
  const intervalSeconds = 60;

  async function scanCycle() {
    const startedAt = new Date().toISOString();
    console.log(`[scan] starting cycle at ${startedAt}`);

    try {
      // TODO: query active sources that are due using poll_interval_seconds
      // Example (pseudocode): SELECT * FROM sources WHERE active = true AND (last_checked_at IS NULL OR last_checked_at + poll_interval_seconds <= now());

      // For now, just record a scan_run row to the database to illustrate auditing (left as TODO)
      // const { data, error } = await supabase.from('scan_runs').insert({ started_at: startedAt });

    } catch (err) {
      console.error('[scan] error during cycle', err);
    }

    console.log(`[scan] completed cycle at ${new Date().toISOString()}`);
  }

  // Start immediately, then every interval
  scanCycle();
  const timer = setInterval(scanCycle, intervalSeconds * 1000);

  return {
    stop: () => clearInterval(timer)
  };
}
