defmodule Kraken.ProviderRepoTest do
  use Kraken.ModelCase
  alias Kraken.Provider

  setup do
    user = insert_user

    provider1 = insert_provider(%{name: "NSA", message: "foo"})
    provider2 = insert_provider(%{name: "FBI", message: "bar"})
    insert_provider(%{name: "CIA", message: "baz"})

    connection1 = insert_connection(user, provider1)
    connection2 = insert_connection(user, provider2)

    {
      :ok,
      context: %{
        user: user,
        provider1: provider1,
        provider2: provider2,
        connection1: connection1,
        connection2: connection2
      }
    }
  end

  test "`for_name` returns providers for the given name", %{context: context} do
    result =
      Provider
      |> Provider.for_name("NSA")
      |> Repo.all
      
    assert result == [context.provider1]

    result =
      Provider
      |> Provider.for_name("FBI")
      |> Repo.all
      
    assert result == [context.provider2]
  end

  test "`status_for_user` returns just providers when no user is given", %{context: _context} do
    result =
      Provider
      |> Provider.status_for_user(nil)
      |> Repo.all

    assert result == [
      {"NSA", "foo", "available"},
      {"FBI", "bar", "available"},
      {"CIA", "baz", "available"}
    ]
  end

  test "`status_for_user` returns providers with a state when user is given", %{context: context} do
    result =
      Provider
      |> Provider.status_for_user(context.user)
      |> Repo.all

    assert result == [
      {"NSA", "foo", "connected"},
      {"FBI", "bar", "connected"},
      {"CIA", "baz", "available"}
    ]
  end
end
