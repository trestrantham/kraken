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
    pipe_through :browser

    get  "/", PageController, :index
    get  "/dashboard", DashboardController, :index
    get  "/signup", UserController, :new
    post "/signup", UserController, :create
    get  "/login",  SessionController, :new
    post "/login",  SessionController, :create
  end
end
