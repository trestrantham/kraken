defmodule Kraken.SessionController do
  use Kraken.Web, :controller
  plug :put_layout, "chromeless.html"
  alias Kraken.User

  def new(conn, _params) do
    render conn, "new.html", email: ""
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
    |> redirect(to: session_path(conn, :new))
  end
end
