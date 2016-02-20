defmodule Kraken.ConnectionRepoTest do
  use Kraken.ModelCase
  use Timex

  alias Kraken.Connection

  setup do
    user1 = insert_user(%{name: "Kristoff"})
    user2 = insert_user(%{name: "Sven"})

    connection1 = insert_connection(user1, %{provider: "NSA"})
    connection2 = insert_connection(user2, %{provider: "NSA"})
    connection3 = insert_connection(user2, %{provider: "FBI"})

    {
      :ok,
      context: %{
        user1: user1,
        user2: user2,
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
      
    assert result == [context.connection1]

    result =
      Connection
      |> Connection.for_user(context.user2)
      |> Repo.all
      |> Enum.sort_by(&(&1))
      
    assert result == [context.connection2, context.connection3]
  end

  test "`for_provider` returns connections for the given provider", %{context: context} do
    result =
      Connection
      |> Connection.for_provider("NSA")
      |> Repo.all
      |> Enum.sort_by(&(&1))
      
    assert result == [context.connection1, context.connection2]

    result =
      Connection
      |> Connection.for_provider("FBI")
      |> Repo.all
      
    assert result == [context.connection3]
  end
end
