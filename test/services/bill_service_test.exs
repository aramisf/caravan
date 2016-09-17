defmodule Caravan.BillServiceTest do
  use Caravan.ServiceCase

  alias Caravan.Repo
  alias Caravan.BillItem
  alias Caravan.BillService

  @invalid_attrs %{}

  def valid_attrs do
    user = create_user
    %{creator_id: user.id, payer_id: user.id}
  end

  test "with valid attributes creates an item for the new bill" do
    {:ok, bill} = BillService.create(valid_attrs)
    assert Repo.get_by(BillItem, bill_id: bill.id)
  end

  test "with invalid attributes return an invalid changeset" do
    {:error, changeset} = BillService.create(@invalid_attrs)
    refute changeset.valid?
  end
end
