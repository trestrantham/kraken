defmodule Sync.UnauthenticatedControllerTest do
  use Sync.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Log in to Sync"
  end

  test "GET /login", %{conn: conn} do
    conn = get conn, "/login"
    assert html_response(conn, 200) =~ "Log in to Sync"
  end

  test "DELETE /logout", %{conn: conn} do
    conn = delete conn, "/logout"
    assert redirected_to(conn, 302) == session_path(conn, :new)
  end

  test "GET /dashboard", %{conn: conn} do
    conn = get conn, "/dashboard"
    assert get_flash(conn, :error) == "You must log in to view that page."
    assert redirected_to(conn, 401) == session_path(conn, :new)
  end
end
