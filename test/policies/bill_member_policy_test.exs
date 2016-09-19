defmodule Caravan.BillMember.PolicyTest do
  use Caravan.PolicyCase, async: true

  import Caravan.BillMemberTestHelpers

  alias Caravan.Repo
  alias Caravan.User
  alias Caravan.BillMember
  alias Caravan.BillMember.Policy

  @admin_user %User{id: 1, role: "admin"}
  @normal_user %User{id: 2, role: nil}

  test "an admin can do everything to any bill member" do
    bill_member = create_bill_member

    assert Policy.can?(@admin_user, :index, BillMember)
    assert Policy.can?(@admin_user, :show, bill_member)
    assert Policy.can?(@admin_user, :new, bill_member)
    assert Policy.can?(@admin_user, :create, bill_member)
    assert Policy.can?(@admin_user, :edit, bill_member)
    assert Policy.can?(@admin_user, :update, bill_member)
    assert Policy.can?(@admin_user, :delete, bill_member)
  end

  test "a normal user can do everything to the bill members he of the bills is the creator" do
    bill_member = create_bill_member
                  |> Repo.preload([bill_item: [bill: :creator]])

    assert Policy.can?(bill_member.bill_item.bill.creator, :show, bill_member)
    assert Policy.can?(bill_member.bill_item.bill.creator, :edit, bill_member)
    assert Policy.can?(bill_member.bill_item.bill.creator, :update, bill_member)
    assert Policy.can?(bill_member.bill_item.bill.creator, :delete, bill_member)
  end

  test "a normal user can do everything to the bill members of the bills he is the payer" do
    bill_member = create_bill_member
                  |> Repo.preload([bill_item: [bill: :payer]])

    assert Policy.can?(bill_member.bill_item.bill.payer, :show, bill_member)
    assert Policy.can?(bill_member.bill_item.bill.payer, :edit, bill_member)
    assert Policy.can?(bill_member.bill_item.bill.payer, :update, bill_member)
    assert Policy.can?(bill_member.bill_item.bill.payer, :delete, bill_member)
  end

  test "a normal user can view the bill members of the bills he is a member" do
    bill_member = create_bill_member
                  |> Repo.preload(:user)

    assert Policy.can?(bill_member.user, :index, BillMember)
    assert Policy.can?(bill_member.user, :show, bill_member)
  end

  test "a normal user can create bill members on the bills he is the creator" do
    bill_member = create_bill_member
                  |> Repo.preload([bill_item: [bill: :creator]])

    assert Policy.can?(bill_member.bill_item.bill.creator, :create, bill_member)
  end

  test "a normal user can create bill members on the bills he is the payer" do
    bill_member = create_bill_member
                  |> Repo.preload([bill_item: [bill: :payer]])

    assert Policy.can?(bill_member.bill_item.bill.payer, :create, bill_member)
  end

  test "anyone can list and try to create bill members" do
    assert Policy.can?(@normal_user, :index, BillMember)
    assert Policy.can?(@normal_user, :new, %BillMember{})
  end
end

