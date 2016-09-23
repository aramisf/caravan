defmodule Caravan.BillQuery do
  use Caravan.BaseQuery

  alias Caravan.Repo
  alias Caravan.BillItem

  @doc """
  Returns the total bill amount of `struct` with the sum of all its `items`
  amount
  """
  def total_amount(struct) do
    query = from(bi in BillItem,
                 where: bi.bill_id == ^struct.id,
                 select: sum(bi.amount))
    Repo.one(query) || Money.new(0)
  end
end
