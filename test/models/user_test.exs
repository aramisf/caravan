defmodule Caravan.UserTest do
  use Caravan.ModelCase

  alias Caravan.User

  @valid_attrs %{email: "joao@mail.com", name: "João", password: "password"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "email must contain at least an @" do
    attrs = %{@valid_attrs | email: "joao.com"}
    assert {:email, "has invalid format"} in errors_on(%User{}, attrs)
  end

  test "creation_changeset with encrypts password" do
    changeset = User.creation_changeset(%User{}, @valid_attrs)

    {:ok, user} = Repo.insert(changeset)

    created_user = Repo.get!(User, user.id)
    assert created_user.password == nil
    assert created_user.encrypted_password != nil
    assert Comeonin.Bcrypt.checkpw(@valid_attrs.password,
                                   created_user.encrypted_password)
  end
end
