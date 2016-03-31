defmodule Kraken.ProviderView do
  use Kraken.Web, :view

  def render("provider.json", %{provider: provider}) do
    %{
      name: provider.name,
      message: provider.message,
      state: provider.state
    }
  end
end
