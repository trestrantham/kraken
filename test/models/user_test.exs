defmodule Kraken.UserTest do
  use Kraken.ModelCase, async: true

  alias Kraken.User

  @valid_attrs %{name: Faker.Name.name, email: Faker.Internet.email}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)

    refute changeset.valid?
    assert errors_on(%User{}, @invalid_attrs) == [name: "can't be blank", email: "can't be blank"]
  end

  test "registration_changeset password must be at least 8 chars long" do
    attrs = Map.put(@valid_attrs, :password, "1234567")
    changeset = User.registration_changeset(%User{}, attrs)
    assert {:password, {"should be at least %{count} character(s)", count: 8}} 
      in changeset.errors
  end

  test "registration_changeset with valid attributes hashes password" do 
    attrs = Map.put(@valid_attrs, :password, "12345678")
    changeset = User.registration_changeset(%User{}, attrs)
    %{password: pass, password_hash: pass_hash} = changeset.changes

    assert changeset.valid?
    assert pass_hash
    assert Comeonin.Bcrypt.checkpw(pass, pass_hash)
  end
end
