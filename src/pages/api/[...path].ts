import type { APIRoute } from "astro";
import { app } from "~/server/router";

export const prerender = false;

// pass requests to Hono backend
export const ALL: APIRoute = (context) => app.fetch(context.request);
