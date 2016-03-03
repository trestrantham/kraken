defmodule Kraken.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string
      add :email, :string, null: false
      add :password_hash, :string

      timestamps
    end

    create unique_index(:users, [:email])
  end

  def down do
    drop table(:users)

    execute "DROP EXTENSION IF EXISTS \"uuid-ossp\""
  end
end
