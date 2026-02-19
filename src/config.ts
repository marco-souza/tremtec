import { z } from "zod";

const AppConfigSchema = z.object({
  BASE_URL: z.url(),

  // github
  GITHUB_ID: z.string().min(1),
  GITHUB_SECRET: z.string().min(1),

  // google
  GOOGLE_ID: z.string().min(1),
  GOOGLE_SECRET: z.string().min(1),

  // optional
  NODE_ENV: z.string().optional().default("development"),
});

export const config = AppConfigSchema.parse(process.env);
