defmodule TremtecWeb.ContactLive do
  use TremtecWeb, :live_view

  alias Phoenix.LiveView.Socket
  alias Ecto.Changeset

  @impl true
  def mount(_params, _session, %Socket{} = socket) do
    {:ok,
     socket
     |> assign(:page_title, gettext("Contact"))
     |> assign(:submitted?, false)
     |> assign(:form, empty_form())}
  end

  @impl true
  def handle_event("validate", %{"contact" => params}, %Socket{} = socket) do
    form =
      params
      |> changeset()
      |> Map.put(:action, :validate)
      |> to_form(as: :contact)

    {:noreply, assign(socket, form: form, submitted?: false)}
  end

  @impl true
  def handle_event("save", %{"contact" => params}, %Socket{} = socket) do
    case Changeset.apply_action(changeset(params), :insert) do
      {:ok, _data} ->
        # In a future iteration, persist or deliver via email.
        {:noreply,
         socket
         |> put_flash(:info, gettext("Thanks! Your message has been sent."))
         |> assign(:submitted?, true)
         |> assign(:form, empty_form())}

      {:error, %Changeset{} = cs} ->
        {:noreply, assign(socket, form: to_form(cs, as: :contact), submitted?: false)}
    end
  end

  defp empty_form do
    %{}
    |> changeset()
    |> to_form(as: :contact)
  end

  defp changeset(params) when is_map(params) do
    types = %{name: :string, email: :string, message: :string, nickname: :string}

    {%{}, types}
    |> Changeset.cast(params, Map.keys(types))
    |> Changeset.validate_required([:name, :email, :message])
    |> Changeset.validate_format(:email, ~r/^\S+@\S+\.[\w\.]+$/)
    |> Changeset.validate_length(:message, min: 10)
    # Simple honeypot: if filled, add an error and prevent submit
    |> maybe_flag_spam()
  end

  defp changeset(_), do: changeset(%{})

  defp maybe_flag_spam(%Changeset{} = cs) do
    case Ecto.Changeset.get_change(cs, :nickname) do
      nil -> cs
      "" -> cs
      _ -> Changeset.add_error(cs, :base, gettext("Spam detected"))
    end
  end
end


