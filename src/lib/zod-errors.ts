import type { ZodError } from "zod";

/**
 * Flattens a Zod error into field errors and form-level errors.
 */
export interface FlattenedError {
  formErrors: string[];
  fieldErrors: Record<string, string[]>;
}

/**
 * Creates a user-friendly error summary from Zod issues.
 */
export function createErrorSummary(error: ZodError): string {
  const flattened = error.flatten();
  const parts: string[] = [];

  // Add field errors
  for (const [field, messages] of Object.entries(
    flattened.fieldErrors as Record<string, string[]>,
  )) {
    messages.forEach((msg) => {
      parts.push(`${field}: ${msg}`);
    });
  }

  // Add form errors
  flattened.formErrors.forEach((msg) => {
    parts.push(msg);
  });

  return parts.join(". ");
}
