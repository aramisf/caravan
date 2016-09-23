defmodule Caravan.User.PolicyTest do
  use ExUnit.Case

  alias Caravan.User
  alias Caravan.User.Policy

  @admin_user %User{id: 1, role: "admin"}
  @normal_user %User{id: 2, role: nil}

  test "an admin can do everything to everyone" do
    assert Policy.can?(@admin_user, :index, User)
    assert Policy.can?(@admin_user, :show, %User{})
    assert Policy.can?(@admin_user, :edit, %User{})
    assert Policy.can?(@admin_user, :update, %User{})
    assert Policy.can?(@admin_user, :delete, %User{})
  end

  test "a normal user cannot view all users" do
    refute Policy.can?(@normal_user, :index, User)
  end

  test "a normal user can do everything to himself" do
    assert Policy.can?(@normal_user, :show, %User{id: 2})
    assert Policy.can?(@normal_user, :edit, %User{id: 2})
    assert Policy.can?(@normal_user, :update, %User{id: 2})
    assert Policy.can?(@normal_user, :delete, %User{id: 2})
  end

  test "a normal user cannot do everything to other users" do
    refute Policy.can?(@normal_user, :show, %User{id: 1})
    refute Policy.can?(@normal_user, :edit, %User{id: 1})
    refute Policy.can?(@normal_user, :update, %User{id: 1})
    refute Policy.can?(@normal_user, :delete, %User{id: 1})
  end

  test "anyone can create users" do
    assert Policy.can?(%User{}, :new, %User{})
    assert Policy.can?(%User{}, :create, %User{})
  end
end
