# Enhanced Admin Dashboard Specification

## Feature Name

Enhanced Admin Dashboard with Messages & Users Management

## Objective

Enhance the existing Admin Dashboard to provide administrators with a comprehensive interface to manage contacts, messages, and users. The dashboard should display real-time statistics, offer quick actions, and provide seamless navigation between different management sections. All users with @tremtec email domain are automatically admins (no role management system needed at this time).

## User Story

As an administrator, I want to access an enhanced dashboard with:

- Quick statistics (total users, total messages, unread messages)
- Navigation to manage messages and users
- Organized sidebar navigation
- Settings page to manage admin account

## Functional Requirements

### Dashboard Home Page

- Display dashboard statistics cards:
  - Total number of users
  - Total number of messages received
  - Number of unread messages
  - Last message received date
- Show quick action buttons to navigate to message management and user management
- Responsive layout that works on desktop and mobile

### Messages Management

- Display paginated list of contact messages (10 items per page)
- Show: sender name, email, message preview, received date, read status
- Mark messages as read/unread
- Soft delete messages (with confirmation) - add `deleted_at` field
- Search/filter by sender name, email, or message content
- Sort by date, sender, or read status
- Expandable message view to see full content
- Visual indication for unread messages

### Users Management

- Display paginated list of registered users (10 items per page)
- Show: user email, registration date, confirmation status
- Soft delete users (with confirmation) - add `deleted_at` field
- Search by email
- View user details
- Cascade soft delete to user's messages

### Admin Settings Page

- Change password
- Update email
- Confirm email changes
- Delete account

### Navigation

**Desktop**: Sidebar (fixed left) with navigation items:
- Dashboard (home)
- Messages
- Users
- Settings
- Back to public page link
- Logout option

**Mobile**: Bottom navigation bar (new component) with icons:
- Dashboard icon
- Messages icon
- Users icon
- Settings icon
- Menu icon (logout + back to page)

## Non-Functional Requirements

- All dashboard pages must require authentication
- Only authenticated admin users (with @tremtec email domain) can access any dashboard page
- Dashboard should be responsive (mobile-first design)
- Performance: load times < 1s for initial dashboard view
- All data operations must use Ecto queries with proper preloading
- Follow Phoenix v1.8 styling guidelines with DaisyUI components
- Styling priority: **DaisyUI components > Tailwind CSS > custom CSS**
- Accessibility: WCAG 2.1 AA compliance minimum

## Success Criteria

- [x] Dashboard page displays with correct statistics
- [ ] Statistics are accurate (counts match database)
- [ ] All navigation links work correctly
- [ ] Messages page displays list of contact messages
- [ ] Can mark messages as read/unread
- [ ] Can delete messages
- [ ] Can search/filter messages
- [ ] Users page displays list of registered users
- [ ] Settings page allows password and email changes
- [ ] All pages have proper authentication protection
- [ ] All pages responsive on mobile and desktop
- [ ] All features covered by tests
- [ ] Code passes `mix precommit`

## Assumptions

- Contact messages already stored in database via contact form ✓
- User authentication system fully implemented ✓
- Database schema for `users` exists without `deleted_at` field
- Database schema for `contact_messages` exists WITH `read` boolean field ✓
- Users don't have `last_login` field (won't be displayed)
- DaisyUI is configured and available ✓
- Admin validation via email domain is already implemented ✓

## Constraints

- Use DaisyUI components as primary styling solution (no custom HTML/CSS if DaisyUI component exists)
- No third-party admin UI frameworks (e.g., ActiveAdmin)
- No inline JavaScript allowed
- Authentication via existing Phoenix auth system
- SQLite database backend

## Out of Scope

- Email notifications to admins
- Message export/bulk operations
- Admin role management system (will be implemented in future ticket - currently all @tremtec users are admins)
- Message reply functionality
- Advanced analytics or reporting
- Custom CSS/styling (prioritize DaisyUI over custom styles)

## Implementation Notes

- Migration: Add `deleted_at` field to both `users` and `contact_messages` tables
- Admin guard: Create helper function to check if user email is @tremtec domain
- Update router to add /admin/messages and /admin/users routes
- Create context functions: 
  - Accounts.list_users (paginated, excludes deleted)
  - Messages.list_contact_messages (paginated, excludes deleted)
  - Update delete functions to use soft delete (set deleted_at)
- Create LiveView components for messages and users management
- Create new mobile bottom navigation bar component
- Ensure all routes use require_authenticated_user plug
- Add tests for all new functionality
- Update navigation layout component for sidebar + mobile nav bar