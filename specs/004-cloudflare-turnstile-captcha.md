# Feature Specification: Cloudflare Turnstile CAPTCHA Validation

> **Note**: This is Phase 1 of the Spec-Driven Development process. After approval, proceed to Phase 2 (Implementation Plan) using `specs/000-implementation-plan-template.md`.

## Feature Name

Cloudflare Turnstile CAPTCHA Validation for Contact Form

## Objective

Add Cloudflare Turnstile CAPTCHA protection to the contact form to prevent spam and bot submissions while maintaining a smooth user experience with a non-intrusive challenge.

## User Story

As a website owner, I want to protect the contact form with CAPTCHA validation so that I can reduce spam and bot submissions.

As a user, I want to verify I'm human with a simple CAPTCHA so that I can submit the contact form securely.

## Functional Requirements

- The contact form must include a Cloudflare Turnstile widget rendered client-side
- Form submission must validate the CAPTCHA token server-side with Cloudflare's verification API
- Submission must be rejected if the CAPTCHA token is invalid or missing
- The CAPTCHA widget must be responsive and work on mobile and desktop devices
- Validation errors should display user-friendly messages
- The form should clear the CAPTCHA widget after successful submission
- Environment variables `TURNSTILE_SITE_KEY` and `TURNSTILE_SECRET_KEY` must be configured for different environments

## Success Criteria

- Users can successfully complete the CAPTCHA challenge and submit the form
- Bot submissions are blocked with appropriate error feedback
- The widget renders and functions on all supported browsers and devices
- Server-side validation rejects invalid or expired tokens
- Implementation follows Phoenix/Elixir best practices from AGENTS.md
- All error messages are properly internationalized (gettext)
- Form submission experience remains smooth without page reloads (LiveView)

## Notes

- Use `:req` library for HTTP requests to Cloudflare API (per project guidelines)
- Turnstile offers three challenge modes: Managed, Non-Interactive, and Invisible - determine which suits the UX requirements
- Consider rate limiting on failed CAPTCHA attempts
- Token expiration is 5 minutes by default in Cloudflare - handle accordingly
- Store Cloudflare credentials in `config/runtime.exs` as per deployment guidelines
