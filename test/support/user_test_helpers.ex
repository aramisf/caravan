defmodule Caravan.UserTestHelpers do
  alias Caravan.Repo
  alias Caravan.User

  @endpoint Caravan.Endpoint

  def valid_user_attrs do
    %{email: "dummy@4test.com", name: "dummy", password: "dummy"}
  end

  def valid_admin_user_attrs do
    %{email: "admin@4test.com", name: "admin", password: "admin", role: "admin"}
  end

  def create_user(attrs \\ valid_user_attrs) do
    Repo.insert!(User.creation_changeset(%User{}, attrs))
  end
end
