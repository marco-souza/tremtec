defmodule Tremtec.Messages.ContactMessage do
  use Ecto.Schema
  import Ecto.Changeset

  @typedoc "Represents a message submitted via the public contact page"
  @type t :: %__MODULE__{
          id: pos_integer() | nil,
          name: String.t() | nil,
          email: String.t() | nil,
          message: String.t() | nil,
          read: boolean(),
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "contact_messages" do
    field :name, :string
    field :email, :string
    field :message, :string
    field :read, :boolean, default: false

    timestamps()
  end

  @spec changeset(t(), map()) :: Ecto.Changeset.t()
  def changeset(contact_message, attrs) do
    contact_message
    |> cast(attrs, [:name, :email, :message, :read])
    |> validate_required([:name, :email, :message])
    |> validate_format(:email, ~r/^\S+@\S+\.[\w\.]+$/)
    |> validate_length(:message, min: 10)
  end
end
