defmodule Kraken.ModelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Kraken.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
      import Kraken.TestHelpers
      import Kraken.ModelCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Kraken.Repo)

    :ok
  end

  def errors_on(model, data) do
    model.__struct__.changeset(model, data).errors
  end
end
