defmodule Kraken.UserControllerTest do
  use Kraken.ConnCase

  test "GET :new when not logged in" do
    conn = get conn, user_path(conn, :new)

    assert html_response(conn, 200) =~ "Create an account for Kraken"
  end

  test "GET :new when logged in" do
    conn =
      insert_user
      |> guardian_login
      |> get(user_path(conn, :new))

    assert redirected_to(conn, 302) == dashboard_path(conn, :index)
  end
end
