defmodule Tremtec.Messages do
  @moduledoc """
  The Messages context. Stores and manages contact messages.
  """

  import Ecto.Query
  alias Tremtec.Repo
  alias Tremtec.Messages.ContactMessage

  @spec create_contact_message(map()) :: {:ok, ContactMessage.t()} | {:error, Ecto.Changeset.t()}
  def create_contact_message(attrs) do
    %ContactMessage{}
    |> ContactMessage.changeset(attrs)
    |> Repo.insert()
  end

  @spec list_contact_messages(keyword()) :: [ContactMessage.t()]
  def list_contact_messages(opts \\ []) do
    base = from m in ContactMessage, order_by: [desc: m.inserted_at]

    base
    |> apply_filters(opts)
    |> Repo.all()
  end

  defp apply_filters(query, opts) do
    query
    |> maybe_filter(:email, opts[:email])
    |> maybe_filter(:name, opts[:name])
  end

  defp maybe_filter(query, _field, nil), do: query
  defp maybe_filter(query, :email, email), do: where(query, [m], ilike(m.email, ^"%#{email}%"))
  defp maybe_filter(query, :name, name), do: where(query, [m], ilike(m.name, ^"%#{name}%"))

  @spec get_contact_message!(pos_integer()) :: ContactMessage.t()
  def get_contact_message!(id), do: Repo.get!(ContactMessage, id)

  @spec update_contact_message(ContactMessage.t(), map()) ::
          {:ok, ContactMessage.t()} | {:error, Ecto.Changeset.t()}
  def update_contact_message(%ContactMessage{} = msg, attrs) do
    msg
    |> ContactMessage.changeset(attrs)
    |> Repo.update()
  end
end
