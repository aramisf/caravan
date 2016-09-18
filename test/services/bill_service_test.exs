defmodule Caravan.BillServiceTest do
  use Caravan.ServiceCase

  import Caravan.UserTestHelpers

  alias Caravan.Repo
  alias Caravan.BillItem
  alias Caravan.BillMember
  alias Caravan.BillService

  @invalid_attrs %{}

  def valid_attrs do
    user = create_user
    %{creator_id: user.id, payer_id: user.id}
  end

  test "with valid attributes creates an item for the new bill" do
    {:ok, bill} = BillService.create(valid_attrs)
    assert Repo.get_by(BillItem, bill_id: bill.id)
  end

  test "with valid attributes assigns the payer as member in the new bill" do
    {:ok, bill} = BillService.create(valid_attrs)
    bill_item = Repo.get_by(BillItem, bill_id: bill.id)
    assert Repo.get_by(BillMember,
                       bill_item_id: bill_item.id,
                       user_id: bill.payer_id,
                       paid: true)
  end

  test "with invalid attributes return an invalid changeset" do
    {:error, changeset} = BillService.create(@invalid_attrs)
    refute changeset.valid?
  end
end
