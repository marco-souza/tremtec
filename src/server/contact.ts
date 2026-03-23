/**
 * Contact API Route
 */

import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { ZodError } from "zod";
import { contactSchema } from "~/domain/contact/schema";
import { ContactService } from "~/domain/contact/service";
import { isHtmxRequest } from "~/lib/htmx";
import { contactContent } from "~/ui/contents/contact";

type Env = {
  Bindings: {
    EMAIL: SendEmail;
  };
};

function buildFieldErrorsHtml(fieldErrors: Record<string, string[]>): string {
  const errorParts: string[] = [
    '<div class="alert alert-error mb-4">Please correct the errors below</div>',
  ];

  for (const [field, messages] of Object.entries(fieldErrors)) {
    const errorId = `${field}-error`;
    const message = messages.join(". ");
    errorParts.push(
      `<div id="${errorId}" hx-swap-oob="true" class="text-error text-sm mt-1">${message}</div>`,
    );
  }

  return errorParts.join("");
}

function buildSuccessHtml(message: string): string {
  return `<div class="alert alert-success">${message}</div>`;
}

function buildRetryErrorHtml(message: string): string {
  return `<div class="alert alert-warning">
    <span>${message}</span>
    <button type="button" class="btn btn-sm btn-ghost" onclick="document.getElementById('contact-form').reset(); htmx.trigger('#contact-form', 'reset')">
      Retry
    </button>
  </div>`;
}

export const contact = new Hono<Env>().post(
  "/",
  zValidator("form", contactSchema),
  async (c) => {
    const emailProvider = c.env?.EMAIL ?? {
      async send(args) {
        console.log("[email] sending email", args);
      },
    };

    try {
      const formData = c.req.valid("form");
      const service = new ContactService(emailProvider);
      const result = await service.submitContact(formData);

      console.log("[email] submit contact result", result);

      if (isHtmxRequest(c)) {
        return c.html(buildSuccessHtml(contactContent.form.success));
      }
      return c.json({ success: true, dev: !c.env?.EMAIL });
    } catch (error) {
      if (error instanceof ZodError) {
        console.error("Invalid form data:", error);

        if (isHtmxRequest(c)) {
          const fieldErrors = error.issues.reduce(
            (acc, issue) => {
              const path = issue.path[0] as string;
              if (!acc[path]) {
                acc[path] = [];
              }
              acc[path].push(issue.message);
              return acc;
            },
            {} as Record<string, string[]>,
          );

          return c.html(buildFieldErrorsHtml(fieldErrors), 400);
        }

        return c.json(
          { error: "Invalid form data", details: error.issues },
          400,
        );
      }

      console.error("Contact error:", error);
      if (isHtmxRequest(c)) {
        return c.html(buildRetryErrorHtml(contactContent.form.error), 500);
      }
      return c.json({ error: "Failed to process submission" }, 500);
    }
  },
);
