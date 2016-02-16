defmodule Kraken.UserControllerTest do
  use Kraken.ConnCase

  alias Kraken.{Repo,User}

  setup %{conn: conn} = config do
    if email = config[:login_as] do
      user = insert_user(email: email)
      conn = guardian_login(user)

      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "renders registration form" do
    conn = get conn, user_path(conn, :new)

    assert html_response(conn, 200) =~ "Create an account for Kraken"
  end

  @tag login_as: "sven@rivendell.com"
  test "redirects if logged in", %{conn: conn, user: _user} do
    conn = get(conn, user_path(conn, :new))

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
  end

  test "creates user and redirects" do
    assert Guardian.Plug.current_resource(conn) == nil

    register_params = %{user: %{name: "Sven Rivendell", email: "sven@rivendell.com", password: "supersecret"}}
    conn = post conn, user_path(conn, :create), register_params

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
    assert Repo.get_by!(User, email: register_params.user.email).id == Guardian.Plug.current_resource(conn).id
  end

  test "log in page with invalid params shows error" do
    register_params = %{user: %{email: "notvalid", password: "short"}}
    conn = post conn, user_path(conn, :create), register_params

    assert html_response(conn, 200) =~ "email address is invalid"
  end
end
