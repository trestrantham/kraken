defmodule Sync.UserView do
  use Sync.Web, :view

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
end
