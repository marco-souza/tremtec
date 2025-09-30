defmodule Tremtec.Repo.Migrations.CreateContactMessages do
  use Ecto.Migration

  def change do
    create table(:contact_messages) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :message, :text, null: false
      add :read, :boolean, null: false, default: false

      timestamps()
    end

    create index(:contact_messages, [:inserted_at])
    create index(:contact_messages, [:email])
  end
end
