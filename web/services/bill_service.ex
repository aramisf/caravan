defmodule Caravan.BillService do
  use Caravan.BaseService

  alias Caravan.Repo
  alias Caravan.BillItem
  alias Caravan.BillMember

  def create(bill_changeset) do
    if bill_changeset.valid? do
      Repo.transaction fn ->
        bill = Repo.insert!(bill_changeset)

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
      {:error, bill_changeset}
    end
  end
end
