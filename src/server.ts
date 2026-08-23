import Fastify from "fastify";
import dotenv from "dotenv";
import { startScheduler } from "./scan/scheduler";

dotenv.config();

const PORT = process.env.PORT ? Number(process.env.PORT) : 3000;
const SUPABASE_URL = process.env.SUPABASE_URL || "";
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_KEY || process.env.SUPABASE_ANON_KEY || "";

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.warn("Missing SUPABASE_URL or SUPABASE_KEY in environment — database connectivity will be disabled until configured.");
}

const server = Fastify({ logger: true });

server.get("/", async () => ({ status: "ok", now: new Date().toISOString() }));

server.get("/health", async () => {
  return { status: "ok" };
});

server.get("/ready", async () => ({ ready: true }));

const schedulerHandle = SUPABASE_URL && SUPABASE_KEY ? startScheduler({ supabaseUrl: SUPABASE_URL, supabaseKey: SUPABASE_KEY }) : null;

const start = async () => {
  try {
    await server.listen({ port: PORT, host: "0.0.0.0" });
  } catch (err) {
    server.log.error(err);
    process.exit(1);
  }
};

start();

// Properly stop scheduler on SIGINT/SIGTERM
process.on("SIGINT", () => {
  schedulerHandle?.stop();
  process.exit(0);
});
process.on("SIGTERM", () => {
  schedulerHandle?.stop();
  process.exit(0);
});
