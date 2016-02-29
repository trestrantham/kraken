defmodule Kraken.Provider do
  use Kraken.Web, :model

  alias Kraken.{Connection,User}

  schema "providers" do
    field :name, :string
    field :message, :string
    field :state, :string

    has_many :connections, Connection

    timestamps
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:name, :message, :state])
    |> validate_required([:name, :message, :state])
  end

  def for_name(query, name \\ "") do
    name = to_string(name)
    query |> where(name: ^name)
  end

  def status_for_user(query, %User{} = user) do
    query
    |> join(:left, [p], c in Connection, p.id == c.provider_id and c.user_id == ^user.id)
    |> select([p, c], %{name: p.name, message: p.message, state: fragment("CASE WHEN ? IS NULL THEN ? WHEN extract(epoch from now()) <= ? THEN 'connected' ELSE 'disconnected' END AS state", c.expires_at, p.state, c.expires_at)})
  end
  def status_for_user(query, _) do
    query
    |> select([p], %{name: p.name, message: p.message, state: p.state})
  end
end
