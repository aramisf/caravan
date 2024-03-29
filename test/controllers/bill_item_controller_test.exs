defmodule Caravan.BillItemControllerTest do
  use Caravan.ConnCase

  import Caravan.BillItemTestHelpers

  alias Caravan.Repo
  alias Caravan.BillItem

  @invalid_attrs %{bill_id: 1}

  setup %{conn: conn} do
    current_user = create_user(valid_admin_user_attrs)
    conn = sign_in(conn, current_user)
    {:ok, conn: conn, current_user: current_user}
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get(conn, bill_item_path(conn, :new, bill_id: 1))
    assert html_response(conn, 200) =~ "New bill item"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    create_valid_attrs = valid_bill_item_attrs
    conn = post(conn, bill_item_path(conn, :create),
                bill_item: create_valid_attrs)
    bill_id = create_valid_attrs.bill_id
    assert redirected_to(conn) == bill_path(conn, :edit, bill_id)
    assert Repo.get_by(BillItem, create_valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, bill_item_path(conn, :create), bill_item: @invalid_attrs)
    assert html_response(conn, 200) =~ "New bill item"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bill_item = create_bill_item
    conn = get(conn, bill_item_path(conn, :edit, bill_item))
    assert html_response(conn, 200) =~ "Edit bill item"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    update_valid_attrs = valid_bill_item_attrs
    bill_item = create_bill_item
    conn = put(conn, bill_item_path(conn, :update, bill_item),
               bill_item: update_valid_attrs)
    assert redirected_to(conn) == bill_item_path(conn, :edit, bill_item)
    assert Repo.get_by(BillItem, update_valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bill_item = create_bill_item
    conn = put(conn, bill_item_path(conn, :update, bill_item),
               bill_item: %{bill_id: bill_item.bill_id, amount: nil})
    assert html_response(conn, 200) =~ "Edit bill item"
  end

  test "deletes chosen resource", %{conn: conn} do
    bill_item_one = create_bill_item

    attrs_for_two = %{bill_id: bill_item_one.bill_id, amount: 0}
    bill_item_two = create_bill_item(attrs_for_two)
    old_id = bill_item_two.id

    bill_id = bill_item_two.bill_id
    conn = delete(conn, bill_item_path(conn, :delete, bill_item_two))
    assert redirected_to(conn) == bill_path(conn, :edit, bill_id)
    refute Repo.get(BillItem, old_id)
  end

  test "does not delete the only resource", %{conn: conn} do
    bill_item = create_bill_item
    bill_id = bill_item.bill_id
    conn = delete(conn, bill_item_path(conn, :delete, bill_item))
    assert redirected_to(conn) == bill_path(conn, :edit, bill_id)
    assert Repo.get(BillItem, bill_item.id)
  end
end
