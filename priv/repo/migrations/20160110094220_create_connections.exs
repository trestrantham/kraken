defmodule Kraken.Repo.Migrations.CreateConnections do
  use Ecto.Migration

  def change do
    create table(:connections) do
      add :provider, :string
      add :uid, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :token, :text
      add :refresh_token, :text
      add :expires_at, :bigint

      timestamps
    end

    create index(:connections, [:provider, :user_id], unique: true)
    create index(:connections, [:expires_at])
    create index(:connections, [:provider, :token])
  end
end
