defmodule Kraken.Auth do
  import Ecto.Query

  alias Kraken.{Repo,User}

  def validate_email_and_password(email, password) do
    user =
      User
      |> where(email: ^email)
      |> Repo.one

    password_match =
      if user do
        Comeonin.Bcrypt.checkpw(password, user.password_hash)
      else
        Comeonin.Bcrypt.dummy_checkpw
      end

    if password_match do
      {:ok, user}
    else
      {:error, "email and password do not match"}
    end
  end
end
