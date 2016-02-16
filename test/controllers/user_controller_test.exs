defmodule Kraken.UserControllerTest do
  use Kraken.ConnCase

  setup do
    {:ok, %{user: insert_user}}
  end

  test "register page renders when not currently logged in" do
    conn = get conn, user_path(conn, :new)

    assert html_response(conn, 200) =~ "Create an account for Kraken"
  end

  test "register page redirects to the dashboard if already logged on", %{user: user} do
    conn =
      user
      |> guardian_login
      |> get(user_path(conn, :new))

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
  end

  test "register page with valid params redirects to dashboard" do
    assert Guardian.Plug.current_resource(conn) == nil

    register_params = %{user: %{name: "Sven Rivendell", email: "sven@rivendell.com", password: "supersecret"}}
    conn = post conn, user_path(conn, :create), register_params

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
    refute Guardian.Plug.current_resource(conn) == nil
  end

  test "log in page with invalid params shows error" do
    register_params = %{user: %{email: "notvalid", password: "short"}}
    conn = post conn, user_path(conn, :create), register_params

    assert html_response(conn, 200) =~ "email address is invalid"
  end
end
