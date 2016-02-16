defmodule Kraken.Connection do
  use Kraken.Web, :model

  schema "connections" do
    field :provider, :string
    field :uid, :string
    field :token, :string
    field :refresh_token, :string
    field :expires_at, :integer
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    belongs_to :user, Kraken.User

    timestamps
  end

  @required_fields ~w(provider uid user_id token)
  @optional_fields ~w(refresh_token expires_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint(:provider_uid)
  end

  def for_user(query, %Kraken.User{} = user) do
    query |> where(user_id: ^user.id)
  end

  def for_provider(query, provider \\ "") do
    query |> where(provider: ^provider)
  end

  def expired?(%Kraken.Connection{} = connection) do
    connection.expires_at && connection.expires_at < Guardian.Utils.timestamp
  end
  def expired?(_), do: true

  def state(%Kraken.Connection{} = connection) do
    if expired?(connection) do
      "expired"
    else
      "connected"
    end
  end
  def state(_), do: nil
end