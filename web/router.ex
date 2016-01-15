defmodule Kraken.Router do
  use Kraken.Web, :router

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

  scope "/", Kraken do
    pipe_through [:browser, :browser_auth]

    # get  "/", PageController, :index
    get  "/",  SessionController, :new

    get  "/signup", UserController, :new
    post "/signup", UserController, :create
    get  "/login",  SessionController, :new
    post "/login",  SessionController, :create
    delete "/logout",  SessionController, :destroy

    get  "/dashboard", DashboardController, :index
    get  "/connections", ConnectionController, :index
  end

  scope "/connection", Kraken do
    pipe_through [:browser, :browser_auth]

    get "/:identity", ConnectionController, :request
    get "/:identity/callback", ConnectionController, :callback
    post "/:identity/callback", ConnectionController, :callback
  end
end
