/**
 * HTMX Utility Helpers
 * Detects HTMX requests and provides response helpers
 */

import type { Context } from "hono";

/**
 * Check if the incoming request is an HTMX request
 */
export const isHtmxRequest = (c: Context): boolean => {
  return c.req.header("HX-Request") === "true";
};

/**
 * Get the HTMX target element id
 */
export const getHtmxTarget = (c: Context): string | undefined => {
  return c.req.header("HX-Target");
};

/**
 * Get the HTMX trigger element id
 */
export const getHtmxTrigger = (c: Context): string | undefined => {
  return c.req.header("HX-Trigger");
};
