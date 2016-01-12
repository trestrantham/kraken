defmodule Kraken.User do
  use Kraken.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :password_hash, :string

    field :password, :string, virtual: true

    has_many :connections, Kraken.DataConnection

    timestamps
  end

  @required_fields ~w(name email)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/, message: "address is invalid")
    |> unique_constraint(:email, message: "address already taken")
  end

  def registration_changeset(model, params) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 8, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
