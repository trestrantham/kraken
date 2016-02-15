defmodule Kraken.ConnectionController do
  @moduledoc """
  Handles the Überauth integration.
  This controller implements the request and callback phases for all providers.
  The actual creation and lookup of users/authorizations is handled by UserFromAuth
  """
  use Kraken.Web, :controller
  use Guardian.Phoenix.Controller

  plug Ueberauth

  alias Kraken.AddConnection

  def index(conn, _params, current_user, _claims) do
    render conn, "index.html",
      current_user: current_user,
      connections: connections(current_user)
  end

  def request(conn, _params, current_user, _claims) do
    render conn, "index.html",
      current_user: current_user,
      connections: connections(current_user)
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params, current_user, _claims) do
    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render("index.html", current_user: current_user, connections: connections(current_user))
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
      connections: connections(current_user)
  end

  defp connections(nil) do
    Kraken.DataProvider.all
    |> Enum.map(fn(provider) ->
      state = provider[:state] || "available"
      Map.merge(provider, %{state: state})
    end)
  end

  defp connections(%Kraken.User{} = user) do
    user_connections =
      user
      |> Ecto.Model.assoc(:connections)
      |> Repo.all

    Kraken.DataProvider.all
    |> Enum.map(fn(provider) ->
      lookup_connection(provider, user_connections)
    end)
  end

  defp lookup_connection(provider, user_connections) do
    state = provider.state || "available"

    connection =
      user_connections
      |> Enum.find(fn(c) ->
        c.provider == String.downcase(provider)
      end)

    if connection do
      if Kraken.User.expired?(connection) do
        state = "expired"
      else
        state = "connected"
      end
    end

    Map.merge(provider, %{state: state})
  end
end
