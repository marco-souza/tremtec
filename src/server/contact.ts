/**
 * Contact API Route
 */

import { zValidator } from "@hono/zod-validator";
import { Hono } from "hono";
import { ZodError } from "zod";
import { contactSchema } from "~/domain/contact/schema";
import { ContactService } from "~/domain/contact/service";

type Env = {
  Bindings: {
    EMAIL: SendEmail;
  };
};

export const contact = new Hono<Env>().post(
  "/",
  zValidator("json", contactSchema),
  async (c) => {
    const emailProvider = c.env?.EMAIL ?? {
      async send(args) {
        console.log("[email] sending email", args);
      },
    };

    try {
      const formData = c.req.valid("json");
      const service = new ContactService(emailProvider);
      const result = await service.submitContact(formData);

      return c.json({ ...result, dev: !c.env?.EMAIL });
    } catch (error) {
      if (error instanceof ZodError) {
        console.error("Invalid form data:", error);
        return c.json(
          { error: "Invalid form data", details: error.issues },
          400,
        );
      }

      console.error("Contact error:", error);
      return c.json({ error: "Failed to process submission" }, 500);
    }
  },
);
