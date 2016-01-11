defmodule Kraken.Repo.Migrations.CreateDataConnections do
  use Ecto.Migration

  def change do
    create table(:data_connections) do
      add :provider, :string
      add :uid, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :token, :text
      add :refresh_token, :text
      add :expires_at, :bigint

      timestamps
    end

    create index(:data_connections, [:provider, :uid], unique: true)
    create index(:data_connections, [:expires_at])
    create index(:data_connections, [:provider, :token])
  end
end
