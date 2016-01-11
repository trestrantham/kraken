defmodule Kraken.ControllerHelper do
  import Plug.Conn
  import Phoenix.Controller
  import Kraken.Router.Helpers

  def unauthenticated(conn, params) do
    conn
    |> put_status(401)
    |> put_flash(:error, "You must log in to view that page.")
    |> redirect(to: session_path(conn, :new))
  end
end
