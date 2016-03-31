defmodule Kraken.UserChannel do
  use Phoenix.Channel

  alias Kraken.{Provider,ProviderView,Repo,UpdateConnection}

  def join("users:" <> user_id, _auth_msg, socket) do
    if socket.assigns.user_id == user_id do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in(event, params, socket) do
    user = Repo.get(Kraken.User, socket.assigns.user_id)
    handle_in(event, params, user, socket)
  end

  def handle_in("connections:loaded", %{"provider" => provider_name}, user, socket) do
    provider =
      Provider
      |> Provider.for_name(provider_name)
      |> Provider.status_for_user(user)
      |> Repo.first

    if provider do
      payload = %{provder: ProviderView.render("provider.json", %{provder: provider})}

      push socket, "connections:update", payload
    end

    {:noreply, socket}
  end

  def handle_in("connections:reconnect", %{"provider" => provider_name}, user, socket) do
    UpdateConnection.call(user, provider_name)

    {:noreply, socket}
  end
end
