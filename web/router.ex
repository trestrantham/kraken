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
    plug :put_user_token
  end

  scope "/", Kraken do
    pipe_through [:browser, :browser_auth]

    get  "/", PageController, :index

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

  defp put_user_token(conn, _) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end
end
