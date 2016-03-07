defmodule Kraken.UserSocket do
  use Phoenix.Socket

  alias Kraken.{Repo, User}

  channel "users:*", Kraken.UserChannel

  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: 3600) do
      {:ok, user_id} ->
        socket = assign(socket, :current_user, Repo.get!(User, user_id))

        {:ok, socket}
      {:error, _} ->
        :error
    end
  end
  def connect(_params, _socket), do: :error

  def id(socket) do
    "users_socket:#{socket.assigns.current_user.id}"
  end
end
