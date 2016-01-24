defmodule Kraken.SessionControllerTest do
  use Kraken.ConnCase

  setup do
    {:ok, %{user: insert_user}}
  end

  test "GET :new when not logged in" do
    conn = get conn, session_path(conn, :new)

    assert html_response(conn, 200) =~ "Log in to Kraken"
  end

  test "GET :new when logged in", %{user: user} do
    conn = guardian_login(user)
    |> get(session_path(conn, :new))

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
  end

  test "POST :create when not logged in", %{user: user} do
    conn = conn
    |> post(session_path(conn, :create), %{session: %{email: user.email, password: "supersecret"}})

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
    assert Guardian.Plug.current_resource(conn).id == user.id
  end

  test "DELETE :destroy logs out the user when logged in", %{user: user} do
    conn = guardian_login(user)
    |> get("/")

    assert Guardian.Plug.current_resource(conn).id == user.id

    conn = delete recycle(conn), session_path(conn, :destroy)

    assert Guardian.Plug.current_resource(conn) == nil
  end

  test "DELETE :destroy redirects to login when not logged in" do
    assert Guardian.Plug.current_resource(conn) == nil

    conn = delete recycle(conn), session_path(conn, :destroy)

    assert redirected_to(conn, 302) == page_path(conn, :index)
  end
end
