defmodule Kraken.Repo.Migrations.CreateConnections do
  use Ecto.Migration

  def change do
    create table(:connections, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :provider_id, references(:providers, on_delete: :delete_all, type: :uuid)
      add :uid, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :uuid)
      add :token, :text
      add :refresh_token, :text
      add :expires_at, :bigint

      timestamps
    end

    create index(:connections, [:provider_id, :user_id], unique: true)
    create index(:connections, [:expires_at])
    create index(:connections, [:provider_id, :token])
  end
end
