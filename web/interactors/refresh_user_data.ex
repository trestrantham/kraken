defmodule Kraken.RefreshUserData do
  use Timex
  import Ecto.Query

  alias Kraken.{Connection,Repo}

  def call(user) do
    update_connection_tokens(user)

    for connection <- connections(user) do
      case connection.provider do
        "fitbit" ->
          update_fitbit_data(user)
      end
    end

    {:ok, :success}
  end

  def update_connection_tokens(user) do
    for connection <- connections(user) do
      if Connection.expired?(connection) do
        update_connection(connection)
      end
    end
  end

  def update_connection(connection) do
    case Fitbit.Authentication.refresh_token(connection.refresh_token) do
      {:ok, %Fitbit.Authentication{} = authentication} ->
        changeset = Connection.changeset(
          connection,
          %{
            token: authentication.access_token,
            refresh_token: authentication.refresh_token,
            expires_at: Date.now(:secs) + authentication.expires_in
          }
        )

        Repo.update(changeset)
      {:error, error} ->
        {:error, error}
    end
  end

  def update_fitbit_data(connection) do
    Fitbit.Activity.steps(
      connection.token,
      DateFormat.format(
        Date.now,
        "%Y-%-m-%d",
        :strftime
      ),
      "1y"
    )
  end

  defp connections(nil), do: []
  defp connections(%Kraken.User{} = user) do
    Connection
    |> where(user_id: ^user.id)
    |> Repo.all
  end
end
