defmodule Caravan.BillItemTestHelpers do
  import Caravan.BillTestHelpers

  alias Caravan.Repo
  alias Caravan.BillItem

  @endpoint Caravan.Endpoint

  def valid_bill_item_attrs do
    bill = create_bill

    %{bill_id: bill.id, amount: 62, description: "Real valid item"}
  end

  def create_bill_item(attrs \\ valid_bill_item_attrs) do
    Repo.insert!(BillItem.changeset(%BillItem{}, attrs))
  end
end

