import { Hono } from "hono";
import { auth } from "./auth";
import { health } from "./health";

export const app = new Hono()
  .basePath("/api")
  .route("/auth", auth)
  .route("/healthcheck", health);

export type AppType = typeof app;
