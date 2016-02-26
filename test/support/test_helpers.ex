defmodule Kraken.TestHelpers do
  use Timex

  alias Kraken.{Connection,Provider,Repo,User}

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "Some User",
      email: "user#{Base.encode16(:crypto.rand_bytes(8))}@example.com",
      password: "supersecret",
    }, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!
  end

  def insert_provider(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "provider#{Base.encode16(:crypto.rand_bytes(8))}",
      message: "message#{Base.encode16(:crypto.rand_bytes(8))}",
      state: "available",
    }, attrs)

    %Provider{}
    |> Provider.changeset(changes)
    |> Repo.insert!
  end

  def insert_connection(user, provider, attrs \\ %{}) do
    changes = Dict.merge(%{
      user_id: user.id,
      provider_id: provider.id,
      uid: "uid#{Base.encode16(:crypto.rand_bytes(8))}",
      token: "token#{Base.encode16(:crypto.rand_bytes(8))}",
      expires_at: (Date.now(:secs) + 10000)
    }, attrs)

    %Connection{}
    |> Connection.changeset(changes)
    |> Repo.insert!
  end
end
