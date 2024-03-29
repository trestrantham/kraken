defmodule Kraken.Mixfile do
  use Mix.Project

  def project do
    [
      app: :kraken,
      version: "0.0.1",
      elixir: "~> 1.0",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases,
      deps: deps,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test]
    ]
  end

  def application do
    [
      mod: {Kraken, []},
      applications: applications(Mix.env)
    ]
  end

  def applications(env) when env in [:test] do
    applications(:default)
  end

  def applications(_) do
    [
      :comeonin,
      :cowboy,
      :fitbit,
      :gettext,
      :httpoison,
      :logger,
      :phoenix,
      :phoenix_ecto,
      :phoenix_html,
      :phoenix_pubsub,
      :postgrex,
      :tzdata,
      :ueberauth,
      :ueberauth_fitbit
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [
      {:comeonin, "~> 1.6"},
      {:cowboy, "~> 1.0"},
      {:credo, "~> 0.2", only: [:dev, :test]},
      {:ecto, git: "https://github.com/elixir-lang/ecto.git", override: true},
      {:faker, "~> 0.5", only: :test},
      {:fitbit, git: "https://github.com/trestrantham/fitbit.git"},
      {:excoveralls, "~> 0.4", only: :test},
      {:gettext, "~> 0.9"},
      {:guardian, "~> 0.9.0"},
      {:httpoison, "~> 0.8.1"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:phoenix, "~> 1.2.0-rc"},
      {:phoenix_ecto, "~> 3.0-rc"},
      {:phoenix_html, "~> 2.3"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0.0-rc"},
      {:poison, "~> 1.5.2"},
      {:postgrex, "~> 0.11.1"},
      {:timex, "~> 1.0"},
      {:ueberauth, "~> 0.2"},
      {:ueberauth_fitbit, "~> 0.2"}
    ]
  end

  defp aliases do
    [
      "ecto.setup": [
        "ecto.create",
        "ecto.migrate",
        "run priv/repo/seeds.exs"
      ],
      "ecto.reset": [
        "ecto.drop",
        "ecto.setup"
      ],
      "test": [
        "ecto.create --quiet",
        "ecto.migrate",
        "test"
      ]
    ]
  end
end
