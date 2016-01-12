# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :kraken, Kraken.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "SKdi7uJ6I40Waja9LluRBOJ1/MOL6NjVRaYhGdtV+0loC1MgpB/f3OPPBgxhfZb8",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Kraken.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :guardian, Guardian,
  issuer: "Kraken",
  ttl: { 30, :days },
  verify_issuer: true,
  secret_key: "IIR4Ghbcu-4%ElRK1X)9$onCcA12c04@@f8S3C^sHJc!D7w##L1%i301w20q6&RG",
  serializer: Kraken.Authorization.GuardianSerializer

config :ueberauth, Ueberauth,
  base_path: "/connection",
  providers: [
    fitbit: {Ueberauth.Strategy.Fitbit, []},
  ]

  consumer_key: System.get_env("FITBIT_CLIENT_ID"),
  consumer_secret: System.get_env("FITBIT_CLIENT_SECRET")
config :ueberauth, Ueberauth.Strategy.Fitbit.OAuth,
