import { githubAuth } from "@hono/oauth-providers/github";
import { googleAuth } from "@hono/oauth-providers/google";
import { Hono } from "hono";
import { deleteCookie, setCookie } from "hono/cookie";
import { config } from "~/config";
import { SESSION_COOKIE_NAME } from "~/domain/auth/constants";
import { sessionDataSchema } from "~/domain/auth/schema";
import {
  extractOAuthUser,
  getSessionCookieConfig,
} from "~/domain/auth/service";
import { routes } from "./contants";

export const auth = new Hono()
  .use(
    "/github",
    githubAuth({
      client_id: config.GITHUB_ID,
      client_secret: config.GITHUB_SECRET,
      scope: ["user:email"],
      oauthApp: true,
    }),
  )
  .get("/github", (c) => {
    const token = c.get("token");
    const user = c.get("user-github");

    if (!user || !token) {
      return c.redirect(`${routes.public.login}?error=github_auth_failed`);
    }

    // Extract and normalize OAuth user data
    const extractedUser = extractOAuthUser("github", user);
    if (!extractedUser) {
      return c.redirect(`${routes.public.login}?error=github_auth_failed`);
    }

    // Create session with validated user data
    const sessionData = sessionDataSchema.parse({
      user: extractedUser,
      token: token.token,
    });

    const cookieConfig = getSessionCookieConfig();
    setCookie(c, SESSION_COOKIE_NAME, JSON.stringify(sessionData), {
      ...cookieConfig,
      secure: Boolean(import.meta.env.PROD),
      httpOnly: Boolean(import.meta.env.PROD),
    });

    return c.redirect(routes.private.dashboard);
  })
  .use(
    "/google",
    googleAuth({
      client_id: config.GOOGLE_ID,
      client_secret: config.GOOGLE_SECRET,
      scope: ["openid", "email", "profile"],
    }),
  )
  .get("/google", (c) => {
    const token = c.get("token");
    const user = c.get("user-google");

    if (!user || !token) {
      return c.redirect(`${routes.public.login}?error=google_auth_failed`);
    }

    // Extract and normalize OAuth user data
    const extractedUser = extractOAuthUser("google", user);
    if (!extractedUser) {
      return c.redirect(`${routes.public.login}?error=google_auth_failed`);
    }

    // Create session with validated user data
    const sessionData = sessionDataSchema.parse({
      user: extractedUser,
      token: token.token,
    });

    const cookieConfig = getSessionCookieConfig();
    setCookie(c, SESSION_COOKIE_NAME, JSON.stringify(sessionData), {
      ...cookieConfig,
      secure: Boolean(import.meta.env.PROD),
      httpOnly: Boolean(import.meta.env.PROD),
    });

    return c.redirect(routes.private.dashboard);
  })
  .get("/logout", (c) => {
    const cookieConfig = getSessionCookieConfig();
    deleteCookie(c, SESSION_COOKIE_NAME, {
      ...cookieConfig,
      maxAge: 0,
      secure: Boolean(import.meta.env.PROD),
      httpOnly: Boolean(import.meta.env.PROD),
    });

    return c.redirect(routes.public.login);
  });
