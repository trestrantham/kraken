defmodule Kraken.Channels.UserChannelTest do
  use Kraken.ChannelCase
  import Kraken.TestHelpers

  setup do
    user = insert_user(name: "Penelope")
    token = Phoenix.Token.sign(@endpoint, "user socket", user.id)

    {:ok, socket} = connect(Kraken.UserSocket, %{"token" => token})

    {:ok, socket: socket, user: user}
  end

  test "join users channel", %{socket: socket, user: user} do
    {:ok, reply, socket} = subscribe_and_join(socket, "users:#{user.id}", %{})

    assert socket.assigns.user_id == user.id
    assert %{} = reply
  end
end
