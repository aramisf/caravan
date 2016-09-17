defmodule Caravan.BillItemTestHelpers do
  import Caravan.UserTestHelpers

  alias Caravan.Repo
  alias Caravan.Bill
  alias Caravan.BillItem

  @endpoint Caravan.Endpoint

  def valid_bill_item_attrs do
    user = create_user

    bill = Repo.insert!(Bill.changeset(%Bill{}, %{
                          creator_id: user.id,
                          payer_id: user.id
                        }))

    %{bill_id: bill.id, amount: 62, description: "Real valid item"}
  end

  def create_bill_item(attrs \\ valid_bill_item_attrs) do
    Repo.insert!(BillItem.changeset(%BillItem{}, attrs))
  end
end

