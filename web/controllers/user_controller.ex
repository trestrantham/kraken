defmodule Kraken.UserController do
  use Kraken.Web, :controller

  plug :put_layout, "chromeless.html"

  alias Kraken.User

  def new(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    if current_user do
      redirect(conn, to: dashboard_path(conn, :index))
    else
      changeset = User.changeset(%User{})

      render conn, "new.html", changeset: changeset
    end
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: dashboard_path(conn, :index))
      {:error, changeset} ->
        render conn, "new.html", changeset: changeset
    end
  end
end
