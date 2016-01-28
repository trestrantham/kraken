defmodule Kraken.Connection.Fitbit do
  use HTTPoison.Base

  alias Kraken.{User,DataConnection}

  def _get(%Kraken.User{} = user, url) do
    case User.provider_connection(user, "fitbit") do
      nil        -> {:error, "No fitbit token for this user"}
      connection ->
        token = connection.token
        if DataConnection.expired?(connection) do
          token = refresh_token(connection.token,connection.refresh_token)
        end
        
        {:ok, get(url, %{ "Authorization" => "Bearer #{token}"})}
    end
  end

  def refresh_token(token, _refresh_token) do
    token
  end

  defp process_url(url) do
    "https://api.fitbit.com/1" <> url
  end

  defp process_response_body(body) do
    body
    |> Poison.decode!
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end
end
