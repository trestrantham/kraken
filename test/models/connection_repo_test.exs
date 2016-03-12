defmodule Kraken.ConnectionRepoTest do
  use Kraken.ModelCase
  use Timex

  alias Kraken.Connection

  setup do
    user1 = insert_user(%{name: "Kristoff"})
    user2 = insert_user(%{name: "Sven"})
    provider1 = insert_provider(%{name: "NSA"})
    provider2 = insert_provider(%{name: "FBI"})
    connection1 = insert_connection(user1, provider1)
    connection2 = insert_connection(user2, provider1)
    connection3 = insert_connection(user2, provider2)

    {
      :ok,
      context: %{
        user1: user1,
        user2: user2,
        provider1: provider1,
        provider2: provider2,
        connection1: connection1,
        connection2: connection2,
        connection3: connection3
      }
    }
  end

  test "`for_user` returns connections for the given user", %{context: context} do
    result =
      Connection
      |> Connection.for_user(context.user1)
      |> Repo.all
      
    assert comparison_values(result) == [comparison_value(context.connection1)]

    result =
      Connection
      |> Connection.for_user(context.user2)
      |> Repo.all
      |> Enum.sort_by(&(&1))
      
    assert comparison_values(result) == comparison_values([context.connection2, context.connection3])
  end

  test "`for_provider` returns connections for the given provider", %{context: context} do
    result =
      Connection
      |> Connection.for_provider(context.provider1)
      |> Repo.all
      |> Enum.sort_by(&(&1))
      
    assert comparison_values(result) == comparison_values([context.connection1, context.connection2])

    result =
      Connection
      |> Connection.for_provider(context.provider2)
      |> Repo.all
      
    assert comparison_values(result) == comparison_values([context.connection3])
  end

  defp comparison_value(connection) do
    %{
      provider_id: connection.provider_id,
      token: connection.token,
      refresh_token: connection.refresh_token
    }
  end
  defp comparison_values(connections) do
    connections
    |> Enum.map(fn connection ->
      comparison_value(connection)
    end)
    |> Enum.sort
  end
end
