defmodule Tremtec.Repo.Migrations.AddIndexesToContactMessages do
  use Ecto.Migration

  def change do
    # Index for read status - useful for unread message counts
    create index(:contact_messages, [:read])

    # Composite index for common queries - find non-deleted messages
    create index(:contact_messages, [:deleted_at, :inserted_at])

    # Index for text search on name field
    create index(:contact_messages, [:name])
  end
end
