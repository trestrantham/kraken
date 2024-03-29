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

  alias Kraken.{AddConnection,Provider}

  def index(conn, _params, current_user, _claims) do
    render conn, "index.html",
      current_user: current_user,
      providers: user_providers(current_user)
  end

  def request(conn, _params, current_user, _claims) do
    render conn, "index.html",
      current_user: current_user,
      providers: user_providers(current_user)
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params, current_user, _claims) do
    conn
    |> put_flash(:error, hd(fails.errors).message)
    |> render(
      "index.html",
      current_user: current_user,
      providers: user_providers(current_user)
    )
  end

  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params, current_user, _claims) do
    case AddConnection.call(auth, current_user) do
      {:ok, connection} ->
        connection = Repo.preload connection, :provider

        conn
        |> put_flash(:info, "#{connection.provider.name} was added successfully.")
      {:error, _errors} ->
        conn
        |> put_flash(:error, "There was a problem creating your account. Please check the highlighted fields below.")
    end

    render conn, "index.html",
      current_user: current_user,
      providers: user_providers(current_user)
  end

  defp user_providers(user) do
    Provider
    |> Provider.status_for_user(user)
    |> Repo.all
  end
end
