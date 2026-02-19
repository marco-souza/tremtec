import { hc } from "hono/client";
import type { AppType } from "~/server/router";

// Pre-compile the client type for better IDE performance
// See: https://hono.dev/docs/guides/rpc#compile-your-code-before-using-it-recommended
type Client = ReturnType<typeof hc<AppType>>;

export const hcWithType = (...args: Parameters<typeof hc>): Client =>
  hc<AppType>(...args);

export const apiClient = hcWithType("/api/");
