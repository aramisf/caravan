defmodule Caravan.BillMemberService do
  use Caravan.BaseService

  alias Caravan.Repo
  alias Caravan.BillItem
  alias Caravan.BillMember

  def delete(bill_member) do
    bill_item = Repo.get!(BillItem, bill_member.bill_item_id)
    query = from(bm in BillMember,
                 join: bi in assoc(bm, :bill_item),
                 where: bi.bill_id == ^bill_item.bill_id,
                 select: count(bm.id, :distinct))
    case Repo.one(query) do
      i when i > 1 ->
        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        Repo.delete!(bill_member)
        :ok
      _ ->
        {:error, "You cannot delete this bill member because it is the last member on the bill"}
    end
  end
end

