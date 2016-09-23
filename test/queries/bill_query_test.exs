defmodule Caravan.BillQueryTest do
  use Caravan.QueryCase

  import Caravan.BillTestHelpers
  import Caravan.BillItemTestHelpers

  alias Caravan.BillQuery

  test "total_amount returns the sum of amounts" do
    bill = create_bill
    create_bill_item(%{bill_id: bill.id, amount: 10})
    create_bill_item(%{bill_id: bill.id, amount: 10})

    assert BillQuery.total_amount(bill) == Money.new(20)
  end
end
