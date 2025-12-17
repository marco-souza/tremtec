defmodule Tremtec.Repo.Migrations.AddDeletedAtToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :deleted_at, :utc_datetime
    end

    create index(:users, [:deleted_at])
  end
end
