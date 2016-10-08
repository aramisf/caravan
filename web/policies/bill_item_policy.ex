defmodule Caravan.BillItem.Policy do
  use Caravan.BasePolicy

  alias Caravan.Repo
  alias Caravan.Bill
  alias Caravan.BillItem
  alias Caravan.BillMember
  alias Caravan.User

  def scope(%User{role: "admin"}, :index, _opts), do: from(BillItem)
  def scope(%User{id: user_id}, :index, _opts),
    do: from(bi in BillItem,
             join: b in Bill, on: bi.bill_id == b.id,
             join: bm in BillMember, on: bm.bill_item_id == bi.id,
             where: ^user_id in [bm.user_id, b.creator_id, b.payer_id])

  def scope(_, action, _) when action != :index, do: from(BillItem)

  def can?(%User{role: "admin"}, _action, _bill), do: true
  def can?(_user, action, _bill_item) when action in [:index, :new], do: true

  def can?(%User{id: user_id}, :create, %BillItem{bill_id: bill_id}) do
    query = from(b in Bill,
                 where: b.id == ^bill_id and ^user_id in [b.creator_id, b.payer_id])
            |> first
    user_id && bill_id && Repo.one(query)
  end

  def can?(user, action, bill_item) do
    bill = Repo.get_by(Bill, id: bill_item.bill_id)
    bill && Caravan.Bill.Policy.can?(user, action, bill)
  end
end

