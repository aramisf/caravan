defmodule Caravan.BillItemQuery do
  use Caravan.BaseQuery

  alias Caravan.BillItem

  @doc """
  Returns the total bill amount of `struct` with the sum of all its `items`
  amount
  """
  def by_bill(bill_id) do
    from(bi in BillItem, where: bi.bill_id == ^bill_id)
  end
end


