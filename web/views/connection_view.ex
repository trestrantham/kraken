defmodule Kraken.ConnectionView do
  use Kraken.Web, :view

  def connections_json(user_connections) do
    ["fitbit", "runkeeper"]
    |> Enum.map(fn(connection_type) ->
      connection = connection_for_type(user_connections, connection_type) || %{state: false}

      %{
        name: connection_type,
        state: connection.state || "available"
      }
    end)
    |> Poison.encode!
  end

  def connection_for_type([], _), do: nil
  def connection_for_type(connections, connection_type) do
    connections
    |> Enum.find(fn(c) -> c.provider == connection_type end)
  end

  def expired?(%Kraken.DataConnection{} = connection) do
    connection.expires_at && connection.expires_at < Guardian.Utils.timestamp
  end
  def expired?(_), do: true
end
