defmodule Caravan.BillMemberServiceTest do
  use Caravan.ServiceCase

  import Caravan.UserTestHelpers
  import Caravan.BillMemberTestHelpers

  alias Caravan.Repo
  alias Caravan.BillMember
  alias Caravan.BillMemberService

  @invalid_attrs %{}

  test "allow to delete members when it is not the only member on the bill" do
    bill_member_one = create_bill_member

    bill_member_two = create_bill_member(%{
      bill_item_id: bill_member_one.bill_item_id,
      user_id: create_user.id,
      paid: false
    })
    old_id = bill_member_two.id

    assert BillMemberService.delete(bill_member_two) == :ok
    refute Repo.get(BillMember, old_id)
  end

  test "don't allow to delete member when it is the only member on the bill" do
    bill_member = create_bill_member
    assert {:error, message} = BillMemberService.delete(bill_member)
    assert message == "You cannot delete this bill member because it is the last member on the bill"
    assert Repo.get(BillMember, bill_member.id)
  end
end


