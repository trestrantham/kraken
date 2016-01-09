defmodule Sync.DashboardController do
  use Sync.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
