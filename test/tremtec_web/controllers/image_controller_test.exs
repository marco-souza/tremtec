defmodule TremtecWeb.ImageControllerTest do
  use TremtecWeb.ConnCase

  test "GET /images/dynamic/:spec returns 400 for invalid format", %{conn: conn} do
    conn = get(conn, "/images/dynamic/invalid-format")
    assert response(conn, 400) =~ "Invalid image specification"
  end

  test "GET /images/dynamic/:spec returns 400 for invalid dimensions", %{conn: conn} do
    conn = get(conn, "/images/dynamic/logo-3000-3000.png")
    assert response(conn, 400) =~ "Invalid image specification"
  end

  test "GET /images/dynamic/:spec returns 404 for missing image", %{conn: conn} do
    conn = get(conn, "/images/dynamic/nonexistent-100-100.png")
    assert response(conn, 404) =~ "Image not found"
  end

  # Integration test (requires libvips and actual image)
  @tag :integration
  test "GET /images/dynamic/:spec returns resized image", %{conn: conn} do
    # Ensure logo.png exists
    if File.exists?(Application.app_dir(:tremtec, "priv/static/images/logo.png")) do
      conn = get(conn, "/images/dynamic/logo-50-50.png")
      assert response(conn, 200)
      assert response_content_type(conn, :png)
      assert get_resp_header(conn, "cache-control") == ["public, max-age=31536000, immutable"]
    else
      IO.puts "Skipping image resize test: logo.png not found"
    end
  end
end
