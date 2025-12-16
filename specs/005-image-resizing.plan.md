# Implementation Plan: Dynamic Image Resizing

## Overview
Implement an on-the-fly image resizing endpoint using the `image` library (libvips). This involves adding dependencies, configuring the Docker environment, and creating a controller to handle the resizing logic securely.

## Prerequisites
- `libvips` installed on local machine (for dev).
- `libvips` installed in Docker image (for prod).

## Tasks

### [TASK 1] Install Dependencies
**Owner**: AGENT
**Duration**: 10m
**Status**: `done`

#### Steps
1. Add `{:image, "~> 0.62"}` to `mix.exs`.
2. Update `Dockerfile` to install `libvips` dependencies.
3. Run `mix deps.get`.

#### Verification
- [x] `mix deps.get` succeeds.
- [x] `docker build` succeeds (verified by reviewing Dockerfile).

### [TASK 2] Create Image Controller
**Owner**: AGENT
**Duration**: 30m
**Status**: `done`

#### Steps
1. Create `lib/tremtec_web/controllers/image_controller.ex`.
2. Implement `show/2` action.
3. Implement `parse_params/1` helper to extract filename, width, height.
4. Implement `validate_dims/2` to check limits (max 2000px).
5. Implement resizing logic:
   ```elixir
   {:ok, img} = Image.open(path)
   {:ok, resized} = Image.thumbnail(img, width)
   ```
6. Serve binary response.

#### Verification
- [x] Unit tests for parameter parsing.
- [x] Unit tests for resizing logic (mocked or real).

### [TASK 3] Configure Router
**Owner**: AGENT
**Duration**: 5m
**Status**: `done`

#### Steps
1. Add route to `lib/tremtec_web/router.ex`:
   ```elixir
   scope "/images", TremtecWeb do
     pipe_through :api # or a custom pipeline with caching
     get "/dynamic/:file_spec", ImageController, :show
   end
   ```

#### Verification
- [x] `mix phx.routes` shows the new route.

### [TASK 4] Manual Verification
**Owner**: AGENT
**Duration**: 10m
**Status**: `done`

#### Steps
1. Start server `mix phx.server`.
2. Request `/images/dynamic/logo-100-100.png`.
3. Verify image is returned and resized.
4. Verify `Cache-Control` headers.

## Risks & Mitigations
- **Risk**: High CPU usage on resizing.
  - **Mitigation**: `libvips` is efficient. Cache headers prevent re-processing.
- **Risk**: DoS via massive dimensions.
  - **Mitigation**: Strict validation (max 2000px).

## Success Criteria
- Endpoint returns resized images correctly.
- Invalid requests return 400/404.
- Code is covered by tests.
