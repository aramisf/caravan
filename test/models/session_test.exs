defmodule Caravan.SessionTest do
  use Caravan.ModelCase

  alias Caravan.Repo
  alias Caravan.User
  alias Caravan.Session

  @valid_attrs %{email: "joao@mail.com", password: "password"}
  @invalid_attrs %{}
  @user_attrs %{email: "joao@mail.com", password: "password", name: "João"}

  test "changeset with valid attributes" do
    changeset = Session.changeset(%Session{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Session.changeset(%Session{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "email must contain at least an @" do
    attrs = %{@valid_attrs | email: "joao.com"}
    assert {:email, "has invalid format"} in errors_on(%Session{}, attrs)
  end

  test "find_user_and_validate_password validates user existence" do
    result = Session.find_user_and_validate_password(@valid_attrs)
    assert {:error, changeset} = result
    assert changeset.errors == [email: {"is not registered", []}]
  end

  test "changeset validates password" do
    Repo.insert(User.creation_changeset(%User{}, @user_attrs))

    attrs = %{@valid_attrs | password: "lolo"}
    result = Session.find_user_and_validate_password(attrs)
    assert {:error, changeset} = result
    assert changeset.errors == [password: {"is invalid", []}]
  end
end
