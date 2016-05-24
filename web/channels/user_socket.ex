defmodule Kraken.UserSocket do
  use Phoenix.Socket

  channel "users:*", Kraken.UserChannel

  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  @max_age 60 * 60 # 1 hour

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user socket", token, max_age: @max_age) do
      {:ok, user_id} ->
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _} ->
        :error
    end
  end
  def connect(_params, _socket), do: :error

  def id(socket) do
    "users_socket:#{socket.assigns.user_id}"
  end
end
