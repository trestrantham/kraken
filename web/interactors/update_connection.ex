defmodule Kraken.UpdateConnection do
  import Ecto.Query

  alias Kraken.{Connection,Provider,Repo,User}

  def call(%User{} = user, provider_name) do
    provider_name = to_string(provider_name)

    connection =
      user
      |> Connection.for_user
      |> Connection.for_provider_name(provider_name)
      |> preload(:provider)
      |> Repo.first

    if connection do
      provider = connection.provider

      case update_connection(provider_name, connection) do
        {:ok, connection} ->
          broadcast_update(user, provider, "updating")
          {:ok, connection}
        {:error, _reason} ->
          broadcast_update(user, provider, "disconnected")
      end
    else
      {:error, :not_found}
    end
  end

  def update_connection("fitbit", connection) do
    case Fitbit.Authentication.refresh_token(connection.refresh_token) do
      {:ok, %Fitbit.Authentication{} = authentication} ->
        changeset = Connection.changeset(
          connection,
          %{
            token: authentication.access_token,
            refresh_token: authentication.refresh_token,
            expires_at: Date.now(:secs) + authentication.expires_in - 300 # 5 min buffer
          }
        )

        Repo.update(changeset)
      {:error, error} ->
        {:error, error}
    end
  end

  defp broadcast_update(%User{} = user, %Provider{} = provider, state) do
    Kraken.Endpoint.broadcast(
      "users:" <> user.id,
      provider.name <> ":connection_update",
      %{
        name: provider.name,
        message: provider.message,
        state: state
      }
    )
  end
end
