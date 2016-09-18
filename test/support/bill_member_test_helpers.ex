defmodule Caravan.BillMemberTestHelpers do
  import Caravan.BillItemTestHelpers
  import Caravan.UserTestHelpers

  alias Caravan.Repo
  alias Caravan.BillMember

  @endpoint Caravan.Endpoint

  def valid_bill_member_attrs do
    bill_item = create_bill_item
    user = create_user

    %{bill_item_id: bill_item.id, user_id: user.id, paid: true}
  end

  def create_bill_member(attrs \\ valid_bill_member_attrs) do
    Repo.insert!(BillMember.changeset(%BillMember{}, attrs))
  end
end


