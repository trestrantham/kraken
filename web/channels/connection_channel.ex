defmodule Kraken.ConnectionChannel do
  use Phoenix.Channel

  alias Kraken.{Connection,Provider,Repo}

  def join("connections:" <> _topic_name, _auth_msg, socket) do
    {:ok, socket}
  end

  def handle_in("loaded", %{"provider" => provider_name}, socket) do
    user = socket.assigns.current_user
    provider = provider_state(provider_state, user)

    if user && provider do
      broadcast! socket, "update", provider
    end

    {:noreply, socket}
  end

  defp provider_state(name, user) do
    provider =
      Provider
      |> Provider.for_name(name)
      |> Provider.status_for_user(user)
      |> Repo.first

    %{
      name: elem(provider, 0),
      message: elem(provider, 1),
      state: elem(provider, 2)
    }
  end
end
