defmodule Kraken.ConnectionChannel do
  use Phoenix.Channel

  alias Kraken.{Connection,Provider,Repo}

  def join("connections:" <> _topic_name, _auth_msg, socket) do
    {:ok, socket}
  end

  def handle_in("loaded", %{"provider" => provider_name}, socket) do
    user = socket.assigns.current_user
    provider = Provider.for_name(provider_name)
    state = provider.state || "available"

    if user && provider do
      connection =
        Connection
        |> Connection.for_user(user)
        |> Connection.for_provider(provider_name)
        |> Repo.one

      if connection do
        state = Connection.state(connection)
      end

      provider = Map.merge(provider, %{state: state})

      broadcast! socket, "update", provider
    end

    {:noreply, socket}
  end
end
