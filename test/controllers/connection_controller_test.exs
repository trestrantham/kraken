defmodule Kraken.ConnectionControllerTest do
  use Kraken.ConnCase

  setup %{conn: conn} = config do
    if email = config[:login_as] do
      user = insert_user(email: email)
      conn = guardian_login(user)

      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  @tag login_as: "sven@rivendell.com"
  test "lists all connections on index", %{conn: conn, user: user} do
    insert_connection(user, %{provider: "fitbit"})
    insert_connection(user, %{provider: "runkeeper"})
    insert_connection(insert_user, %{provider: "strava"})

    conn = get(conn, connection_path(conn, :index))

    assert html_response(conn, 200) =~ ~r/Connections/
    assert String.contains?(conn.resp_body, "fitbit")
    assert String.contains?(conn.resp_body, "runkeeper")
    # refute String.contains?(conn.resp_body, "strava")
  end

  test "requires authentication on all actions" do
    conn = get conn, connection_path(conn, :index)

    assert redirected_to(conn, 401) == session_path(conn, :new)
  end
end
