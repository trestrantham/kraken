defmodule Kraken.ConnectionChannel do
  use Phoenix.Channel

  alias Kraken.{Connection,DataProvider}

  def join("connections:" <> _topic_name, _auth_msg, socket) do
    {:ok, socket}
  end

  def handle_in("loaded", %{"provider" => provider}, socket) do
    user = socket.assigns.current_user
    data_provider = DataProvider.for_name(provider)
    state = data_provider.state || "available"

    if user && data_provider do
      connection =
        Connection
        |> Connection.for_user(user)
        |> Connection.for_provider(provider)
        |> Repo.one

      if connection do
        state = Connection.state(connection)
      end

      data_provider = Map.merge(data_provider, %{state: state})

      broadcast! socket, "update", data_provider
    end

    {:noreply, socket}
  end
end
