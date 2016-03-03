defmodule Kraken.Repo.Migrations.CreateProvider do
  use Ecto.Migration

  def change do
    create table(:providers, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false
      add :message, :string, null: false
      add :state, :string, null: false

      timestamps
    end

    create unique_index(:providers, [:name])
  end
end
