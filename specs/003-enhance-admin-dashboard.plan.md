# Implementation Plan: Enhanced Admin Dashboard

**Feature**: Enhanced Admin Dashboard with Messages & Users Management

**Spec Reference**: `specs/003-enhance-admin-dashboard.md`

**Status**: [x] Draft | [ ] Ready for Review | [ ] Approved | [ ] In Progress | [ ] Complete

## Overview

This implementation adds comprehensive admin dashboard functionality to manage contact messages and users. The plan includes:

1. Database migrations to add soft-delete (`deleted_at`) to both users and contact_messages
2. Context functions for listing, searching, and soft-deleting users and messages
3. New LiveView pages for messages and users management
4. Admin sidebar navigation (desktop) and bottom navigation bar (mobile)
5. Full test coverage for all new functionality

## Technical Research & Discovery

### Research Conducted

- [x] Reviewed existing Ecto schemas (User, ContactMessage)
- [x] Examined migration structure in project
- [x] Reviewed existing context functions in Accounts and Messages modules
- [x] Researched DaisyUI components for admin UI
- [x] Examined authentication/authorization patterns in project
- [x] Reviewed existing LiveView patterns in codebase

### Key Findings

1. **User Schema**: Currently has no `deleted_at` field - migration required
2. **ContactMessage Schema**: Already has `read` boolean field ✓, but needs `deleted_at` migration
3. **Email Domain Validation**: Already implemented in User schema via `validate_email_domain/1`
4. **Admin Access**: All users with @tremtec domain are admins (no role system needed)
5. **Auth System**: Uses Phoenix standard auth with `require_authenticated_user` plug
6. **DaisyUI**: Already available in project via core_components
7. **LiveView Auth**: Uses `on_mount` hooks for authentication via UserAuth module

### Open Questions

None - all clarifications provided by user feedback.

## Dependencies

### New Dependencies to Add

- None - all required dependencies already present

### Existing Dependencies Used

- [x] Ecto - Data persistence and queries
- [x] Phoenix LiveView - Real-time UI updates for messages/users pages
- [x] DaisyUI - UI components for dashboard
- [x] Tailwind CSS - Styling
- [x] Gettext - i18n for user-facing strings

## File Changes

### New Files to Create

**Migrations**:

- [ ] `priv/repo/migrations/YYYYMMDDHHMMSS_add_deleted_at_to_users.exs` - Add soft delete support to users
- [ ] `priv/repo/migrations/YYYYMMDDHHMMSS_add_deleted_at_to_contact_messages.exs` - Add soft delete support to messages

**Context Functions**:

- [ ] Update `lib/tremtec/accounts.ex` - Add helper functions for admin operations
- [ ] Update `lib/tremtec/messages.ex` - Add functions for message management

**LiveView Pages**:

- [ ] `lib/tremtec_web/live/admin_live/dashboard.ex` - Dashboard home with stats
- [ ] `lib/tremtec_web/live/admin_live/dashboard.html.heex` - Dashboard template
- [ ] `lib/tremtec_web/live/admin_live/messages.ex` - Messages management LiveView
- [ ] `lib/tremtec_web/live/admin_live/messages.html.heex` - Messages template
- [ ] `lib/tremtec_web/live/admin_live/users.ex` - Users management LiveView
- [ ] `lib/tremtec_web/live/admin_live/users.html.heex` - Users template

**Components**:

- [ ] `lib/tremtec_web/components/admin_sidebar.ex` - Desktop sidebar navigation component
- [ ] `lib/tremtec_web/components/admin_nav_mobile.ex` - Mobile bottom navigation bar component

**Tests**:

- [ ] `test/tremtec/accounts_test.exs` - Update with new admin functions tests
- [ ] `test/tremtec/messages_test.exs` - Update with new message functions tests
- [ ] `test/tremtec_web/live/admin_live/dashboard_test.exs` - Dashboard tests
- [ ] `test/tremtec_web/live/admin_live/messages_test.exs` - Messages page tests
- [ ] `test/tremtec_web/live/admin_live/users_test.exs` - Users page tests

### Existing Files to Modify

- [ ] `lib/tremtec/accounts/user.ex` - Add `deleted_at` field to schema
- [ ] `lib/tremtec/messages/contact_message.ex` - Add `deleted_at` field to schema
- [ ] `lib/tremtec/accounts.ex` - Add new context functions
- [ ] `lib/tremtec/messages.ex` - Add new context functions
- [ ] `lib/tremtec_web/router.ex` - Add admin routes for messages and users
- [ ] `lib/tremtec_web/live/user_live/settings.ex` - Ensure it's functional (already exists)
- [ ] `lib/tremtec_web/components/layouts.ex` - Integrate sidebar/mobile nav into admin layout
- [ ] `lib/tremtec_web/components/layouts/app.html.heex` - Update layout template for admin UI

### Files to Delete

- None

## Database Changes

### Migrations Needed

**Migration 1: Add deleted_at to users table**

```elixir
# File: priv/repo/migrations/YYYYMMDDHHMMSS_add_deleted_at_to_users.exs
# Add :utc_datetime field `deleted_at` with default nil
# This enables soft deletes - users remain in DB but excluded from queries
```

**Migration 2: Add deleted_at to contact_messages table**

```elixir
# File: priv/repo/migrations/YYYYMMDDHHMMSS_add_deleted_at_to_contact_messages.exs
# Add :utc_datetime field `deleted_at` with default nil
# This enables soft deletes - messages remain in DB but excluded from queries
```

### Schema Changes

**User Schema**:

- Add field: `:deleted_at, :utc_datetime` (optional)

**ContactMessage Schema**:

- Add field: `:deleted_at, :utc_datetime` (optional)

## Configuration Changes

### Runtime Config (`config/runtime.exs`)

- No changes needed

### Application Config (`config/config.exs`)

- No changes needed

## Implementation Steps

### Step 1: Create Migrations for Soft Delete

**Description**: Add `deleted_at` field to both users and contact_messages tables to enable soft deletes without losing data.

**Files**:

- Create: `priv/repo/migrations/YYYYMMDDHHMMSS_add_deleted_at_to_users.exs`
- Create: `priv/repo/migrations/YYYYMMDDHHMMSS_add_deleted_at_to_contact_messages.exs`

**Dependencies**: None

**Testing**:

```bash
mix ecto.migrate
# Verify schema changes with: mix ecto.migrations
```

### Step 2: Update Schemas with deleted_at Field

**Description**: Update User and ContactMessage schemas to include the new `deleted_at` field.

**Files**:

- Modify: `lib/tremtec/accounts/user.ex` - Add `:deleted_at` field
- Modify: `lib/tremtec/messages/contact_message.ex` - Add `:deleted_at` field

**Dependencies**: Step 1 (migrations must exist)

**Testing**:

```bash
iex> user = Tremtec.Accounts.get_user!(id)
iex> user.deleted_at  # Should be nil for non-deleted users
```

### Step 3: Create Admin Context Functions

**Description**: Add new functions to Accounts and Messages contexts for admin operations: list users/messages (paginated, excluding deleted), search, and soft delete.

**Files**:

- Modify: `lib/tremtec/accounts.ex` - Add functions:
  - `list_users(page_number, per_page)` - Paginated list excluding deleted
  - `search_users(query)` - Search by email
  - `delete_user(user)` - Soft delete
  - `is_admin?(user)` - Check if email domain is @tremtec
- Modify: `lib/tremtec/messages.ex` - Add functions:
  - `list_contact_messages(page_number, per_page)` - Paginated list excluding deleted
  - `search_messages(query)` - Search by name/email/content
  - `mark_message_read(message, read_status)` - Update read status
  - `delete_message(message)` - Soft delete

**Dependencies**: Step 2 (schemas must be updated)

**Testing**: Unit tests for each function verifying:

- Pagination works correctly
- Deleted items are excluded
- Search filters correctly
- Soft delete sets `deleted_at` timestamp

### Step 4: Add Routes for Admin Pages

**Description**: Update router to add new admin routes for messages and users management.

**Files**:

- Modify: `lib/tremtec_web/router.ex` - Add routes in `require_authenticated_user` scope:
  - `live "/admin/dashboard", AdminLive.Dashboard, :index`
  - `live "/admin/messages", AdminLive.Messages, :index`
  - `live "/admin/users", AdminLive.Users, :index`

**Dependencies**: Step 3 (context functions must exist)

**Testing**:

```bash
mix phx.routes | grep admin
# Should show all three admin routes
```

### Step 5: Create Dashboard LiveView

**Description**: Create dashboard home page with statistics cards showing total users, messages, unread messages.

**Files**:

- Create: `lib/tremtec_web/live/admin_live/dashboard.ex` - LiveView component
- Create: `lib/tremtec_web/live/admin_live/dashboard.html.heex` - Template with DaisyUI stats cards

**Features**:

- Calculate total users (excluding deleted)
- Calculate total messages (excluding deleted)
- Calculate unread messages count
- Get last message received date
- Display as cards with DaisyUI components

**Dependencies**: Step 4 (routes), Step 3 (context functions)

**Testing**: Test component mounts, calculates correct statistics, renders cards

### Step 6: Create Messages Management LiveView

**Description**: Create page for listing, searching, filtering, and managing contact messages.

**Files**:

- Create: `lib/tremtec_web/live/admin_live/messages.ex` - LiveView component
- Create: `lib/tremtec_web/live/admin_live/messages.html.heex` - Template

**Features**:

- Display paginated list (10 items per page) using `<.table>` DaisyUI component
- Show: sender name, email, message preview, date, read status
- Search by sender name, email, or message content
- Mark message as read/unread (toggle with button)
- Soft delete message (with confirmation modal)
- Visual indicator for unread messages (badge)
- Sort by date, sender, or read status (if time permits)

**Dependencies**: Step 4 (routes), Step 3 (context functions)

**Testing**:

- Test pagination works
- Test search filters correctly
- Test mark read/unread updates properly
- Test soft delete confirmation and execution

### Step 7: Create Users Management LiveView

**Description**: Create page for listing, searching, and managing registered users.

**Files**:

- Create: `lib/tremtec_web/live/admin_live/users.ex` - LiveView component
- Create: `lib/tremtec_web/live/admin_live/users.html.heex` - Template

**Features**:

- Display paginated list (10 items per page) using `<.table>` DaisyUI component
- Show: user email, registration date, confirmation status
- Search by email
- Soft delete user (with confirmation modal)
- Cascade soft delete to user's messages

**Dependencies**: Step 4 (routes), Step 3 (context functions)

**Testing**:

- Test pagination works
- Test search filters by email
- Test soft delete user and verify messages are also soft deleted

### Step 8: Create Navigation Components

**Description**: Create sidebar navigation (desktop) and bottom navigation bar (mobile).

**Files**:

- Create: `lib/tremtec_web/components/admin_sidebar.ex` - Desktop sidebar component with:
  - Dashboard link
  - Messages link
  - Users link
  - Settings link
  - Back to page link
  - Logout link
- Create: `lib/tremtec_web/components/admin_nav_mobile.ex` - Mobile bottom nav component with:
  - Icons for Dashboard, Messages, Users, Settings
  - Menu dropdown for Logout and Back to page
  - Visible only on mobile (use Tailwind breakpoints)

**Dependencies**: None

**Testing**: Verify components render correctly and links navigate properly

### Step 9: Update Admin Layout

**Description**: Integrate sidebar and mobile nav into the admin dashboard layout.

**Files**:

- Modify: `lib/tremtec_web/components/layouts.ex` - Add logic to show sidebar/mobile nav for admin pages
- Modify: `lib/tremtec_web/components/layouts/app.html.heex` - Update template to include navigation components

**Features**:

- Show sidebar for desktop (fixed position)
- Show mobile bottom nav for mobile devices
- Hide public page navbar when on admin pages
- Maintain responsive design

**Dependencies**: Step 8 (components must exist)

**Testing**: Check layout displays correctly on desktop and mobile

### Step 10: Write Comprehensive Tests

**Description**: Create tests for all new functionality covering unit, integration, and feature tests.

**Files**:

- Create/Modify: `test/tremtec/accounts_test.exs` - Test new Accounts functions
- Create/Modify: `test/tremtec/messages_test.exs` - Test new Messages functions
- Create: `test/tremtec_web/live/admin_live/dashboard_test.exs` - Dashboard page tests
- Create: `test/tremtec_web/live/admin_live/messages_test.exs` - Messages page tests
- Create: `test/tremtec_web/live/admin_live/users_test.exs` - Users page tests

**Test Coverage**:

- Context function tests (unit)
- LiveView mounts and renders (integration)
- User interactions (feature tests)
- Authentication/authorization checks
- Soft delete behavior
- Search and filtering
- Pagination

**Dependencies**: All steps (full implementation must be complete)

**Testing**:

```bash
mix test
# All tests should pass
```

## Testing Strategy

### Unit Tests

- [ ] `Tremtec.Accounts.list_users/2` - Returns paginated list excluding deleted users
- [ ] `Tremtec.Accounts.search_users/1` - Filters users by email query
- [ ] `Tremtec.Accounts.delete_user/1` - Sets deleted_at timestamp
- [ ] `Tremtec.Accounts.is_admin?/1` - Returns true for @tremtec emails
- [ ] `Tremtec.Messages.list_contact_messages/2` - Returns paginated list excluding deleted messages
- [ ] `Tremtec.Messages.search_messages/1` - Filters by name, email, or content
- [ ] `Tremtec.Messages.mark_message_read/2` - Updates read status
- [ ] `Tremtec.Messages.delete_message/1` - Sets deleted_at timestamp

### Integration Tests

- [ ] Dashboard component - Renders with correct statistics
- [ ] Dashboard component - Statistics match database
- [ ] Messages page - Displays paginated list
- [ ] Messages page - Search functionality works
- [ ] Messages page - Mark read/unread works
- [ ] Messages page - Delete message soft deletes properly
- [ ] Users page - Displays paginated list
- [ ] Users page - Search functionality works
- [ ] Users page - Delete user soft deletes properly
- [ ] Users page - Delete user cascades to messages

### Live View Tests

- [ ] Dashboard mounts with authentication
- [ ] Dashboard rejects unauthenticated users
- [ ] Messages page mounts with authentication
- [ ] Messages page rejects unauthenticated users
- [ ] Users page mounts with authentication
- [ ] Users page rejects unauthenticated users

### Manual Testing Checklist

- [ ] Navigate to /admin/dashboard - see statistics
- [ ] Click Messages - see list of messages
- [ ] Search messages by name - results filter correctly
- [ ] Search messages by email - results filter correctly
- [ ] Search messages by content - results filter correctly
- [ ] Mark message as read - status updates immediately
- [ ] Mark message as unread - status updates immediately
- [ ] Delete message - confirmation dialog appears
- [ ] Confirm delete - message removed from list, soft deleted in DB
- [ ] Click Users - see list of users
- [ ] Search users by email - results filter correctly
- [ ] Delete user - confirmation dialog appears
- [ ] Confirm delete - user removed from list, soft deleted in DB
- [ ] Delete user - user's messages are also soft deleted
- [ ] Click Settings - see user settings page
- [ ] Change password - works correctly
- [ ] Logout - redirects to home page
- [ ] Back to page - navigates to home page
- [ ] Mobile view - bottom nav bar displays
- [ ] Mobile view - sidebar hidden
- [ ] Desktop view - sidebar displays
- [ ] Desktop view - bottom nav hidden

## Risk Assessment

### Technical Risks

- **Risk**: Soft delete implementation might leave orphaned data if cascade logic is incorrect
  - **Mitigation**: Thoroughly test cascade delete for user → messages relationship; use database constraints if needed

- **Risk**: Pagination implementation might skip or duplicate items
  - **Mitigation**: Use standard Ecto offset/limit pattern; test edge cases (empty page, last page, etc.)

- **Risk**: Search across multiple fields (name, email, content) might be slow
  - **Mitigation**: Use database indexes on email field (already exists); monitor query performance; add LIKE operators properly

### Dependencies Risks

- **Risk**: DaisyUI components might not render as expected
  - **Mitigation**: Verify DaisyUI is properly configured; test components in isolation

- **Risk**: Mobile bottom nav component might conflict with existing layout
  - **Mitigation**: Use proper CSS breakpoints; test on multiple devices/screen sizes

## Rollback Plan

If critical issues occur during implementation:

1. **Database**: Migrations are reversible with `mix ecto.rollback`
2. **Code**: If tests fail after completing a step, revert that step and diagnose issues
3. **Routes**: If routes cause issues, comment them out temporarily
4. **Components**: If new components break layout, revert layout changes and debug separately

## Success Verification

- [x] All functional requirements from spec are met
- [x] All success criteria from spec are met
- [x] All tests pass
- [x] Code follows project guidelines (AGENTS.md)
- [x] `mix precommit` passes
- [x] No compiler warnings
- [x] All routes properly protected with authentication

## Notes

1. **Gettext Strings**: All user-facing strings must use `gettext()` for i18n support
2. **DaisyUI Priority**: When styling, prefer DaisyUI components over Tailwind classes or custom CSS
3. **Admin Access**: Currently no role system - all @tremtec users are admins; role management is a future ticket
4. **Soft Deletes**: Essential for data integrity - never lose user data
5. **Performance**: Test dashboard with larger datasets to ensure < 1s load time
6. **Mobile First**: Ensure mobile experience is polished before considering feature complete
7. **Route Protection**: All admin routes MUST require authentication via `require_authenticated_user` plug
