defmodule Kraken.TestHelpers do
  alias Kraken.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some User",
      email: "user#{Base.encode16(:crypto.rand_bytes(8))}@example.com",
      password: "supersecret",
    }, attrs)

    %Kraken.User{}
    |> Kraken.User.registration_changeset(changes)
    |> Repo.insert!()
  end
end