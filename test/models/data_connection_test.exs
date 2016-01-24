defmodule Kraken.DataConnectionTest do
  use Kraken.ModelCase

  alias Kraken.DataConnection

  @valid_attrs %{
    provider: "some content",
    uid: "some content",
    user_id: 42,
    token: "some token"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DataConnection.changeset(%DataConnection{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DataConnection.changeset(%DataConnection{}, @invalid_attrs)
    refute changeset.valid?
  end
end
