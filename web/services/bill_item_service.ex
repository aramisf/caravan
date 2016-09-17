defmodule Caravan.BillItemService do
  use Caravan.BaseService

  alias Caravan.Repo
  alias Caravan.BillItem

  def delete(bill_item) do
    query = from(bi in BillItem,
                 where: bi.bill_id == ^bill_item.bill_id,
                 select: count(bi.id, :distinct))
    case Repo.one(query) do
      i when i > 1 ->
        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        Repo.delete!(bill_item)
        :ok
      _ ->
        {:error, "You cannot delete this bill item because it is the last item on the bill"}
    end
  end
end
