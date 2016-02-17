defmodule Kraken.SessionControllerTest do
  use Kraken.ConnCase

  test "renders log in form" do
    conn = get conn, session_path(conn, :new)

    assert html_response(conn, 200) =~ "Log in to Kraken"
  end

  @tag :logged_in
  test "redirects if logged on", %{conn: conn} do
    conn = get conn, session_path(conn, :new)

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
  end

  test "logs in and redirects" do
    assert Guardian.Plug.current_resource(conn) == nil

    user = insert_user
    login_params = %{session: %{email: user.email, password: "supersecret"}}
    conn = post conn, session_path(conn, :create), login_params

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
    assert Guardian.Plug.current_resource(conn).id == user.id
  end

  test "does not log in and renders errors when invalid" do
    login_params = %{session: %{email: "notvalid", password: "short"}}
    conn = post conn, session_path(conn, :create), login_params

    assert html_response(conn, 200) =~ "Could not log in with those credentials."
  end

  @tag :logged_in
  test "log out empties the current user", %{conn: conn, user: user} do
    conn = get conn, "/"

    assert Guardian.Plug.current_resource(conn).id == user.id

    conn = delete recycle(conn), session_path(conn, :destroy)

    assert Guardian.Plug.current_resource(conn) == nil
  end

  test "logs user out and redirects" do
    assert Guardian.Plug.current_resource(conn) == nil

    conn = delete recycle(conn), session_path(conn, :destroy)

    assert redirected_to(conn, 302) == page_path(conn, :index)
  end
end
