defmodule TremtecWeb.ImageController do
  use TremtecWeb, :controller

  require Logger

  @max_dimension 2000
  @cache_control "public, max-age=31536000, immutable"

  def show(conn, %{"file_spec" => file_spec}) do
    case parse_file_spec(file_spec) do
      {:ok, filename, ext, width, height} ->
        serve_resized_image(conn, filename, ext, width, height)

      :error ->
        conn
        |> put_status(:bad_request)
        |> text("Invalid image specification. Format: name-width-height.ext")
    end
  end

  defp serve_resized_image(conn, filename, ext, width, height) do
    source_path = Application.app_dir(:tremtec, "priv/static/images/#{filename}.#{ext}")

    if File.exists?(source_path) do
      process_and_respond(conn, source_path, width, height, ext)
    else
      conn
      |> put_status(:not_found)
      |> text("Image not found")
    end
  end

  defp process_and_respond(conn, source_path, width, height, ext) do
    # Using Image library (libvips)
    with {:ok, img} <- Image.open(source_path),
         # Resize with crop: :center to fill dimensions exactly
         {:ok, resized} <- Image.thumbnail(img, width, height: height, crop: :center),
         {:ok, data} <- Image.write(resized, :memory, suffix: ".#{ext}") do
      conn
      |> put_resp_content_type(MIME.from_path("file.#{ext}"))
      |> put_resp_header("cache-control", @cache_control)
      |> send_resp(200, data)
    else
      err ->
        Logger.error("Image processing failed: #{inspect(err)}")

        conn
        |> put_status(:internal_server_error)
        |> text("Error processing image")
    end
  end

  defp parse_file_spec(spec) do
    # Matches: filename-width-height.ext
    # Handles filenames with hyphens due to greedy matching of first group
    case Regex.run(~r/^(.+)-(\d+)-(\d+)\.(.+)$/, spec) do
      [_, name, w, h, ext] ->
        with {width, ""} <- Integer.parse(w),
             {height, ""} <- Integer.parse(h),
             true <- validate_dims(width, height),
             true <- safe_filename?(name) do
          {:ok, name, ext, width, height}
        else
          _ -> :error
        end

      _ ->
        :error
    end
  end

  defp validate_dims(w, h) do
    w > 0 and w <= @max_dimension and h > 0 and h <= @max_dimension
  end

  defp safe_filename?(name) do
    # Prevent path traversal
    not String.contains?(name, "..") and not String.contains?(name, "/") and
      not String.contains?(name, "\\")
  end
end
