import { MAX_SESSION_AGE, SESSION_COOKIE_NAME } from "~/domain/auth/constants";
import { type UserSession, userSessionSchema } from "~/domain/auth/schema";
import type { Provider } from "~/domain/shared/provider";

/**
 * Extracts normalized user data from an OAuth provider payload.
 * Each provider returns different fields, so this normalizes to our schema.
 */
export function extractOAuthUser(
  provider: Provider,
  payload: Record<string, unknown>,
): UserSession | null {
  try {
    switch (provider) {
      case "github": {
        const user = userSessionSchema.parse({
          name: payload.name || payload.login || "GitHub User",
          login: payload.login,
          email: payload.email,
          provider: "github",
          avatar: payload.avatar_url,
        });
        return user;
      }

      case "google": {
        const user = userSessionSchema.parse({
          name: payload.name || "Google User",
          login: payload.email?.split("@")[0] || "user",
          email: payload.email,
          provider: "google",
          avatar: payload.picture,
        });
        return user;
      }

      default:
        return null;
    }
  } catch {
    return null;
  }
}

/**
 * Gets the session cookie configuration object.
 */
export function getSessionCookieConfig() {
  return {
    name: SESSION_COOKIE_NAME,
    maxAge: MAX_SESSION_AGE,
    httpOnly: true,
    secure: true,
    sameSite: "lax" as const,
    path: "/",
  };
}
