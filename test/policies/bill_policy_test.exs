defmodule Caravan.Bill.PolicyTest do
  use Caravan.PolicyCase, async: true

  import Caravan.BillMemberTestHelpers

  alias Caravan.Repo
  alias Caravan.User
  alias Caravan.Bill
  alias Caravan.Bill.Policy

  @admin_user %User{id: 1, role: "admin"}
  @normal_user %User{id: 2, role: nil}

  test "an admin can do everything to any bill" do
    assert Policy.can?(@admin_user, :index, Bill)
    assert Policy.can?(@admin_user, :show, %Bill{})
    assert Policy.can?(@admin_user, :new, %Bill{})
    assert Policy.can?(@admin_user, :create, %Bill{})
    assert Policy.can?(@admin_user, :edit, %Bill{})
    assert Policy.can?(@admin_user, :update, %Bill{})
    assert Policy.can?(@admin_user, :delete, %Bill{})
  end

  test "a normal user can do everything to the bills he is the creator" do
    assert Policy.can?(@normal_user, :show, %Bill{creator_id: 2})
    assert Policy.can?(@normal_user, :edit, %Bill{creator_id: 2})
    assert Policy.can?(@normal_user, :update, %Bill{creator_id: 2})
    assert Policy.can?(@normal_user, :delete, %Bill{creator_id: 2})
  end

  test "a normal user can do everything to the bills he is the payer" do
    assert Policy.can?(@normal_user, :show, %Bill{payer_id: 2})
    assert Policy.can?(@normal_user, :edit, %Bill{payer_id: 2})
    assert Policy.can?(@normal_user, :update, %Bill{payer_id: 2})
    assert Policy.can?(@normal_user, :delete, %Bill{payer_id: 2})
  end

  test "a normal user can view the bills he is a member" do
    bill_member = create_bill_member
                  |> Repo.preload([{:bill_item, :bill}, :user])

    assert Policy.can?(bill_member.user, :index, Bill)
    assert Policy.can?(bill_member.user, :show, bill_member.bill_item.bill)
  end

  test "a normal user can create bills for himself" do
    assert Policy.can?(@normal_user, :create, %Bill{creator_id: 2})
  end

  test "anyone can create users" do
    assert Policy.can?(@normal_user, :index, Bill)
    assert Policy.can?(@normal_user, :new, %Bill{})
  end
end
