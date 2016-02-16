defmodule Kraken.ConnectionControllerTest do
  use Kraken.ConnCase

  test "lists all connections on index" do
    conn =
      insert_user
      |> guardian_login
      |> get(connection_path(conn, :index))

    assert html_response(conn, 200)
  end

  test "requires authentication on all actions" do
    conn = get conn, connection_path(conn, :index)

    assert redirected_to(conn, 401) == session_path(conn, :new)
  end
end
