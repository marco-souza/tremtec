import { SESSION_COOKIE_NAME } from "~/domain/auth/constants";
import { sessionDataSchema } from "~/domain/auth/schema";
import { isPrivateRoute, routes } from "~/server/contants";
import { defineMiddleware, sequence } from "astro:middleware";

// Define a simple logging middleware
const loggingMiddleware = defineMiddleware(async (context, next) => {
  console.log(`Intercepted request to: ${context.url.pathname}`);

  const response = await next();

  console.log("Page rendered. Returning response...");
  return response;
});

// You can define other middleware functions (e.g., for auth) and chain them
const authMiddleware = defineMiddleware(async (context, next) => {
  context.locals.title = "New title";

  const sessionRawData = context.cookies.get(SESSION_COOKIE_NAME);
  if (sessionRawData?.value) {
    const possibleSession = JSON.parse(sessionRawData.value);
    const session = sessionDataSchema.safeParse(possibleSession);
    if (session.success) {
      context.locals.user = session.data.user;
    }
  }

  const pathname = context.url.pathname;
  if (isPrivateRoute(pathname) && context.locals.user === undefined) {
    return context.redirect(routes.public.login);
  }

  if (pathname.startsWith(routes.public.login) && context.locals.user) {
    return context.redirect(routes.private.dashboard);
  }

  return next();
});

// Export the sequence of middleware functions
export const onRequest = sequence(loggingMiddleware, authMiddleware);
