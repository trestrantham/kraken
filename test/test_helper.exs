ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Sync.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Sync.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Sync.Repo)

