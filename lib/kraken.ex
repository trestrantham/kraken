defmodule Kraken do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Kraken.Endpoint, []),
      supervisor(Kraken.Repo, []),
    ]

    opts = [strategy: :one_for_one, name: Kraken.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    Kraken.Endpoint.config_change(changed, removed)
    :ok
  end
end
