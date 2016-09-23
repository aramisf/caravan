defmodule Caravan.BillTest do
  use Caravan.ModelCase

  alias Caravan.Bill

  @valid_attrs %{creator_id: 1, payer_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Bill.changeset(%Bill{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Bill.changeset(%Bill{}, @invalid_attrs)
    refute changeset.valid?
  end
end
