defmodule Sync.SharedHelpers do
  import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 1, get_flash: 2, view_module: 1]
  import Phoenix.HTML
  import Sync.ErrorHelpers

  def auth_error_class(errors \\ [], field) do
    if errors != [] && Dict.has_key?(errors, field) do
      " has-error"
    else
      ""
    end
  end

  def form_error_message(errors \\ [], field) do
    if message = errors[field] do
      raw "<p><small class=\"error\">#{field} #{translate_error(message)}</small></p>"
    end
  end

  def show_flash(conn) do
    get_flash(conn) |> flash_msg
  end

  def flash_msg(%{"info" => msg}) do
    ~E"<div class='alert alert-info'><%= msg %></div>"
  end

  def flash_msg(%{"error" => msg}) do
    ~E"<div class='alert alert-danger'><strong>Oops.</strong> <%= msg %></div>"
  end

  def flash_msg(_) do
    nil
  end
end