defmodule Kraken.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Kraken.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

      import Kraken.Router.Helpers
      import Kraken.TestHelpers

      # The default endpoint for testing
      @endpoint Kraken.Endpoint

      # We need a way to get into the connection to login a user
      # We need to use the bypass_through to fire the plugs in the router
      # and get the session fetched.
      def guardian_login(user, token \\ :token, opts \\ []) do
        conn()
        |> bypass_through(Kraken.Router, [:browser, :browser_auth])
        |> get("/")
        |> Guardian.Plug.sign_in(user, token, opts)
        |> send_resp(200, "Flush the session")
        |> recycle()
      end
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Kraken.Repo, [])
    end

    {:ok, conn: Phoenix.ConnTest.conn()}
  end
end
