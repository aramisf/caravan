defmodule Caravan.Bill.Policy do
  use Caravan.BasePolicy

  alias Caravan.Repo
  alias Caravan.Bill
  alias Caravan.BillItem
  alias Caravan.BillMember
  alias Caravan.User

  def scope(%User{role: "admin"}, :index, _opts), do: from(Bill)
  def scope(%User{id: user_id}, :index, _opts) do
    from(b in Bill,
         join: bi in BillItem, on: bi.bill_id == b.id,
         join: bm in BillMember, on: bm.bill_item_id == bi.id,
         where: ^user_id in [bm.user_id, b.creator_id, b.payer_id])
    |> distinct(true)
  end


  def scope(_, action, _) when action != :index, do: from(Bill)

  def can?(%User{role: "admin"}, _action, _bill), do: true

  def can?(%User{id: user_id}, _action,
    %Bill{creator_id: creator_id, payer_id: payer_id})
    when user_id in [creator_id, payer_id], do: true

  def can?(%User{id: user_id}, :show, %Bill{id: bill_id}) do
    query = from(bm in BillMember,
                 join: bi in assoc(bm, :bill_item),
                 where: bi.bill_id == ^bill_id and bm.user_id == ^user_id,
                 select: count(bm.id))
    Repo.one(query) > 0
  end

  def can?(%User{id: user_id}, :create, %Bill{creator_id: creator_id})
    when user_id == creator_id, do: true

  def can?(%User{}, action, _) when action in [:index, :new], do: true
  def can?(_, _, _), do: false
end

