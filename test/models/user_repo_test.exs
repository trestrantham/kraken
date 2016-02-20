defmodule Kraken.UserRepoTest do
  use Kraken.ModelCase
  alias Kraken.User

  @valid_attrs %{name: Faker.Name.name, email: Faker.Internet.email}

  test "converts unique_constraint on username to error" do
    insert_user(email: "sven@arendelle.com")
    attrs = Map.put(@valid_attrs, :email, "sven@arendelle.com")
    changeset = User.changeset(%User{}, attrs)

    assert {:error, changeset} = Repo.insert(changeset) 
    assert {:email, "has already been taken"} in changeset.errors
  end
end
