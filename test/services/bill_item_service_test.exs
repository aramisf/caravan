defmodule Caravan.BillItemServiceTest do
  use Caravan.ServiceCase

  import Caravan.BillItemTestHelpers

  alias Caravan.Repo
  alias Caravan.BillItem
  alias Caravan.BillItemService

  @invalid_attrs %{}

  test "allow to delete items when it is not the only item on the bill" do
    bill_item_one = create_bill_item

    attrs_for_two = %{bill_id: bill_item_one.bill_id, amount: 0}
    bill_item_two = create_bill_item(attrs_for_two)
    old_id = bill_item_two.id

    assert BillItemService.delete(bill_item_two) == :ok
    refute Repo.get(BillItem, old_id)
  end

  test "don't allow to delete items when it is the only item on the bill" do
    bill_item = create_bill_item
    assert {:error, message} = BillItemService.delete(bill_item)
    assert message == "You cannot delete this bill item because it is the last item on the bill"
    assert Repo.get(BillItem, bill_item.id)
  end
end

