defmodule Tremtec.Repo.Migrations.AddDeletedAtToContactMessages do
  use Ecto.Migration

  def change do
    alter table(:contact_messages) do
      add :deleted_at, :utc_datetime
    end

    create index(:contact_messages, [:deleted_at])
  end
end
