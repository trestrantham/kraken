defmodule Kraken.Connection do
  use Kraken.Web, :model

  schema "connections" do
    field :uid, :string
    field :token, :string
    field :refresh_token, :string
    field :expires_at, :integer
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    belongs_to :user, Kraken.User
    belongs_to :provider, Kraken.Provider

    timestamps
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:user_id, :provider_id, :uid, :token, :refresh_token, :expires_at])
    |> validate_required([:user_id, :provider_id, :uid, :token])
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:provider_uid)
  end

  def for_user(query, %Kraken.User{} = user) do
    query |> where(user_id: ^user.id)
  end

  def for_provider(query, %Kraken.Provider{} = provider) do
    query |> where(provider_id: ^provider.id)
  end

  def expired?(%Kraken.Connection{} = connection) do
    connection.expires_at && connection.expires_at < Guardian.Utils.timestamp
  end
  def expired?(_), do: true

  def state(%Kraken.Connection{} = connection) do
    if expired?(connection) do
      "disconnected"
    else
      "connected"
    end
  end
  def state(_), do: nil
end
