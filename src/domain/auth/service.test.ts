import { describe, expect, it } from "vitest";
import { MAX_SESSION_AGE, SESSION_COOKIE_NAME } from "~/domain/auth/constants";
import {
  extractOAuthUser,
  getSessionCookieConfig,
} from "~/domain/auth/service";

describe("Auth Service", () => {
  describe("extractOAuthUser", () => {
    it("should extract GitHub user from OAuth payload", () => {
      const payload = {
        login: "johndoe",
        name: "John Doe",
        email: "john@github.com",
        avatar_url: "https://avatars.githubusercontent.com/u/123456?v=4",
      };

      const user = extractOAuthUser("github", payload);

      expect(user).toEqual({
        name: "John Doe",
        login: "johndoe",
        email: "john@github.com",
        provider: "github",
        avatar: "https://avatars.githubusercontent.com/u/123456?v=4",
      });
    });

    it("should extract Google user from OAuth payload", () => {
      const payload = {
        name: "Jane Doe",
        email: "jane@gmail.com",
        picture: "https://example.com/jane.jpg",
      };

      const user = extractOAuthUser("google", payload);

      expect(user).toEqual({
        name: "Jane Doe",
        login: "jane",
        email: "jane@gmail.com",
        provider: "google",
        avatar: "https://example.com/jane.jpg",
      });
    });

    it("should handle GitHub user without name", () => {
      const payload = {
        login: "johndoe",
        email: "john@github.com",
        avatar_url: "https://avatars.githubusercontent.com/u/123456?v=4",
      };

      const user = extractOAuthUser("github", payload);

      expect(user?.name).toBe("johndoe");
    });

    it("should handle Google user without name", () => {
      const payload = {
        email: "jane@gmail.com",
        picture: "https://example.com/jane.jpg",
      };

      const user = extractOAuthUser("google", payload);

      expect(user?.name).toBe("Google User");
      expect(user?.login).toBe("jane");
    });

    it("should return null for invalid provider", () => {
      const payload = { email: "test@example.com" };

      // biome-ignore lint/suspicious/noExplicitAny: Testing invalid provider
      const user = extractOAuthUser("invalid" as any, payload);

      expect(user).toBeNull();
    });

    it("should return null for invalid payload", () => {
      const payload = {
        login: "johndoe",
        email: "invalid-email",
        avatar_url: "not-a-url",
      };

      const user = extractOAuthUser("github", payload);

      expect(user).toBeNull();
    });
  });

  describe("getSessionCookieConfig", () => {
    it("should return correct cookie configuration", () => {
      const config = getSessionCookieConfig();

      expect(config.name).toBe(SESSION_COOKIE_NAME);
      expect(config.maxAge).toBe(MAX_SESSION_AGE);
      expect(config.httpOnly).toBe(true);
      expect(config.secure).toBe(true);
      expect(config.sameSite).toBe("lax");
      expect(config.path).toBe("/");
    });

    it("should return fresh config each time", () => {
      const config1 = getSessionCookieConfig();
      const config2 = getSessionCookieConfig();

      expect(config1).toEqual(config2);
      expect(config1).not.toBe(config2);
    });
  });
});
