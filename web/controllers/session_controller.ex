defmodule Sync.SessionController do
  use Sync.Web, :controller
  plug :put_layout, "chromeless.html"
  alias Sync.User

  def new(conn, _params) do
    render conn, "new.html", email: ""
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    case Sync.Auth.validate_email_and_password(email, password) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> redirect(to: dashboard_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Could not log in with those credentials.")
        |> render "new.html", email: email
    end  
  end
end
