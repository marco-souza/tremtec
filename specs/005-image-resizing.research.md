# Technical Research: Dynamic Image Resizing

## Executive Summary

We will implement dynamic image resizing using the `image` library (based on libvips) for high performance. This requires adding system dependencies to our Docker image and a new Elixir dependency. The implementation will expose a controller action that parses dimensions from the URL, resizes the source image, and serves it with aggressive caching headers.

## 1. Technology Versions & Current State

- **Elixir Library**: `image` `~> 0.62`
- **System Library**: `libvips` (Required by `image`)
  - **Dev/Build**: `libvips-dev`
  - **Runtime**: `libvips-tools` or `libvips42` (Debian Bookworm)

## 2. Technical Architecture

### Endpoint Design
- **URL**: `/images/dynamic/:file_spec`
- **Pattern**: `name-width-height.ext` (e.g., `logo-100-100.png`)
- **Controller**: `TremtecWeb.ImageController`

### Image Processing Flow
1. **Parse**: Extract `filename`, `width`, `height`, `extension` from URL param.
2. **Validate**: 
   - Check if source file exists in `priv/static/images`.
   - Ensure `width` and `height` are integers within `1..2000`.
3. **Process**:
   - `Image.open(path)`
   - `Image.thumbnail(image, width)` (or `{width, height}`)
   - `Image.write(image, :memory, suffix: ".ext")`
4. **Respond**:
   - `content-type`: `image/png`, `image/jpeg`, etc.
   - `cache-control`: `public, max-age=31536000, immutable`

## 3. Project Requirements Analysis

- **Docker**: Must update `Dockerfile` to install `libvips`.
- **Config**: No special config needed, but `image` library might print warnings if Vix is compiling.
- **Mix**: Add dependency.

## 4. Dependency Analysis

### New Packages
- `{:image, "~> 0.62"}`: Main library.
- `{:vix, ...}`: Transitive dependency (libvips wrapper).

### System Dependencies
- `libvips-dev`: For compiling Vix (if precompiled not found/used).
- `libvips`: For runtime execution.

## 5. Key Technical Constraints

- **Security**: 
  - Path traversal: Ensure `filename` doesn't contain `/` or `..`.
  - DoS: Limit max dimensions (e.g. 2048px). Limit concurrency if needed (libvips is generally safe).
- **Performance**: 
  - Processing is fast but CPU bound.
  - Caching is critical.
  - Initial request latency might be 50-200ms. Subsequent are cached by browser/CDN.

## 6. Implementation Options

- **Option A (Recommended)**: Serve via Phoenix Controller.
  - Pros: Full control, easy to secure, easy to deploy.
  - Cons: Hits Erlang VM.
- **Option B**: Pre-generate images at build time.
  - Pros: Static file serving (fastest).
  - Cons: Explodes build time and artifact size if many variations needed.
- **Decision**: Option A for flexibility.

## 7. Implementation Tasks

### Phase 1: Setup (AGENT)
- [ ] Add `{:image, "~> 0.62"}` to `mix.exs`.
- [ ] Update `Dockerfile` to install `libvips`.
- [ ] Run `mix deps.get`.

### Phase 2: Development (AGENT)
- [ ] Create `TremtecWeb.ImageController`.
- [ ] Implement parsing and validation logic.
- [ ] Implement resizing logic using `Image`.
- [ ] Add route to `router.ex`.
- [ ] Add tests.

## 8. References
- [Elixir Image Docs](https://hexdocs.pm/image/Image.html)
- [Libvips](https://www.libvips.org/)

