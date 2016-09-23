defmodule Caravan.BillMemberTest do
  use Caravan.ModelCase

  alias Caravan.BillMember

  @valid_attrs %{user_id: 1, bill_item_id: 1, paid: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = BillMember.changeset(%BillMember{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BillMember.changeset(%BillMember{}, @invalid_attrs)
    refute changeset.valid?
  end
end
