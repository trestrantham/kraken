defmodule Kraken.ConnectionTest do
  use Kraken.ModelCase, async: true
  use Timex

  alias Kraken.Connection

  @valid_attrs %{
    provider_id: Ecto.UUID.generate,
    uid: "some content",
    user_id: Ecto.UUID.generate,
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

  test "`expired?` returns correct boolean" do
    expired = %Connection{expires_at: Date.now(:secs) - 10000}
    not_expired = %Connection{expires_at: Date.now(:secs) + 10000}

    assert Connection.expired?(expired)
    refute Connection.expired?(not_expired)
  end

  test "`state` returns the parsed state" do
    expired = %Connection{expires_at: Date.now(:secs) - 10000}
    connected = %Connection{expires_at: Date.now(:secs) + 10000}

    assert Connection.state(expired) == "disconnected"
    assert Connection.state(connected) == "connected"
    assert Connection.state(nil) == nil
  end
end
