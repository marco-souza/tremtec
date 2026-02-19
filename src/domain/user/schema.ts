import { z } from "zod";
import { paginationSchema } from "~/domain/shared/pagination";
import { providerEnum } from "~/domain/shared/provider";

export const userSchema = z.strictObject({
  id: z.uuid(),
  name: z.string().default("Jane Doe"),
  login: z.string(),
  email: z.email(),
  provider: providerEnum,
  avatar: z.url(),
});
export type User = z.infer<typeof userSchema>;

// API DTOs

export const userIdParamSchema = userSchema.pick({ id: true });
export type UserIdParam = z.infer<typeof userIdParamSchema>;

export const createUserRequestSchema = userSchema.omit({ id: true });
export type CreateUserRequest = z.infer<typeof createUserRequestSchema>;

export const updateUserRequestSchema = createUserRequestSchema.partial();
export type UpdateUserRequest = z.infer<typeof updateUserRequestSchema>;

export const listUsersQuerySchema = paginationSchema.extend({
  provider: providerEnum.optional(),
});
export type ListUsersQuery = z.infer<typeof listUsersQuerySchema>;
