defmodule Caravan.BillView do
  use Caravan.Web, :view

  alias Caravan.BillQuery

  def total_amount(bill) do
    Money.to_string BillQuery.total_amount(bill)
  end
end
