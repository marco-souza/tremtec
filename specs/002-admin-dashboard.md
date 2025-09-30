# Admin Dashboard Specification

## Feature Name

Admin Dashboard for Contact Messages

## Objective

Implement a secure, user-friendly Admin Dashboard within the Phoenix web application that allows authorized administrators to view and manage all messages received from the public contact page. The dashboard should leverage Phoenix's built-in authentication, CLI credential generation, and Ecto with SQLite for data persistence.

## User Story

As an administrator, I want to log in to a protected dashboard so that I can view all messages submitted via the contact form and efficiently manage user communications.

## Functional Requirements

- The dashboard must be accessible only to authenticated admin users.
- Admin credentials should be generated and managed using the Phoenix CLI tools.
- Ecto (using SQLite) must be used for all data persistence.
- Generate the necessary Ecto schema, migration, and context for storing contact messages (e.g., `ContactMessage` model with fields: name, email, message, inserted_at, read/unread status).
- Display a paginated, sortable list of all contact messages, including:
  - Sender name
  - Sender email
  - Message content (with truncation/expand option for long messages)
  - Date/time received
- Provide a detail view for each message.
- Indicate unread/new messages visually.
- Allow marking messages as read/unread.
- Support searching and filtering messages by sender, email, or date.
- The dashboard UI must use Tailwind CSS for a modern, responsive design.
- All data access must use Ecto queries with proper preloading if associations are added in the future.

## Non-Functional Requirements

- The dashboard must be protected against unauthorized access (authentication required).
- All sensitive data must be handled securely and never exposed to non-admin users.
- The UI should be responsive and accessible on desktop and mobile devices.
- The system should be performant for up to 10,000 messages.
- Follow Phoenix v1.8 and project-specific UI/UX guidelines.

## Success Criteria

- Only authenticated admins can access the dashboard.
- All contact messages are visible and manageable from the dashboard.
- Admins can search, filter, and view message details.
- The dashboard UI meets the project's design and usability standards.
- All requirements are covered by automated tests.
- Ecto models, migrations, and context modules are generated and used for message storage.

## Assumptions

- The contact form persists messages to a database table (e.g., `contact_messages`) using Ecto with SQLite.
- Admin users are managed via Phoenix's built-in authentication system.
- The Phoenix CLI is available for generating admin credentials, Ecto schemas, migrations, and scaffolding.

## Constraints

- No third-party admin UI frameworks (e.g., ActiveAdmin, daisyUI) may be used.
- All authentication and authorization must use Phoenix's built-in tools.
- Only the app's main CSS and JS bundles may be used for UI.
- Ecto must use SQLite as the database backend.

## Additional Notes

- Consider adding future features such as message export, admin notifications, or reply functionality.
- Ensure all code follows project conventions and passes `mix precommit`.
- Use Phoenix generators (e.g., `mix phx.gen.schema`, `mix phx.gen.context`) to scaffold Ecto models and migrations for contact messages.
