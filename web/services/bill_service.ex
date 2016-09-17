defmodule Caravan.BillService do
  use Caravan.BaseService

  alias Caravan.Repo
  alias Caravan.Bill
  alias Caravan.BillItem

  def create(params \\ %{}) do
    bill_changeset = Bill.changeset %Bill{}, params

    if bill_changeset.valid? do
      Repo.transaction fn ->
        bill = Repo.insert!(bill_changeset)
        item_params = %{bill_id: bill.id, description: "Main item", amount: 0}

        Repo.insert! BillItem.changeset(%BillItem{}, item_params)

        bill
      end
    else
      {:error, bill_changeset}
    end
  end
end
