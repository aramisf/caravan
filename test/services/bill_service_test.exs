defmodule Caravan.BillServiceTest do
  use Caravan.ServiceCase

  import Caravan.UserTestHelpers

  alias Caravan.Repo
  alias Caravan.Bill
  alias Caravan.BillItem
  alias Caravan.BillMember
  alias Caravan.BillService

  def valid_changeset do
    user = create_user
    Bill.changeset(%Bill{}, %{
                   creator_id: user.id,
                   payer_id: user.id,
                   member_ids: [user.id],
                   total_amount: 10
                 })
  end

  def invalid_changeset do
    Bill.changeset(%Bill{}, %{})
  end

  test "with valid attributes creates an item for the new bill" do
    {:ok, bill} = BillService.create(valid_changeset)
    assert Repo.get_by(BillItem, bill_id: bill.id)
  end

  test "with valid attributes assigns the payer as member in the new bill" do
    {:ok, bill} = BillService.create(valid_changeset)
    bill_item = Repo.get_by(BillItem, bill_id: bill.id)
    assert Repo.get_by(BillMember,
                       bill_item_id: bill_item.id,
                       user_id: bill.payer_id,
                       paid: true)
  end

  test "with invalid attributes return an invalid changeset" do
    {:error, changeset} = BillService.create(invalid_changeset)
    refute changeset.valid?
  end
end
