defmodule Caravan.UserTestHelpers do
  alias Caravan.Repo
  alias Caravan.User

  @endpoint Caravan.Endpoint

  def create_user do
    attrs = %{email: "io@mail.com", name: "io", password: "io"}
    Repo.insert!(User.creation_changeset(%User{}, attrs))
  end
end
