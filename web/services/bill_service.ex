defmodule Caravan.BillService do
  use Caravan.BaseService

  alias Caravan.Repo
  alias Caravan.BillItem
  alias Caravan.BillItemQuery
  alias Caravan.BillMember

  def create(changeset) do
    if changeset.valid? do
      Repo.transaction fn ->
        bill = Repo.insert!(changeset)

        item_params = %{
          description: "Main item",
          bill_id: bill.id,
          amount: bill.total_amount
        }
        bill_item = Repo.insert! BillItem.changeset(%BillItem{}, item_params)

        for member_id <- bill.member_ids do
          member_params = %{
            bill_item_id: bill_item.id,
            user_id: member_id,
            paid: false
          }
          Repo.insert! BillMember.changeset(%BillMember{}, member_params)
        end

        payer_member = Repo.get_by BillMember,
          bill_item_id: bill_item.id,
          user_id: bill.payer_id
        if payer_member do
          Repo.update! BillMember.changeset(payer_member, %{paid: true})
        end

        bill
      end
    else
      {:error, changeset}
    end
  end

  def update(changeset) do
    if changeset.valid? do
      Repo.transaction fn ->
        bill = Repo.update!(changeset)

        bill_items_query = BillItemQuery.by_bill(bill.id)
        count_query = bill_items_query |> select([bi], count(bi.id))
        if Repo.one(count_query) == 1 do
          if amount = changeset.changes[:total_amount] do
            bill_item = Repo.one(bill_items_query)
            Repo.update!(BillItem.changeset(bill_item, %{amount: amount}))
          end
        end
      end
    else
      {:error, changeset}
    end
  end
end
