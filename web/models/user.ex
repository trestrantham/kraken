defmodule Kraken.User do
  use Kraken.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true

    has_many :connections, Kraken.Connection

    timestamps
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, message: "address is invalid")
    |> unique_constraint(:email)
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changes) do
    case changes do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changes, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changes
    end
  end
end
