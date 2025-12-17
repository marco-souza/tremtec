defmodule Tremtec.Messages.ContactMessage do
  use Ecto.Schema
  import Ecto.Changeset

  alias Tremtec.Validators.Email

  @typedoc "Represents a message submitted via the public contact page"
  @type t :: %__MODULE__{
          id: pos_integer() | nil,
          name: String.t() | nil,
          email: String.t() | nil,
          message: String.t() | nil,
          read: boolean(),
          deleted_at: DateTime.t() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "contact_messages" do
    field :name, :string
    field :email, :string
    field :message, :string
    field :read, :boolean, default: false
    field :deleted_at, :utc_datetime

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(contact_message, attrs) do
    contact_message
    |> cast(attrs, [:name, :email, :message, :read, :deleted_at])
    |> validate_required([:name, :email, :message])
    |> Email.validate_all()
    |> validate_length(:message, min: 10)
  end
end
