defmodule Kraken.ConnectionChannel do
  use Phoenix.Channel

  alias Kraken.{DataConnection,DataProvider}

  def join("connections:" <> _topic_name, _auth_msg, socket) do
    {:ok, socket}
  end

  def handle_in("loaded", %{"provider" => provider}, socket) do
    user = socket.assigns.current_user
    data_provider = DataProvider.for_name(provider)
    state = data_provider.state || "available"

    if user && data_provider do
      connection = DataConnection.for_user_and_provider(user, provider)

      if connection do
        state = DataConnection.state(connection)
      end

      data_provider = Map.merge(data_provider, %{state: state})

      broadcast! socket, "update", data_provider
    end

    {:noreply, socket}
  end

  # def handle_in("message", %{"body" => body}, socket) do
  #   broadcast! socket, "message", %{body: body}
  #   {:noreply, socket}
  # end
end
