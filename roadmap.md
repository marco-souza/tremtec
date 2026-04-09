# Roadmap

- [ ] ref: move private pages under /admin
- [ ] debt: set sitemap environment domain during pulumi deployment
- [ ] fea: add a cleaner UI/UX
- [ ] enh: change color scheme to match new copy strategy
- [ ] ref: clean up project removing boilerplate info

- [ ] fea: contact form
  - [ ] fea: website
    - contact form (name, email, subject, message)
    - turnstile to prevent spam
    - `send_email` to team on submission
    - `send_email` to user on submission
  - [ ] fea: admin dashboard
    - view contact form submissions
    - mark status as read/unread/contacted/waiting response
    - delete

- [ ] fea: admin dashboard to manage users
  - [ ] admin: list all users with pagination
  - [ ] admin: show users with
    - id, name, email
    - status (active, pending, suspended)
    - role (admin, user)
    - timestamps (created_at, last_login)
  - [ ] login flow:
        Login ->
        if @tremtec.com email -> redirect to dashboard
        else -> redirect to "Thank you for your interest, we'll be in touch!"

## Done

- [x] sitemap support
