defmodule Kraken.UserTest do
  use Kraken.ModelCase

  alias Kraken.User

  test "changeset with valid attributes" do
    changeset = User.changeset(
      %User{},
      %{
        name: "some content",
        email: "foo@example.com",
        password_hash: "secret"
      }
    )

    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, %{})

    refute changeset.valid?
  end

  test "registration_changeset with valid attributes" do
    changeset = User.changeset(
      %User{},
      %{
        name: "some content",
        email: "foo@example.com",
        password: "secret1"
      }
    )

    assert changeset.valid?
  end

  test "registration_changeset with invalid attributes" do
    changeset = User.registration_changeset(%User{}, %{})

    refute changeset.valid?
  end
end
