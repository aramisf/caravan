defmodule Caravan.BillViewTest do
  use Caravan.ConnCase, async: true

  import Caravan.BillTestHelpers
  import Caravan.BillItemTestHelpers

  alias Caravan.BillView

  test "total_amount must return a string with the bill total amount" do
    bill = create_bill
    create_bill_item(%{bill_id: bill.id, amount: 10})
    create_bill_item(%{bill_id: bill.id, amount: 10})

    assert BillView.total_amount(bill) == "0.20"
  end
end

