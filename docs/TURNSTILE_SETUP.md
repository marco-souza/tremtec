# Cloudflare Turnstile CAPTCHA Setup Guide

## Overview

The contact form is protected with Cloudflare Turnstile CAPTCHA to prevent spam and bot attacks.

## Environment Variables

**Required in all environments** (development, testing, production).

Set these in `.env.local` (never commit):

- `TURNSTILE_SITE_KEY`: Public key from Cloudflare Dashboard
- `TURNSTILE_SECRET_KEY`: Private key from Cloudflare Dashboard

Example `.env.local`:
```env
TURNSTILE_SITE_KEY=1x1234567890abcdef1234567890
TURNSTILE_SECRET_KEY=1x5678901234567890abcdef1234567890abcdef
```

### Development-Only Note

- In **development**: If env vars are not set, test keys are used (widget won't validate, but won't error)
- In **testing**: Test keys are always used for consistency
- In **production**: Env vars are required and will error if missing

## Getting Started

### 1. Create Cloudflare Turnstile Widget

1. Visit https://dash.cloudflare.com
2. Navigate to **Turnstile** in the left sidebar
3. Click **Create Site**
4. Fill in:
   - **Site Name**: `TremTec Contact Form` (or `TremTec Dev`)
   - **Domains**: 
     - Development: `localhost:4000` and `localhost:3000`
     - Production: `yourdomain.com`
   - **Mode**: Managed (or Invisible if you prefer)
   - **Bot Fight Mode**: Enable
5. Copy the **Site Key** and **Secret Key**
6. Add to `.env.local`:
   ```bash
   echo 'TURNSTILE_SITE_KEY=your_key' >> .env.local
   echo 'TURNSTILE_SECRET_KEY=your_secret' >> .env.local
   ```
7. Start server: `mix phx.server`

### 2. Run Locally

After setting up `.env.local`:

```bash
# Start server
mix phx.server
```

Navigate to **http://localhost:4000/contact** to see the widget.

## Testing Locally

**With credentials set in `.env.local`:**
- Widget will render with your real Cloudflare setup
- Real API validation against your site's credentials
- Token validation will work correctly

### Manual Testing

1. Load `/contact` page
2. Widget should appear below the message field
3. Complete the challenge (select images, etc.)
4. Submit the form
5. Should see success message: "Thanks! Your message has been sent."

### Testing Validation Failure

To test error handling:

1. Open browser DevTools Console
2. Mock the response:
   ```javascript
   // Simulate a failed token
   document.querySelector('[name="cf-turnstile-response"]').value = 'invalid-token'
   ```
3. Submit form
4. Should see error: "Verification failed. Please try again."

## How It Works

### Client-Side (JavaScript)

- The Turnstile widget is loaded via `<Turnstile.script />` in the layout
- Phoenix hook (`TurnstileHook`) handles widget initialization
- On successful challenge completion, a token is generated and stored in a hidden input field

### Server-Side (Elixir)

- Token is sent with form data in the `cf-turnstile-response` parameter
- Server validates token with Cloudflare Siteverify API
- Token includes:
  - `success`: Boolean indicating if validation passed
  - `challenge_ts`: Timestamp of challenge
  - `hostname`: Domain the widget was loaded from
  - `error-codes`: Array of errors (if any)
- Token lifetime: 300 seconds (5 minutes)
- Tokens are single-use and expire automatically

## Troubleshooting

### Widget Not Appearing

- **Check CSP headers**: Browser console should show no warnings about `challenges.cloudflare.com`
- **Check network requests**: Look for `https://challenges.cloudflare.com/turnstile/...` in Network tab
- **Verify site key**: Ensure `TURNSTILE_SITE_KEY` is correct in `.env.local`

### Token Validation Failing

- **Check secret key**: Verify `TURNSTILE_SECRET_KEY` in `.env.local`
- **Check logs**: Look for "Captcha validation failed" messages
- **Check IP**: Some environments may require IP whitelisting
- **Check timeout**: Token expires after 5 minutes

### "Verification failed" Error

- Widget token was rejected by Cloudflare
- User may need to complete challenge again
- Check logs for specific error codes: `error-codes` field

## Monitoring

### Logs

Check logs for validation events:

```bash
# Successful validation
grep "Captcha validation succeeded" logs/dev.log

# Failed validation
grep "Captcha validation failed" logs/dev.log

# API errors
grep "Turnstile" logs/dev.log
```

### Cloudflare Dashboard

Monitor widget performance:

1. https://dash.cloudflare.com → Turnstile
2. Click your site widget
3. View:
   - Challenges issued
   - Success rate
   - Error breakdown
   - Geographic distribution

## Security

### Secret Key Protection

- Never expose `TURNSTILE_SECRET_KEY` in client code
- Never commit to version control
- Use environment variables in production
- Rotate keys quarterly

### Token Validation

- **Always validate server-side** (never trust client-side token)
- Tokens are single-use and expire automatically
- Include IP address in validation (helps detect replay attacks)
- Log all validation failures

### CSP Headers

The app includes Content Security Policy headers to allow Turnstile:

- `script-src`: Includes `https://challenges.cloudflare.com`
- `frame-src`: Includes `https://challenges.cloudflare.com`
- `connect-src`: Includes `https://challenges.cloudflare.com`

## Production Deployment

### Before Going Live

1. Create production Turnstile widget in Cloudflare Dashboard
2. Add production domain to widget domains list
3. Set environment variables in production:
   - `TURNSTILE_SITE_KEY` (production key)
   - `TURNSTILE_SECRET_KEY` (production key)
4. Test on staging environment
5. Monitor first week closely

### Maintenance

- Monitor widget analytics in Cloudflare Dashboard
- Check logs for unusual patterns
- Rotate secret keys every 3 months
- Update documentation if widget modes change

## API Reference

### Contact Form Handler

Location: `lib/tremtec_web/live/public_pages/contact_live.ex`

Key functions:
- `handle_event("save", params, socket)` - Form submission handler
- `validate_captcha(token, socket)` - Token verification
- `verify_token_with_cloudflare(token, secret_key, remote_ip)` - API call to Cloudflare
- `get_remote_ip(socket)` - Extract client IP from socket

### Configuration

Location: `config/runtime.exs`

```elixir
config :phoenix_turnstile,
  site_key: System.get_env("TURNSTILE_SITE_KEY", "1x00000000000000000000AA"),
  secret_key: System.get_env("TURNSTILE_SECRET_KEY", "1x0000000000000000000000000000000000AA")
```

### Dependencies

- `phoenix_turnstile` ~> 1.2 - Phoenix integration library
- `req` ~> 0.5 - HTTP client for Cloudflare API

## Support

For issues:

1. Check browser DevTools Console for client-side errors
2. Check application logs for server-side errors
3. Visit https://challenges.cloudflare.com to test widget directly
4. Contact Cloudflare Support: https://dash.cloudflare.com/?support

## References

- [Cloudflare Turnstile Docs](https://developers.cloudflare.com/turnstile/)
- [Turnstile Widget API](https://developers.cloudflare.com/turnstile/get-started/client-side-rendering/)
- [Siteverify API](https://developers.cloudflare.com/turnstile/get-started/server-side-validation/)
