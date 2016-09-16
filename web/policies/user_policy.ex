defmodule Caravan.User.Policy do
  alias Caravan.User

  def can?(%User{role: "admin"}, _action, _user), do: true
  def can?(%User{}, :index, User), do: false

  def can?(%User{id: user_id}, _action, %User{id: changed_user_id})
    when changed_user_id == user_id, do: true

  def can?(_, action, _) when action in [:new, :create], do: true
  def can?(_, _, _), do: false
end
