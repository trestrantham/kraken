ExUnit.start
Faker.start

Mix.Task.run "ecto.create", ~w(-r Kraken.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Kraken.Repo --quiet)

Ecto.Adapters.SQL.Sandbox.mode(Kraken.Repo, :manual)
