defmodule Kraken.ConnectionController do
  @moduledoc """
  Handles the Überauth integration.
  This controller implements the request and callback phases for all providers.
  The actual creation and lookup of users/authorizations is handled by UserFromAuth
  """
  use Kraken.Web, :controller
  use Guardian.Phoenix.Controller

  plug Ueberauth

  alias Kraken.AddDataConnection

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

  # def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params, current_user, _claims) do
  def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params, current_user, _claims) do
    case AddDataConnection.call(auth, current_user, Repo) do
      {:ok, connection} ->
        conn
        |> put_flash(:info, "Signed in as #{connection.user.name}")
      {:error, _errors} ->
        conn
        |> put_flash(:error, "There was a problem creating your account. Please check the highlighted fields below.")
    end

    render conn, "index.html",
      current_user: current_user,
      connections: connections(current_user)
  end

  defp connections(nil), do: []
  defp connections(%Kraken.User{} = user) do
    Ecto.Model.assoc(user, :connections) |> Repo.all
  end
end
