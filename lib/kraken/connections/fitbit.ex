defmodule Kraken.Connection.Fitbit do
  use HTTPoison.Base

  alias Kraken.{User,DataConnection}

  def query(%Kraken.User{} = user, url) do
    case User.provider_connection(user, "fitbit") do
      nil        -> {:error, "No fitbit token for this user"}
      connection ->
        token = connection.token
        if DataConnection.expired?(connection) do
          token = refresh_token(connection.refresh_token)
        end
        
        case get("/1#{url}", %{"Authorization" => "Bearer #{token}"}) do
          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            Poison.decode(body)
          {:ok, %HTTPoison.Response{status_code: 404}} ->
            IO.puts "Not found :("
          {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
            IO.puts "Bad request :("
            IO.puts body
          {:error, %HTTPoison.Error{reason: reason}} ->
            IO.inspect reason
        end
    end
  end

  def refresh_token(refresh_token) do
    case post "/oauth2/token",
      {
        :form,
        [
          {:grant_type, "refresh_token"},
          {:refresh_token, refresh_token}
        ]
      },
      %{
        "Authorization" => "Basic #{basic_auth}",
        "Content-Type" => "application/x-www-form-urlencoded"
      } do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        IO.puts "Bad request :("
        IO.puts body
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp process_url(url) do
    "https://api.fitbit.com" <> url
  end

  defp basic_auth do
    client_id = System.get_env("FITBIT_CLIENT_ID")
    client_secret = System.get_env("FITBIT_CLIENT_SECRET")

    Base.encode64("#{client_id}:#{client_secret}")
  end

  # defp process_response_body(body) do
  #   IO.inspect(body)
  #   body
  #   |> Poison.decode!
  #   |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  # end
end
