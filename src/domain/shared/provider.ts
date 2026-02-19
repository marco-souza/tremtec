import { z } from "zod";

export const providerEnum = z.enum(["github", "google"]);
export type Provider = z.infer<typeof providerEnum>;
