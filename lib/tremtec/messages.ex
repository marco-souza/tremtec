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

  @spec get_contact_message(pos_integer()) :: {:ok, ContactMessage.t()} | :error
  def get_contact_message(id) do
    case Repo.get(ContactMessage, id) do
      %ContactMessage{} = message -> {:ok, message}
      nil -> :error
    end
  end

  @doc """
  Updates a contact message with the given attributes.

  ## Examples

      iex> update_contact_message(message, %{read: true})
      {:ok, %ContactMessage{}}

      iex> update_contact_message(message, %{message: nil})
      {:error, changeset}

  """
  @spec update_contact_message(ContactMessage.t(), map()) ::
          {:ok, ContactMessage.t()} | {:error, Ecto.Changeset.t()}
  def update_contact_message(%ContactMessage{} = msg, attrs) do
    msg
    |> ContactMessage.changeset(attrs)
    |> Repo.update()
  end

  ## Admin Functions

  @doc """
  Lists contact messages with pagination, excluding soft-deleted messages.

  ## Examples

      iex> list_admin_messages(1, 10)
      {[%ContactMessage{}, ...], total_count}

      iex> list_admin_messages(2, 10)
      {[%ContactMessage{}, ...], total_count}

  """
  def list_admin_messages(page \\ 1, per_page \\ 10) when page > 0 and per_page > 0 do
    offset = (page - 1) * per_page

    query =
      from m in ContactMessage,
        where: is_nil(m.deleted_at),
        order_by: [desc: m.inserted_at]

    total_count = Repo.aggregate(query, :count)
    messages = query |> limit(^per_page) |> offset(^offset) |> Repo.all()

    {messages, total_count}
  end

  @doc """
  Searches contact messages by name, email, or message content with pagination.

  Excludes soft-deleted messages. Pagination happens at database level for optimal performance.

  ## Examples

      iex> search_admin_messages("john", 1, 10)
      {[%ContactMessage{}, ...], total_count}

      iex> search_admin_messages("john@example.com", 2, 10)
      {[%ContactMessage{}, ...], total_count}

  """
  @spec search_admin_messages(String.t(), pos_integer(), pos_integer()) ::
          {[ContactMessage.t()], non_neg_integer()}
  def search_admin_messages(query_str, page \\ 1, per_page \\ 10)
      when is_binary(query_str) and page > 0 and per_page > 0 do
    like_query = "%#{String.downcase(query_str)}%"
    offset = (page - 1) * per_page

    query =
      from(m in ContactMessage,
        where:
          is_nil(m.deleted_at) and
            (like(fragment("lower(?)", m.name), ^like_query) or
               like(fragment("lower(?)", m.email), ^like_query) or
               like(fragment("lower(?)", m.message), ^like_query)),
        order_by: [desc: m.inserted_at]
      )

    total_count = Repo.aggregate(query, :count)
    messages = query |> limit(^per_page) |> offset(^offset) |> Repo.all()

    {messages, total_count}
  end

  @doc """
  Marks a contact message as read or unread.

  ## Examples

      iex> mark_message_read(message, true)
      {:ok, %ContactMessage{}}

      iex> mark_message_read(message, false)
      {:ok, %ContactMessage{}}

  """
  def mark_message_read(%ContactMessage{} = msg, read_status) when is_boolean(read_status) do
    msg
    |> ContactMessage.changeset(%{read: read_status})
    |> Repo.update()
  end

  @doc """
  Soft deletes a contact message by setting deleted_at timestamp.

  ## Examples

      iex> delete_admin_message(message)
      {:ok, %ContactMessage{}}

      iex> delete_admin_message(message)
      {:error, changeset}

  """
  def delete_admin_message(%ContactMessage{} = msg) do
    now = DateTime.utc_now(:second)
    msg |> ContactMessage.changeset(%{deleted_at: now}) |> Repo.update()
  end

  @doc """
  Gets count of unread messages.

  ## Examples

      iex> count_unread_messages()
      5

  """
  def count_unread_messages do
    from(m in ContactMessage, where: is_nil(m.deleted_at) and m.read == false)
    |> Repo.aggregate(:count)
  end

  @doc """
  Gets the date of the last received message.

  Returns nil if no messages exist.

  ## Examples

      iex> get_last_message_date()
      ~U[2025-12-01 10:30:00Z]

      iex> get_last_message_date()
      nil

  """
  def get_last_message_date do
    from(m in ContactMessage,
      where: is_nil(m.deleted_at),
      order_by: [desc: m.inserted_at],
      limit: 1,
      select: m.inserted_at
    )
    |> Repo.one()
  end
end
