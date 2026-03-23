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
      const res = await client.api.auth.logout.$get();
      expect(res.status).toBe(302);
      expect(res.headers.get("location")).toBe("/login");

      const setCookie = res.headers.get("set-cookie") ?? "";
      expect(setCookie).toContain("tremtec_session=");
      expect(setCookie).toContain("Max-Age=0");
    });
  });

  // ── Contact ──────────────────────────────────────────────────

  describe("POST /api/contact", () => {
    it("accepts POST requests at the endpoint", async () => {
      const res = await app.request("/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          name: "Test User",
          email: "test@example.com",
          service: "implementation",
          message:
            "This is a test message with sufficient length for validation.",
        }),
      });

      // Should not be 404 (endpoint exists)
      expect(res.status).not.toBe(404);
      // Should either succeed or fail with validation/error (not method not allowed)
      expect(res.status).not.toBe(405);
    });

    it("returns 404 for GET requests (no GET route defined)", async () => {
      const res = await app.request("/api/contact");
      expect(res.status).toBe(404);
    });

    it("rejects invalid JSON payloads", async () => {
      const res = await app.request("/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: "not valid json",
      });

      expect(res.status).toBe(400);
    });

    it("validates required fields", async () => {
      const res = await app.request("/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          name: "", // Empty name
          email: "invalid-email", // Invalid email
          service: "invalid-service", // Invalid service type
          message: "short", // Too short
        }),
      });

      expect(res.status).toBe(400);
      const body = await res.json();
      expect(body).toHaveProperty("error");
    });

    it("accepts valid form data structure", async () => {
      const res = await app.request("/api/contact", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams({
          name: "John Doe",
          email: "john@example.com",
          company: "Test Company",
          service: "implementation",
          message:
            "This is a valid test message with sufficient length to pass validation rules.",
        }),
      });

      // Should either succeed (200) or fail due to missing Resend config (500)
      // but should NOT fail validation (400)
      expect(res.status).toBeGreaterThanOrEqual(200);
      expect(res.status).not.toBe(400);
    });
  });
});
