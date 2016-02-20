defmodule Kraken.ConnectionView do
  use Kraken.Web, :view

  def providers_json(providers) do
    providers
    |> Poison.encode!
  end
end
