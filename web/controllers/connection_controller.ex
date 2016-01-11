defmodule Kraken.ConnectionController do
  use Kraken.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Kraken.ControllerHelper
  plug Ueberauth

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "index.html", current_user: current_user
  end
end
