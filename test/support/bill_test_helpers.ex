defmodule Caravan.BillTestHelpers do
  import Caravan.UserTestHelpers

  alias Caravan.Repo
  alias Caravan.Bill

  @endpoint Caravan.Endpoint

  def valid_bill_attrs do
    user = create_user

    %{creator_id: user.id, payer_id: user.id}
  end

  def create_bill(attrs \\ valid_bill_attrs) do
    Repo.insert!(Bill.changeset(%Bill{}, attrs))
  end
end


