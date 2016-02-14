defmodule Kraken.SessionController do
  use Kraken.Web, :controller

  plug :put_layout, "chromeless.html"

  def new(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      redirect(conn, to: dashboard_path(conn, :index))
    else
      render conn, "new.html", email: ""
    end
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Kraken.Auth.validate_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: dashboard_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Could not log in with those credentials.")
        |> render("new.html", email: email)
    end
  end

  def destroy(conn, _params) do
    conn
    |> Guardian.Plug.sign_out
    |> redirect(to: page_path(conn, :index))
  end
end
