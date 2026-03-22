import { beforeEach, describe, expect, it, vi } from "vitest";
import { CONTACT_EMAIL, SERVICE_OPTIONS } from "./constants";
import type { ContactForm } from "./schema";
import { ContactService } from "./service";

const mockSendEmail = {
  send: vi.fn(),
};

describe("ContactService", () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  describe("submitContact", () => {
    it("should send email with correct payload", async () => {
      const service = new ContactService(mockSendEmail);
      const form: ContactForm = {
        name: "John Doe",
        email: "john@example.com",
        company: "Acme Corp",
        message: "Hello, I need help with implementation.",
        service: SERVICE_OPTIONS[0],
      };

      mockSendEmail.send.mockResolvedValue({ success: true });

      const result = await service.submitContact(form);

      expect(result).toEqual({ success: true });
      expect(mockSendEmail.send).toHaveBeenCalledWith({
        subject: `New Inquiry: ${form.service} from ${form.name}`,
        to: CONTACT_EMAIL,
        text: expect.stringContaining("Subject:"),
        from: {
          name: form.name,
          email: form.email,
        },
      });
    });

    it("should build email body with all fields", async () => {
      const service = new ContactService(mockSendEmail);
      const form: ContactForm = {
        name: "Jane Doe",
        email: "jane@example.com",
        company: "TechCo",
        message: "This is a test message for diagnostics service.",
        service: "diagnostics",
      };

      mockSendEmail.send.mockResolvedValue({ success: true });

      await service.submitContact(form);

      const sentPayload = mockSendEmail.send.mock.calls[0][0];
      expect(sentPayload.text).toContain("From: Jane Doe <jane@example.com>");
      expect(sentPayload.text).toContain("Company: TechCo");
      expect(sentPayload.text).toContain("Service: diagnostics");
      expect(sentPayload.text).toContain("Message:");
      expect(sentPayload.text).toContain(
        "This is a test message for diagnostics service.",
      );
    });

    it("should omit company line when not provided", async () => {
      const service = new ContactService(mockSendEmail);
      const form: ContactForm = {
        name: "Bob Smith",
        email: "bob@example.com",
        message: "No company here, just contact.",
        service: "mentoring",
      };

      mockSendEmail.send.mockResolvedValue({ success: true });

      await service.submitContact(form);

      const sentPayload = mockSendEmail.send.mock.calls[0][0];
      expect(sentPayload.text).not.toContain("Company:");
      expect(sentPayload.text).toContain("From: Bob Smith <bob@example.com>");
    });

    it("should handle all service options", async () => {
      const service = new ContactService(mockSendEmail);
      mockSendEmail.send.mockResolvedValue({ success: true });

      for (let i = 0; i < SERVICE_OPTIONS.length; i++) {
        const serviceOption = SERVICE_OPTIONS[i];
        const form: ContactForm = {
          name: "Test User",
          email: "test@example.com",
          message: `Testing service option: ${serviceOption}`,
          service: serviceOption,
        };

        await service.submitContact(form);

        const sentPayload = mockSendEmail.send.mock.calls[i][0];
        expect(sentPayload.subject).toContain(serviceOption);
      }
    });

    it("should propagate send errors", async () => {
      const service = new ContactService(mockSendEmail);
      const form: ContactForm = {
        name: "Error Test",
        email: "error@example.com",
        message: "This will cause an error.",
        service: "other",
      };

      const error = new Error("Email failed to send");
      mockSendEmail.send.mockRejectedValue(error);

      await expect(service.submitContact(form)).rejects.toThrow(
        "Email failed to send",
      );
    });
  });
});
