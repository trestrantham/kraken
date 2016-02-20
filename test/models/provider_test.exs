defmodule Kraken.ProviderTest do
  use Kraken.ModelCase, async: true

  alias Kraken.Provider

  test "`all` returns a list of all available Providers" do
    Provider.all
    |> Enum.each(fn provider ->
      assert provider.__struct__ == Kraken.Provider
    end)
  end

  test "`for_name` returns a matching Provider or nil" do
    assert Provider.for_name("fitbit").__struct__ == Kraken.Provider
    assert Provider.for_name("none") == nil
  end
end
