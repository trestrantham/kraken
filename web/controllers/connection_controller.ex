defmodule Kraken.ConnectionController do
  @moduledoc """
  Handles the Überauth integration.
  This controller implements the request and callback phases for all providers.
  The actual creation and lookup of users/authorizations is handled by UserFromAuth
  """
  use Kraken.Web, :controller
  use Guardian.Phoenix.Controller

  plug Ueberauth
  plug Guardian.Plug.EnsureAuthenticated, [handler: Kraken.ControllerHelper] when action in [:index]

  alias Kraken.{AddConnection,Connection,Provider}

  def index(conn, _params, current_user, _claims) do
    render conn, "index.html",
      current_user: current_user,
      providers: providers(current_user)
  end

  def request(conn, _params, current_user, _claims) do
    render conn, "index.html",
      current_user: current_user,
      providers: providers(current_user)
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params, current_user, _claims) do
    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render(
      "index.html",
      current_user: current_user,
      providers: providers(current_user)
    )
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params, current_user, _claims) do
    case AddConnection.call(auth, current_user) do
      {:ok, connection} ->
        conn
        |> put_flash(:info, "#{connection.provider} was added successfully.")
      {:error, _errors} ->
        conn
        |> put_flash(:error, "There was a problem creating your account. Please check the highlighted fields below.")
    end

    render conn, "index.html",
      current_user: current_user,
      providers: providers(current_user)
  end

  defp providers(nil) do
    Provider.all
  end

  defp providers(%Kraken.User{} = user) do
    user_connections =
      user
      |> Ecto.assoc(:connections)
      |> Repo.all

    Provider.all
    |> Enum.map(fn(provider) ->
      lookup_connection(provider, user_connections)
    end)
  end

  defp lookup_connection(provider, user_connections) do
    connection =
      user_connections
      |> Enum.find(fn(c) ->
        c.provider == String.downcase(provider.name)
      end)

    if connection do
      state = Connection.state(connection)
      provider = Map.merge(provider, %{state: state})
    end

    provider
  end
end
