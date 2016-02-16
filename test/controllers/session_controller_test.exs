defmodule Kraken.SessionControllerTest do
  use Kraken.ConnCase

  setup do
    {:ok, %{user: insert_user}}
  end

  test "log in page renders when not currently logged in" do
    conn = get conn, session_path(conn, :new)

    assert html_response(conn, 200) =~ "Log in to Kraken"
  end

  test "log in page redirects to the dashboard if already logged on", %{user: user} do
    conn =
      user
      |> guardian_login
      |> get(session_path(conn, :new))

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
  end

  test "log in page with valid params redirects to dashboard", %{user: user} do
    assert Guardian.Plug.current_resource(conn) == nil

    login_params = %{session: %{email: user.email, password: "supersecret"}}
    conn = post conn, session_path(conn, :create), login_params

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
    assert Guardian.Plug.current_resource(conn).id == user.id
  end

  test "log in page with invalid params shows error" do
    login_params = %{session: %{email: "notvalid", password: "short"}}
    conn = post conn, session_path(conn, :create), login_params

    assert html_response(conn, 200) =~ "Could not log in with those credentials."
  end

  test "log out empties the current user", %{user: user} do
    conn =
      user
      |> guardian_login
      |> get("/")

    assert Guardian.Plug.current_resource(conn).id == user.id

    conn = delete recycle(conn), session_path(conn, :destroy)

    assert Guardian.Plug.current_resource(conn) == nil
  end

  test "log out page redirects to login when not logged in" do
    assert Guardian.Plug.current_resource(conn) == nil

    conn = delete recycle(conn), session_path(conn, :destroy)

    assert redirected_to(conn, 302) == page_path(conn, :index)
  end
end
