defmodule Kraken.Auth do
  alias Kraken.User
  alias Kraken.Repo
  import Ecto.Query, only: [from: 1, from: 2]

  def validate_email_and_password(email, password) do
    password_match = if user = Repo.one(from u in User, where: u.email == ^email) do
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
