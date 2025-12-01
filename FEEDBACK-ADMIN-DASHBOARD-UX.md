# Admin Dashboard - UX Improvement Feedback

**Status**: Ready for Implementation  
**Implementation Date**: Dec 01, 2025  
**Previous Work**: Thread T-9706158c-e5eb-487e-b22e-64311e22fb5d  
**All Tests Passing**: 187 tests

## Overview

The Enhanced Admin Dashboard feature has been fully implemented and tested. Four UX improvements have been identified during browser testing with Playwright. These improvements will enhance user experience and provide more modern UX patterns.

## Improvements to Implement

### 1. Last Message Date Formatting - Relative Time Display

**Current Behavior**: 
- Shows absolute datetime format: `"2025-11-29 15:45"`

**Desired Behavior**: 
- Show relative time: `"5 minutes ago"`, `"2 hours ago"`, `"3 days ago"`
- More human-friendly for administrators

**File to Modify**: 
- `lib/tremtec_web/live/admin/dashboard_live.ex`

**Changes Needed**:
- Replace `format_date/1` function (lines 130-140) with a function that calculates relative time
- Use `DateTime.diff/3` to calculate time difference
- Return human-readable relative time strings
- Handle edge cases (just now, minutes, hours, days, weeks)
- All strings must use `gettext()` for i18n support

**Example Output**:
```
"Just now" (< 1 minute)
"5 minutes ago"
"2 hours ago"
"3 days ago"
"1 week ago"
"2 weeks ago"
```

---

### 2. Post-Login Redirect to Dashboard

**Current Behavior**: 
- After successful login, user is redirected based on `put_session(:user_return_to)` pattern
- May redirect to `/admin/settings` instead of dashboard

**Desired Behavior**: 
- After successful login (both email/password and magic link), user should be redirected to `/admin/dashboard`
- This provides better UX - shows dashboard first with overview statistics

**File to Modify**: 
- `lib/tremtec_web/controllers/user_session_controller.ex`

**Changes Needed**:
- In `create/3` function (lines 16-30 and 33-47), after successful authentication, ensure redirect goes to `/admin/dashboard`
- Verify the `signed_in_path/1` function in `UserAuth` returns correct dashboard path
- Check `UserAuth.log_in_user/3` flow (lines 36-42 in user_auth.ex)
- May need to update session handling or redirect logic

**Current Flow**:
```
create() → UserAuth.log_in_user() → redirect(user_return_to || signed_in_path())
```

**Desired Flow**:
```
create() → UserAuth.log_in_user() → redirect(/admin/dashboard) for authenticated admin users
```

---

### 3. Settings Page Admin Layout

**Current Behavior**: 
- Settings page (`/admin/settings`) renders with `Layouts.app` but does NOT pass `is_admin={true}`
- Result: No sidebar/mobile nav shown on settings page
- Inconsistent navigation experience

**Desired Behavior**: 
- Settings page should show sidebar (desktop) and mobile nav (mobile)
- Consistent admin section navigation

**File to Modify**: 
- `lib/tremtec_web/live/user_live/settings.ex`

**Changes Needed**:
- Line 11: Change `<Layouts.app flash={@flash} current_scope={@current_scope}>` 
- To: `<Layouts.app flash={@flash} current_scope={@current_scope} is_admin={true}>`
- This will trigger the sidebar/mobile nav rendering in the layout

**Current Line 11**:
```heex
<Layouts.app flash={@flash} current_scope={@current_scope}>
```

**Desired Line 11**:
```heex
<Layouts.app flash={@flash} current_scope={@current_scope} is_admin={true}>
```

---

### 4. Sidebar Branding - Logo Section

**Current Behavior**: 
- Sidebar starts directly with navigation links
- No branding/logo at the top
- Lacks visual identity

**Desired Behavior**: 
- Add branding section at top of sidebar with:
  - Icon: `hero-command-line` (terminal icon - fits the TremTec technical brand)
  - Text: "TremTec" next to icon
  - Styling: Professional, centered, with appropriate spacing
  - Should be a visual anchor for the admin area

**File to Modify**: 
- `lib/tremtec_web/components/admin_sidebar.ex`

**Changes Needed**:
- Add a branding section before the `<nav>` element (before line 12)
- Use DaisyUI/Tailwind classes for styling
- Include icon + text
- Add appropriate padding/margin for spacing
- Should not be clickable (static branding)

**Example Structure**:
```heex
<aside class="hidden md:flex fixed left-0 top-0 h-screen w-64 bg-base-100 border-r border-base-200 flex-col z-40 pt-20">
  <!-- NEW BRANDING SECTION -->
  <div class="px-6 py-8 border-b border-base-200 flex items-center gap-3">
    <.icon name="hero-command-line" class="w-8 h-8 text-primary" />
    <span class="text-xl font-bold text-base-content">TremTec</span>
  </div>
  
  <!-- EXISTING NAVIGATION -->
  <nav class="flex-1 px-6 py-8">
    ...
  </nav>
</aside>
```

---

## Implementation Checklist

- [ ] Implement relative time formatting for dashboard last message date
- [ ] Test relative time display with various time differences
- [ ] Verify post-login redirect goes to `/admin/dashboard`
- [ ] Test magic link login redirect
- [ ] Test email/password login redirect
- [ ] Add `is_admin={true}` to Settings page layout
- [ ] Verify sidebar/mobile nav appears on settings page
- [ ] Add logo branding section to sidebar
- [ ] Test sidebar branding displays correctly
- [ ] Run full test suite: `mix test`
- [ ] Run `mix precommit` to ensure code quality
- [ ] Manual browser testing on mobile and desktop

---

## Technical Notes

1. **Relative Time Function**: Consider using `DateTime.diff/3` with `:second` unit, then convert to appropriate unit (minutes, hours, days, etc.)

2. **i18n**: All user-facing strings in relative time (e.g., "ago", "minutes", "hours") must use `gettext()` for proper internationalization

3. **Edge Cases**: Handle:
   - Null/nil dates (no messages yet)
   - Very recent messages ("just now")
   - Future dates (shouldn't happen but handle gracefully)

4. **Session Redirect**: The session redirect logic is in `UserAuth.log_in_user/3` which calls `signed_in_path/1`. This function may need updating to return dashboard for authenticated admins instead of settings.

5. **Sidebar Branding**: Keep it simple and professional. The terminal icon (`hero-command-line`) provides good visual representation of the technical nature of TremTec.

---

## Files Summary

| File | Change Type | Priority |
|------|-------------|----------|
| `lib/tremtec_web/live/admin/dashboard_live.ex` | Modify - improve date formatting | High |
| `lib/tremtec_web/controllers/user_session_controller.ex` | Modify - verify/fix redirect | High |
| `lib/tremtec_web/live/user_live/settings.ex` | Modify - add is_admin flag | High |
| `lib/tremtec_web/components/admin_sidebar.ex` | Modify - add branding section | Medium |

All changes are non-breaking and focused on UX improvements.

---

## Testing Strategy

1. **Dashboard Date Formatting**:
   - Create test messages at various times (now, 5 min ago, 1 hour ago, 2 days ago, 1 week ago)
   - Verify relative time displays correctly
   - Test with null last message date

2. **Post-Login Redirect**:
   - Test login via email/password form
   - Test magic link login
   - Verify destination is always `/admin/dashboard`
   - Test browser back button doesn't break flow

3. **Settings Page Layout**:
   - Navigate to `/admin/settings` 
   - Verify sidebar visible on desktop
   - Verify mobile nav visible on mobile
   - Verify all navigation links work

4. **Sidebar Branding**:
   - Desktop view: verify logo + text displays correctly
   - Check spacing and alignment
   - Verify doesn't break on narrow viewports
   - Test on different browsers

---

## Next Steps

1. Assign these tasks to implementer
2. Each task can be done independently (no dependencies)
3. All changes are low-risk and focused on UX
4. Estimated time: 30-45 minutes total
5. After completion, run `mix precommit` and `mix test`
