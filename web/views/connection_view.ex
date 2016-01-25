defmodule Kraken.ConnectionView do
  use Kraken.Web, :view

  def fitbit_connection([]), do: nil
  def fitbit_connection(nil), do: nil
  def fitbit_connection(connections) do
    connections |> Enum.find(fn(c) -> c.provider == "fitbit" end)
  end

  def expired?(%Kraken.DataConnection{} = connection) do
    connection.expires_at && connection.expires_at < Guardian.Utils.timestamp
  end
  def expired?(_), do: true
end
