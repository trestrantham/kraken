defmodule Kraken.ConnectionTest do
  use Kraken.ModelCase

  alias Kraken.Connection

  @valid_attrs %{
    provider: "some content",
    uid: "some content",
    user_id: 42,
    token: "some token"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Connection.changeset(%Connection{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Connection.changeset(%Connection{}, @invalid_attrs)
    refute changeset.valid?
  end
end
