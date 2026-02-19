import { z } from "zod";

const MAX_LIMIT = 100;
const DEFAULT_LIMIT = 20;
const DEFAULT_OFFSET = 0;

export const paginationSchema = z.object({
  limit: z.coerce
    .number()
    .int()
    .positive()
    .max(MAX_LIMIT)
    .optional()
    .default(DEFAULT_LIMIT),
  offset: z.coerce
    .number()
    .int()
    .nonnegative()
    .optional()
    .default(DEFAULT_OFFSET),
});
export type Pagination = z.infer<typeof paginationSchema>;
