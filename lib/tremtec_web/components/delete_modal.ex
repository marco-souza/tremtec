defmodule TremtecWeb.Components.DeleteModal do
  @moduledoc """
  A reusable delete confirmation modal component.

  This component handles the UI and basic event structure for delete confirmations
  across admin pages. It expects the parent LiveView to handle the actual deletion
  logic via `confirm_delete` event.

  ## Usage

      <DeleteModal.confirm
        show={@show_delete_modal}
        modal_id={@delete_modal_id}
        message={gettext("Are you sure you want to delete this item?")}
      />

  ## Events

  The parent LiveView must handle:
  - `"close_delete_modal"` - to close the modal
  - `"confirm_delete"` - to perform the deletion (receives `id` in params)
  - `"show_delete_modal"` - to open the modal (receives `id` in params)
  """
  use Phoenix.Component
  use Gettext, backend: TremtecWeb.Gettext

  @doc """
  Renders a delete confirmation modal.

  ## Attributes

    * `:show` (required) - Boolean to control modal visibility
    * `:modal_id` (required) - The ID of the item being deleted (sent with confirm_delete event)
    * `:message` (required) - The confirmation message to display
    * `:title` - The modal title (defaults to "Confirm Deletion")
    * `:cancel_label` - Cancel button text (defaults to "Cancel")
    * `:delete_label` - Delete button text (defaults to "Delete")
  """
  attr :show, :boolean, required: true, doc: "Whether the modal is visible"
  attr :modal_id, :string, required: true, doc: "The ID of the item being deleted"
  attr :message, :string, required: true, doc: "The confirmation message"
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
