defmodule Caravan.BillItemService do
  use Caravan.BaseService

  alias Caravan.Repo
  alias Caravan.BillItem
  alias Caravan.BillMember

  def create(changeset) do
    if changeset.valid? do
      Repo.transaction fn ->
        bill_item = Repo.insert!(changeset)

        if bill_item.member_ids do
          for member_id <- bill_item.member_ids do
            member_params = %{
              bill_item_id: bill_item.id,
              user_id: member_id,
              paid: false
            }
            Repo.insert! BillMember.changeset(%BillMember{}, member_params)
          end
        end

        bill_item
      end
    else
      {:error, changeset}
    end
  end

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
