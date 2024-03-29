defmodule Kraken.DashboardControllerTest do
  use Kraken.ConnCase

  test "GET :index without being authenticated", %{conn: conn} do
    conn = get conn, dashboard_path(conn, :index)

    assert redirected_to(conn, 401) == session_path(conn, :new)
  end

  @tag :logged_in
  test "GET :index with a user that is logged in", %{conn: conn} do
    conn = get conn, dashboard_path(conn, :index)

    assert html_response(conn, 200)
  end
end
