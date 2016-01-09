defmodule Sync.DashboardController do
  use Sync.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: __MODULE__

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "index.html", current_user: current_user
  end

  def unauthenticated(conn, params) do
    conn
    |> put_status(401)
    |> put_flash(:error, "You must log in to view that page.")
    |> redirect(to: session_path(conn, :new))
  end
end
