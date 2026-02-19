import { describe, expect, it } from "vitest";
import { z } from "zod";
import { createErrorSummary } from "~/lib/zod-errors";

describe("Zod Error Utilities", () => {
  describe("createErrorSummary", () => {
    it("should create human-readable error summary", () => {
      const schema = z.object({
        email: z.string().email("Invalid email"),
        age: z.number().positive("Must be positive"),
      });

      const result = schema.safeParse({
        email: "invalid",
        age: -5,
      });

      if (!result.success) {
        const summary = createErrorSummary(result.error);
        expect(summary).toContain("email");
        expect(summary).toContain("age");
        expect(summary).toContain("Invalid email");
      }
    });

    it("should include form-level errors", () => {
      const schema = z
        .object({ data: z.string() })
        .refine(() => false, { message: "Form validation failed" });

      const result = schema.safeParse({ data: "anything" });

      if (!result.success) {
        const summary = createErrorSummary(result.error);
        expect(summary).toContain("Form validation failed");
      }
    });
  });
});
