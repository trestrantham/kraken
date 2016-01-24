defmodule Kraken.AddDataConnection do
  alias Kraken.DataConnection

  def call(auth, user, repo) do
    case auth_and_validate(auth, repo) do
      {:error, :not_found} -> connection_from_auth(auth, user, repo)
      {:error, reason}     -> {:error, reason}
      connection           ->
        if connection.expires_at && connection.expires_at < Guardian.Utils.timestamp do
          replace_connection(connection, auth, user, repo)
        end
        {:ok, connection}
    end
  end

  defp auth_and_validate(auth, repo) do
    case repo.get_by(DataConnection, uid: uid_from_auth(auth), provider: to_string(auth.provider)) do
      nil -> {:error, :not_found}
      connection ->
        if connection.token == auth.credentials.token do
          connection
        else
          {:error, :token_mismatch}
        end
    end
  end

  defp replace_connection(connection, auth, user, repo) do
    case repo.transaction(fn ->
      repo.delete(connection)
      connection_from_auth(user, auth, repo)
      user
    end) do
      {:ok, user} -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end

  defp connection_from_auth(auth, user, repo) do
    connection = Ecto.Model.build(user, :connections)
    result = DataConnection.changeset(
      connection,
      %{
        provider: to_string(auth.provider),
        uid: uid_from_auth(auth),
        token: token_from_auth(auth),
        refresh_token: auth.credentials.refresh_token,
        expires_at: auth.credentials.expires_at
      }
    ) |> repo.insert

    case result do
      {:ok, the_auth} -> the_auth
      {:error, reason} -> repo.rollback(reason)
    end
  end

  defp token_from_auth(auth), do: auth.credentials.token
  defp uid_from_auth(auth), do: auth.uid
end
