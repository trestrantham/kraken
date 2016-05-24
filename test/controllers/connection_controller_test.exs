defmodule Kraken.ConnectionControllerTest do
  use Kraken.ConnCase
  use Timex

  alias Kraken.Provider

  @tag :logged_in
  test "lists all available connections on index", %{conn: conn} do
    insert_provider

    conn = get conn, connection_path(conn, :index)

    assert html_response(conn, 200) =~ ~r/Connections/

    for provider <- Repo.all(Provider) do
      assert String.contains?(conn.resp_body, provider.name)
    end

    assert String.contains?(conn.resp_body, "available")
    refute String.contains?(conn.resp_body, "connected")
    refute String.contains?(conn.resp_body, "disconnected")
  end

  @tag :logged_in
  test "shows connected connections on index", %{conn: conn, user: user} do
    provider = insert_provider
    insert_connection(user, provider, %{expires_at: Date.now(:secs) + 10000})

    conn = get conn, connection_path(conn, :index)

    assert html_response(conn, 200) =~ ~r/Connections/
    assert String.contains?(conn.resp_body, "connected")
    refute String.contains?(conn.resp_body, "disconnected")
  end

  @tag :logged_in
  test "shows expired connections on index", %{conn: conn, user: user} do
    provider = insert_provider
    insert_connection(user, provider, %{expires_at: 0})

    conn = get conn, connection_path(conn, :index)

    assert html_response(conn, 200) =~ ~r/Connections/
    assert String.contains?(conn.resp_body, "disconnected")
    # refute String.contains?(conn.resp_body, "connected")
  end

  test "requires authentication on all actions", %{conn: conn} do
    conn = get conn, connection_path(conn, :index)

    assert redirected_to(conn, 401) == session_path(conn, :new)
  end
end
