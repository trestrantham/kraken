defmodule Kraken.ConnectionController do
  @moduledoc """
  Handles the Überauth integration.
  This controller implements the request and callback phases for all providers.
  The actual creation and lookup of users/authorizations is handled by UserFromAuth
  """
  use Kraken.Web, :controller

  plug Ueberauth
  plug Guardian.Plug.EnsureAuthenticated, handler: Kraken.ControllerHelper

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render conn, "index.html",
      current_user: current_user,
      connections: Ecto.Model.assoc(current_user, :connections) |> Repo.all
  end

  def request(conn, _params, current_user, _claims) do
    render conn, "request.html",
      current_user: current_user,
      current_connections: connections(current_user)
  end

  # def callback(%Plug.Conn{assigns: %{ueberauth_failure: fails}} = conn, _params, current_user, _claims) do
  #   conn
  #   |> put_flash(:error, hd(fails.errors).message)
  #   |> render("login.html", current_user: current_user, current_auths: auths(current_user))
  # end

  # def callback(%Plug.Conn{assigns: %{ueberauth_auth: auth}} = conn, _params, current_user, _claims) do
  #   case UserFromAuth.get_or_insert(auth, current_user, Repo) do
  #     {:ok, user} ->
  #       conn
  #       |> put_flash(:info, "Signed in as #{user.name}")
  #       |> Guardian.Plug.sign_in(user, :token, perms: %{default: Guardian.Permissions.max})
  #       |> redirect(to: private_page_path(conn, :index))
  #     {:error, errors} ->
  #       IO.inspect errors
  #       conn
  #       |> put_flash(:error, "There was a problem creating your account. Please check the highlighted fields below.")
  #       |> render("login.html", current_user: current_user, current_auths: auths(current_user), errors: errors)
  #   end
  # end

  # def logout(conn, _params, current_user, _claims) do
  #   if current_user do
  #     conn
  #     # This clears the whole session.
  #     # We could use sign_out(:default) to just revoke this token
  #     # but I prefer to clear out the session. This means that because we
  #     # use tokens in two locations - :default and :admin - we need to load it (see above)
  #     |> Guardian.Plug.sign_out
  #     |> redirect(to: "/")
  #   else
  #     conn
  #     |> redirect(to: "/")
  #   end
  # end

  defp connections(nil), do: []
  defp connections(%Kraken.User{} = user) do
    Ecto.Model.assoc(user, :connections)
      |> Repo.all
      |> Enum.map(&(&1.provider))
  end
end
