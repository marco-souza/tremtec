# Feature Specification: Contact Page (/contact) via LiveView

## Feature Name

Contact Page LiveView Implementation

## Objective

Implement a modern, interactive Contact page at `/contact` using Phoenix LiveView, enabling users to submit inquiries or feedback through a responsive, real-time form.

## User Story

As a site visitor, I want to access a Contact page where I can submit my name, email, and message, so that I can easily reach out to the site administrators for support, feedback, or questions.

## Functional Requirements

- The Contact page is accessible at the `/contact` route.
- The page is implemented as a Phoenix LiveView for real-time validation and feedback.
- The form includes the following fields:
  - Name (required)
  - Email (required, must be a valid email format)
  - Message (required, minimum 10 characters)
- Real-time validation is provided as the user types.
- On successful submission:
  - The form is cleared.
  - A success message is displayed.
  - (Optional) The message is persisted or emailed to site admins.
- On validation errors, clear and actionable error messages are shown inline.
- The form uses the `<.form>` and `<.input>` components as per project guidelines.
- The page design follows Tailwind CSS v4 and project UI/UX standards, including responsive layout and micro-interactions (e.g., button hover, loading state).

## Non-Functional Requirements

- The page loads quickly and is responsive on all device sizes.
- No full-page reloads occur during form interaction or submission.
- All user input is sanitized and validated server-side.
- The implementation avoids external JS/CSS dependencies outside the app’s bundles.

## Success Criteria

- Users can successfully submit the contact form and receive confirmation.
- Invalid submissions are prevented, and users are informed of errors in real time.
- The page matches the app’s design system and provides a polished, modern user experience.
- All form interactions are covered by LiveView tests using element selectors and assertions.

## Assumptions

- Email delivery or message persistence is handled by existing or planned backend infrastructure.
- No authentication is required to access the Contact page.
- The LiveView is placed in the appropriate router scope and session for public access.

## Constraints

- Must use Phoenix LiveView and the project’s standard form and input components.
- Must not use deprecated or forbidden patterns (e.g., `live_redirect`, inline scripts, external form libraries).
- Must adhere to project’s Tailwind and UI/UX guidelines.

## Additional Notes

- Consider adding a simple spam prevention mechanism (e.g., honeypot field or rate limiting).
- Ensure accessibility best practices (labels, focus states, ARIA attributes).
- Provide clear feedback for both success and error states.
