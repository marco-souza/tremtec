defmodule TremtecWeb.Components.DeleteModal do
  use Phoenix.Component
  use Gettext, backend: TremtecWeb.Gettext

  attr :show, :boolean, required: true
  attr :modal_id, :string, required: true
  attr :message, :string, required: true
  attr :title, :string, default: nil
  attr :cancel_label, :string, default: nil
  attr :delete_label, :string, default: nil

  def confirm(assigns) do
    assigns =
      assigns
      |> assign_new(:title, fn -> gettext("Confirm Deletion") end)
      |> assign_new(:cancel_label, fn -> gettext("Cancel") end)
      |> assign_new(:delete_label, fn -> gettext("Delete") end)

    ~H"""
    <div
      :if={@show}
      class="modal modal-open"
      id="delete-modal"
    >
      <div class="modal-box">
        <h3 class="font-bold text-lg">{@title}</h3>
        <p class="py-4">
          {@message}
        </p>
        <div class="modal-action">
          <button
            class="btn btn-outline"
            phx-click="close_delete_modal"
          >
            {@cancel_label}
          </button>
          <button
            class="btn btn-error"
            phx-click="confirm_delete"
            phx-value-id={@modal_id}
          >
            {@delete_label}
          </button>
        </div>
      </div>
      <form method="dialog" class="modal-backdrop">
        <button phx-click="close_delete_modal">{gettext("Close")}</button>
      </form>
    </div>
    """
  end
end
