defmodule Kraken.Repo.Migrations.AddFitbitProviderData do
  use Ecto.Migration

  import Ecto.Query

  def change do
    fitbit =
      Kraken.Provider
      |> where(name: "fitbit")
      |> Kraken.Repo.first

    unless fitbit do
      %Kraken.Provider{
        name: "fitbit",
        message: "steps, weight",
        state: "available"
      }
      |> Kraken.Repo.insert!
    end
  end
end
