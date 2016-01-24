defmodule Kraken.PageControllerTest do
  use Kraken.ConnCase

  test "redirects to login if user is unauthenticated", %{conn: conn} do
    conn = get conn, "/"

    assert redirected_to(conn, 302) == session_path(conn, :new)
  end

  test "redirects to dashboard if user is authenticated" do
    conn = guardian_login(insert_user)
    |> get("/")

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
  end
end
