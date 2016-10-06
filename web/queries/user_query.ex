defmodule Caravan.UserQuery do
  use Caravan.BaseQuery

  alias Caravan.BillItem
  alias Caravan.BillMember
  alias Caravan.User

  @doc """
  Returns the total bill amount of `struct` with the sum of all its `items`
  amount
  """
  def by_bill(bill_id) do
    from(u in User,
         join: bm in BillMember, on: u.id == bm.user_id,
         join: bi in BillItem, on: bi.id == bm.bill_item_id,
         where: bi.bill_id == ^bill_id)
  end
end

