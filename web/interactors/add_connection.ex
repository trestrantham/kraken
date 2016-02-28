defmodule Kraken.AddConnection do
  import Ecto.Query, only: [select: 3]

  alias Kraken.{Connection,Provider,Repo}

  def call(auth, user) do
    case auth_and_validate(auth) do
      {:ok, connection} ->
        if Connection.expired?(connection) do
          replace_connection(connection, auth, user)
        else
          {:ok, connection}
        end

      {:error, :not_found} ->
        connection_from_auth(auth, user)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp auth_and_validate(auth) do
    case Repo.get_by(Connection, uid: auth.uid, provider_id: provider_id(auth.provider)) do
      nil -> {:error, :not_found}
      connection ->
        if connection.token == auth.credentials.token do
          {:ok, connection}
        else
          {:error, :token_mismatch}
        end
    end
  end

  # {:ok, connection} on success
  # {:error, reason} on failure
  defp replace_connection(connection, auth, user) do
    Repo.transaction(fn ->
      Repo.delete(connection)

      case connection_from_auth(auth, user) do
        {:ok, connection} ->
          {:ok, connection}
        {:error, reason} ->
          Repo.rollback
          {:error, reason}
      end
    end)
  end

  # {:ok, connection} on success
  # {:error, reason} on failure
  defp connection_from_auth(auth, user) do
    changes = Connection.changeset(
      %Connection{},
      %{
        provider_id: provider_id(auth.provider),
        uid: auth.uid,
        token: auth.credentials.token,
        refresh_token: auth.credentials.refresh_token,
        expires_at: auth.credentials.expires_at,
        user_id: user.id
      }
    )

    Repo.insert(changes)
  end

  defp provider_id(nil), do: nil
  defp provider_id(provider_name) do
    Provider
    |> Provider.for_name(provider_name)
    |> select([p], p.id)
    |> Repo.first
  end
end
