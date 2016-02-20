defmodule Kraken.Provider do
  defstruct name: nil, message: nil, state: nil

  @type t :: %__MODULE__{
    name: binary, message: binary, state: binary
  }

  @providers [
    %{
      name: "fitbit",
      message: "steps, weight",
      state: nil
    },
    %{
      name: "runkeeper",
      message: "workouts, weight",
      state: nil
    },
    %{
      name: "strava",
      message: "workouts, weight",
      state: "coming_soon"
    }
  ]

  def all do
    @providers
    |> Enum.map(fn provider ->
        %Kraken.Provider{
          name: provider.name,
          message: provider.message,
          state: provider.state
        }
      end)
  end

  def for_name(name) do
    all
    |> Enum.find(fn provider ->
      provider.name == name
    end)
  end
end
