/**
 * Contact Service
 */

import { CONTACT_EMAIL } from "./constants";
import type { ContactForm } from "./schema";

export class ContactService {
  constructor(private sendEmail: SendEmail) {}

  async submitContact(form: ContactForm) {
    const payload = this.buildEmailPayload(form);
    console.log("[contact] submit contact payload", { payload });
    const sendResult = await this.sendEmail.send({
      subject: payload.subject,
      to: CONTACT_EMAIL,
      text: payload.body,
      from: {
        name: form.name,
        email: form.email,
      },
    });
    console.log("[contact] email sent", { sendResult });

    return sendResult;
  }

  private buildEmailPayload(data: ContactForm) {
    const subject = `New Inquiry: ${data.service} from ${data.name}`;
    const body = [
      `Subject: ${subject}`,
      `From: ${data.name} <${data.email}>`,
      data.company ? `Company: ${data.company}` : "",
      `Service: ${data.service}`,
      "",
      "Message:",
      data.message,
    ]
      .filter(Boolean)
      .join("\n");

    return { subject, body, replyTo: data.email };
  }
}
