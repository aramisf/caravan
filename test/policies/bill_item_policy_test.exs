defmodule Caravan.BillItem.PolicyTest do
  use Caravan.PolicyCase, async: true

  import Caravan.BillItemTestHelpers
  import Caravan.BillMemberTestHelpers

  alias Caravan.Repo
  alias Caravan.User
  alias Caravan.BillItem
  alias Caravan.BillItem.Policy

  @admin_user %User{id: 1, role: "admin"}
  @normal_user %User{id: 2, role: nil}

  test "an admin can do everything to any bill item" do
    bill_item = create_bill_item

    assert Policy.can?(@admin_user, :index, BillItem)
    assert Policy.can?(@admin_user, :show, bill_item)
    assert Policy.can?(@admin_user, :new, bill_item)
    assert Policy.can?(@admin_user, :create, bill_item)
    assert Policy.can?(@admin_user, :edit, bill_item)
    assert Policy.can?(@admin_user, :update, bill_item)
    assert Policy.can?(@admin_user, :delete, bill_item)
  end

  test "a normal user can do everything to the bill items of the bills he is the creator" do
    bill_item = create_bill_item
                |> Repo.preload([bill: :creator])

    assert Policy.can?(bill_item.bill.creator, :show, bill_item)
    assert Policy.can?(bill_item.bill.creator, :edit, bill_item)
    assert Policy.can?(bill_item.bill.creator, :update, bill_item)
    assert Policy.can?(bill_item.bill.creator, :delete, bill_item)
  end

  test "a normal user can do everything to the bill items of the bills he is the payer" do
    bill_item = create_bill_item
                  |> Repo.preload([bill: :payer])

    assert Policy.can?(bill_item.bill.payer, :show, bill_item)
    assert Policy.can?(bill_item.bill.payer, :edit, bill_item)
    assert Policy.can?(bill_item.bill.payer, :update, bill_item)
    assert Policy.can?(bill_item.bill.payer, :delete, bill_item)
  end

  test "a normal user can view the bill items of the bills he is a member" do
    bill_member = create_bill_member
                  |> Repo.preload([:bill_item, :user])

    assert Policy.can?(bill_member.user, :index, BillItem)
    assert Policy.can?(bill_member.user, :show, bill_member.bill_item)
  end

  test "a normal user can create bill items on the bills he is the creator" do
    bill_item = create_bill_item
                |> Repo.preload([bill: :creator])

    assert Policy.can?(bill_item.bill.creator, :create, bill_item)
  end

  test "a normal user can create bill items on the bills he is the payer" do
    bill_item = create_bill_item
                |> Repo.preload([bill: :payer])

    assert Policy.can?(bill_item.bill.payer, :create, bill_item)
  end

  test "anyone can list and try to create bill items" do
    assert Policy.can?(@normal_user, :index, BillItem)
    assert Policy.can?(@normal_user, :new, %BillItem{})
  end
end
