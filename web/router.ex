defmodule Sync.Router do
  use Sync.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_auth do  
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end  

  scope "/", Sync do
    pipe_through [:browser, :browser_auth]

    # get  "/", PageController, :index
    get  "/",  SessionController, :new

    get  "/dashboard", DashboardController, :index
    get  "/signup", UserController, :new
    post "/signup", UserController, :create
    get  "/login",  SessionController, :new
    post "/login",  SessionController, :create
    delete "/logout",  SessionController, :destroy
  end
end
