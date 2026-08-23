GLOBAL POLITICAL RADAR - MVP / FOUNDATION

Purpose

A live geopolitical observation system that continuously monitors public sources for statements by high-ranking political/government officials and records them in Supabase. The core product loop and architectural constraints are specified in the project brief.

This repository contains a minimal Node.js + TypeScript backend scaffold and an initial Supabase SQL migration defining the core tables used by the scanner and ingestion pipeline.

Quickstart (backend)

1. Install dependencies: npm install
2. Create a .env file (see .env.example)
3. Start dev server: npm run dev

Notes

- The scaffold includes a SourceAdapter interface, a GDELT adapter stub, and a simple scheduler skeleton.
- The supabase/migrations/001_init.sql file contains the initial schema for countries, organizations, officials, sources, scan_runs, source_fetches, candidates, and events.
- This is deliberately minimal and designed to be extended when implementing adapters, verification, translation, deduplication, and realtime event emission.

Next recommended steps

- Configure Supabase project and run the SQL migration.
- Install dependencies and implement the first official source adapter(s).
- Implement targeted GDELT queries limited to tracked officials.
- Implement deterministic verification and statement extraction.

Contact

This session was created by an AI assistant using Copilot CLI runtime in VS Code.
