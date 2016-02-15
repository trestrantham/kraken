defmodule Kraken.ConnectionView do
  use Kraken.Web, :view

  def connections_json(connections) do
    connections
    |> Poison.encode!
  end

  def connection_for_type([], _), do: nil
  def connection_for_type(connections, connection_type) do
    connections
    |> Enum.find(fn(c) -> c.provider == connection_type end)
  end

  def expired?(%Kraken.Connection{} = connection) do
    connection.expires_at && connection.expires_at < Guardian.Utils.timestamp
  end
  def expired?(_), do: true
end
