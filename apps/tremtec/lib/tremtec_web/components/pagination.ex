defmodule TremtecWeb.Components.Pagination do
  use Phoenix.Component
  use Gettext, backend: TremtecWeb.Gettext

  attr :current_page, :integer, required: true
  attr :total_pages, :integer, required: true
  attr :class, :string, default: nil

  def controls(assigns) do
    ~H"""
    <div class={["flex justify-center items-center gap-4", @class]}>
      <button
        :if={@current_page > 1}
        class="btn btn-sm btn-outline"
        phx-click="prev_page"
      >
        {gettext("Previous")}
      </button>

      <span class="text-sm font-medium">
        {gettext("Page")} {@current_page} {gettext("of")} {@total_pages}
      </span>

      <button
        :if={@current_page < @total_pages}
        class="btn btn-sm btn-outline"
        phx-click="next_page"
      >
        {gettext("Next")}
      </button>
    </div>
    """
  end

  attr :current_page, :integer, required: true
  attr :total_pages, :integer, required: true
  attr :class, :string, default: nil

  def indicator(assigns) do
    ~H"""
    <div class={["text-sm text-center text-gray-600", @class]}>
      {gettext("Page")} {@current_page} {gettext("of")} {@total_pages}
    </div>
    """
  end
end
