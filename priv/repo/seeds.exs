# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kraken.Repo.insert!(%Kraken.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# fitbit =
#   Kraken.Provider
#   |> where(name: "fitbit")
#   |> Kraken.Repo.first

# unless fitbit do
#   %Kraken.Provider{
#     name: "fitbit",
#     message: "steps, weight",
#     state: "available"
#   }
#   |> Kraken.Repo.insert!
# end
