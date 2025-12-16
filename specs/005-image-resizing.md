# Feature Specification: Dynamic Image Resizing

## Feature Name

Dynamic Image Resizing

## Objective

Implement an on-the-fly image resizing endpoint to serve optimized images from `priv/static/images` based on requested dimensions, improving frontend performance and LCP scores.

## User Story

As a developer/user, I want to request images with specific dimensions via a URL pattern so that the application serves optimization versions of the assets, reducing download size and rendering time.

## Functional Requirements

- **Endpoint**: Create a route (e.g., `/images/dynamic/:file_spec`) that accepts a filename pattern containing dimensions.
- **URL Pattern**: Support a pattern like `filename-{width}-{height}.ext` (e.g., `logo-100-100.png`) that maps to source `filename.ext`.
- **Image Processing**: Use a performant library (e.g., `image` / `libvips`) to resize the source image found in `priv/static/images`.
- **Validation**:
  - Verify source file exists.
  - Validate `width` and `height` are integers and within safe limits (e.g., max 2000px) to prevent DoS.
- **Response**:
  - Return the binary image data with correct `Content-Type`.
  - Set aggressive `Cache-Control` headers (public, long max-age) to leverage browser and CDN caching.
- **Error Handling**: Return 404 if file not found or 400 if parameters are invalid.

## Success Criteria

- Requesting `.../logo-100-100.png` returns the `logo.png` resized to 100x100.
- The response includes correct MIME type (e.g., `image/png`).
- The response includes `Cache-Control` headers.
- Invalid requests (missing file, non-integer dimensions) are handled gracefully.

## Notes

- **Library**: We will use the `image` library (Elixir wrapper for libvips) for high performance and low memory usage.
- **Source**: Images will be sourced from `priv/static/images`.
- **Security**: Must sanitize inputs to prevent path traversal and resource exhaustion.

