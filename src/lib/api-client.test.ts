import { testClient } from "hono/testing";
import { describe, expect, it, vi } from "vitest";

// Mock config so importing router.ts doesn't blow up on missing/invalid env vars
vi.mock("~/config", () => ({
  config: {
    BASE_URL: "http://localhost:4321",
    GITHUB_ID: "test-github-id",
    GITHUB_SECRET: "test-github-secret",
    GOOGLE_ID: "test-google-id",
    GOOGLE_SECRET: "test-google-secret",
    NODE_ENV: "test",
  },
}));

const { app } = await import("~/server/router");
const client = testClient(app);

describe("API server", () => {
  // ── Healthcheck ──────────────────────────────────────────────

  describe("GET /api/healthcheck", () => {
    it("returns ok status", async () => {
      const res = await client.api.healthcheck.$get();
      expect(res.status).toBe(200);
      expect(await res.json()).toEqual({ status: "ok" });
    });
  });

  // ── Auth ─────────────────────────────────────────────────────

  describe("GET /api/auth/logout", () => {
    it("redirects to login and clears session cookie", async () => {
      const res = await app.request("/api/auth/logout");
      expect(res.status).toBe(302);
      expect(res.headers.get("location")).toBe("/login");

      const setCookie = res.headers.get("set-cookie") ?? "";
      expect(setCookie).toContain("tremtec_session=");
      expect(setCookie).toContain("Max-Age=0");
    });
  });
});
