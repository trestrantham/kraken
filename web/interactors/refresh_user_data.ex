defmodule Kraken.RefreshUserData do
  use Timex
  import Ecto.Query

  alias Kraken.{DataConnection,Repo}

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
      if connection.expires_at && connection.expires_at < Date.now(:secs) do
        update_connection(connection)
      end
    end
  end

  def update_connection(connection) do
    case Repo.transaction(fn ->
      case Fitbit.Authentication.refresh_token(connection.refresh_token) do
        {:ok, %Fitbit.Authentication{} = authentication} ->
          changeset = DataConnection.changeset(
            connection,
            %{
              token: authentication.access_token,
              refresh_token: authentication.refresh_token,
              expires_at: Date.now(:secs) + authentication.expires_in
            }
          )

          case Repo.update(changeset) do
            {:ok, connection} ->
              connection
            {:error, error} ->
              Repo.rollback(error)
          end
        {:error, error} ->
          Repo.rollback(error)
      end
    end) do
      {:ok, connection} -> {:ok, connection}
      {:error, reason}  -> {:error, reason}
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
    DataConnection
    |> where(user_id: ^user.id)
    |> Repo.all
  end
end
