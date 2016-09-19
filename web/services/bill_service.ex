defmodule Caravan.BillService do
  use Caravan.BaseService

  alias Caravan.Repo
  alias Caravan.BillItem
  alias Caravan.BillMember

  def create(bill_changeset) do
    if bill_changeset.valid? do
      Repo.transaction fn ->
        bill = Repo.insert!(bill_changeset)

        item_params = %{bill_id: bill.id, description: "Main item", amount: 0}
        bill_item = Repo.insert! BillItem.changeset(%BillItem{}, item_params)

        member_params = %{
          bill_item_id: bill_item.id,
          user_id: bill.payer_id,
          paid: true
        }
        Repo.insert! BillMember.changeset(%BillMember{}, member_params)

        bill
      end
    else
      {:error, bill_changeset}
    end
  end
end
