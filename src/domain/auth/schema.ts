import { z } from "zod";
import { providerEnum } from "~/domain/shared/provider";

export const userSessionSchema = z.strictObject({
  name: z.string().default("Jane Doe"),
  login: z.string(),
  email: z.email(),
  provider: providerEnum,
  avatar: z.url(),
});
export type UserSession = z.infer<typeof userSessionSchema>;

export const sessionDataSchema = z.strictObject({
  user: userSessionSchema,
  token: z.string(),
});
export type SessionData = z.infer<typeof sessionDataSchema>;
