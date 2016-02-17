defmodule Kraken.ConnectionView do
  use Kraken.Web, :view

  def connections_json(connections) do
    connections
    |> Poison.encode!
  end
end
