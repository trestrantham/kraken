defmodule Kraken.AddConnection do
  alias Kraken.{Connection,Repo}

  def call(auth, user) do
    case auth_and_validate(auth) do
      {:error, :not_found} -> connection_from_auth(auth, user)
      {:error, reason}     -> {:error, reason}
      connection           ->
        if Connection.expired?(connection) do
          replace_connection(connection, auth, user)
        end
        {:ok, connection}
    end
  end

  defp auth_and_validate(auth) do
    case Repo.get_by(Connection, uid: auth.uid, provider: to_string(auth.provider)) do
      nil -> {:error, :not_found}
      connection ->
        if connection.token == auth.credentials.token do
          connection
        else
          {:error, :token_mismatch}
        end
    end
  end

  defp replace_connection(connection, auth, user) do
    case Repo.transaction(fn ->
      Repo.delete(connection)
      connection_from_auth(user, auth)
      user
    end) do
      {:ok, user}      -> {:ok, user}
      {:error, reason} -> {:error, reason}
    end
  end

  defp connection_from_auth(auth, user) do
    changes = Connection.changeset(
      %Connection{},
      %{
        provider: to_string(auth.provider),
        uid: auth.uid,
        token: auth.credentials.token,
        refresh_token: auth.credentials.refresh_token,
        expires_at: auth.credentials.expires_at,
        user_id: user.id
      }
    )

    case Repo.insert(changes) do
      {:ok, the_auth} ->
        {:ok, the_auth}
      {:error, reason} ->
        Repo.rollback(reason)
        {:error, reason}
    end
  end
end
