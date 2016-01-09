defmodule Sync.Router do
  use Sync.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", Sync do
    pipe_through :browser # Use the default browser stack

    get  "/", PageController, :index
  end
end
