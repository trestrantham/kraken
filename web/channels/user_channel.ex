defmodule Kraken.UserChannel do
  use Phoenix.Channel

  alias Kraken.{Provider,Repo,UpdateConnection}

  def join("users:" <> user_token, _auth_msg, socket) do
    if socket.assigns.user_token == user_token do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("connections:loaded", %{"provider" => provider_name}, socket) do
    user = socket.assigns.current_user
    provider = provider_state(provider_name, user)

    if user && provider do
      push socket, "connections:update", provider
    end

    {:noreply, socket}
  end

  def handle_in("connections:reconnect", %{"provider" => provider_name}, socket) do
    user = socket.assigns.current_user

    UpdateConnection.call(user, provider_name)

    {:noreply, socket}
  end

  defp provider_state(name, user) do
    Provider
    |> Provider.for_name(name)
    |> Provider.status_for_user(user)
    |> Repo.first
  end
end
