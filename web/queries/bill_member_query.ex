defmodule Caravan.BillMemberQuery do
  use Caravan.BaseQuery

  alias Caravan.BillItem
  alias Caravan.BillMember

  @doc """
  Returns the total bill amount of `struct` with the sum of all its `items`
  amount
  """
  def by_bill(bill_id) do
    from(bm in BillMember,
         join: bi in BillItem, on: bi.id == bm.bill_item_id,
         where: bi.bill_id == ^bill_id)
  end
end



