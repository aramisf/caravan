defmodule Caravan.BillMember.Policy do
  use Caravan.BasePolicy

  alias Caravan.Repo
  alias Caravan.Bill
  alias Caravan.BillItem
  alias Caravan.BillMember
  alias Caravan.User

  def scope(%User{role: "admin"}, :index, _opts), do: from(BillMember)
  def scope(%User{id: user_id}, :index, _opts),
    do: from(bm in BillMember,
             join: bi in BillItem, on: bm.bill_item_id == bi.id,
             join: b in Bill, on: bi.bill_id == b.id,
             where: ^user_id in [bm.user_id, b.creator_id, b.payer_id])

  def scope(_, action, _) when action != :index, do: from(BillMember)

  def can?(%User{role: "admin"}, _action, _bill), do: true
  def can?(_user, action, _bill_item) when action in [:index, :new], do: true

  def can?(user, action, bill_member) do
    bill_member = Repo.preload(bill_member, :bill_item)
    Caravan.BillItem.Policy.can?(user, action, bill_member.bill_item)
  end
end

