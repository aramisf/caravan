defmodule Caravan.BillView do
  use Caravan.Web, :view

  require Ecto.Query

  alias Ecto.Query

  alias Caravan.Repo
  alias Caravan.BillQuery
  alias Caravan.UserQuery

  alias Caravan.BillItemView

  def member_names(bill) do
    UserQuery.by_bill(bill.id)
    |> Query.select([:name])
    |> Repo.all
    |> Enum.map_join(", ", &(&1.name))
  end

  def total_amount(bill) do
    Money.to_string BillQuery.total_amount(bill)
  end
end
