defmodule Caravan.BillMemberQuery do
  use Caravan.BaseQuery

  alias Caravan.BillItem
  alias Caravan.BillMember

  def by_bill_item(bill_item_id) do
    from(bm in BillMember, where: bm.bill_item_id == ^bill_item_id)
  end

  def by_bill(bill_id) do
    from(bm in BillMember,
         join: bi in BillItem, on: bi.id == bm.bill_item_id,
         where: bi.bill_id == ^bill_id)
  end
end



