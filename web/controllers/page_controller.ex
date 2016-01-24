defmodule Kraken.PageController do
  use Kraken.Web, :controller

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    path = if current_user do
        dashboard_path(conn, :index)
      else
        session_path(conn, :new)
      end

    conn |> redirect(to: path)
  end
end
