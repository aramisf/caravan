defmodule Caravan.BillItemTest do
  use Caravan.ModelCase

  alias Caravan.BillItem

  @valid_attrs %{bill_id: 1, amount: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = BillItem.changeset(%BillItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BillItem.changeset(%BillItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
