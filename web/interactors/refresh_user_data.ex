defmodule Kraken.RefreshUserData do
  import Ecto.Query
  import Fitbit.Authentication

  alias Kraken.{User,DataConnection,Repo}

  def call(user) do
    update_connection_tokens(user)
    # sync_connection_data


    {:ok, :success}
  end

  def update_connection_tokens(user) do
    for connection <- connections(user) do
      if connection.expires_at && connection.expires_at < Date.now(:secs) do
        replace_connection(connection, user)
      end
    end
  end

  def replace_connection(connection, user) do
    case Repo.transaction(fn ->

      case Fitbit.Authentication.refresh_token(connection.refresh_token) do
        {:ok, %Fitbit.Authentication{} = authentication} ->
          changeset = DataConnection.changeset(
            connection,
            %{
              access_token: authentication.access_token,
              refresh_token: authentication.refresh_token,
              expires_at: Timex.now(:secs) + authentication.expires_in
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

  defp connections(nil), do: []
  defp connections(%Kraken.User{} = user) do
    DataConnection
    |> where(user_id: ^user.id)
    |> Repo.all
  end
end
