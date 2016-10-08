defmodule Caravan.BillControllerTest do
  use Caravan.ConnCase

  import Caravan.BillTestHelpers
  import Caravan.BillItemTestHelpers

  alias Caravan.Repo
  alias Caravan.Bill
  alias Caravan.BillItem
  alias Caravan.BillMember

  @invalid_attrs %{}

  setup %{conn: conn} do
    current_user = create_user(valid_admin_user_attrs)
    conn = sign_in(conn, current_user)
    {:ok, conn: conn, current_user: current_user}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, bill_path(conn, :index))
    assert html_response(conn, 200) =~ "Listing bills"
  end

  test "renders form for new resources", %{conn: conn} do
    conn =  get(conn, bill_path(conn, :new))
    assert html_response(conn, 200) =~ "New bill"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    valid_attrs = Map.delete(valid_bill_attrs, :creator_id)

    conn = post(conn, bill_path(conn, :create), bill: valid_attrs)
    assert redirected_to(conn) == bill_path(conn, :index)
    attrs_to_query = Map.drop(valid_attrs, [:member_ids, :total_amount])
    assert Repo.get_by(Bill, attrs_to_query)
  end

  test "creates resource and set the creator to the current user", %{conn: conn, current_user: current_user} do
    valid_attrs = Map.delete(valid_bill_attrs, :creator_id)

    conn = post(conn, bill_path(conn, :create), bill: valid_attrs)
    assert redirected_to(conn) == bill_path(conn, :index)
    attrs_to_query = Map.drop(valid_attrs, [:member_ids, :total_amount])
    bill = Repo.get_by(Bill, attrs_to_query)
    assert bill
    assert bill.creator_id == current_user.id
  end

  test "creates resource and a bill item with it", %{conn: conn} do
    valid_attrs = Map.delete(valid_bill_attrs, :creator_id)

    post(conn, bill_path(conn, :create), bill: valid_attrs)
    attrs_to_query = Map.drop(valid_attrs, [:member_ids, :total_amount])
    bill = Repo.get_by(Bill, attrs_to_query)
    assert Repo.get_by(BillItem, %{bill_id: bill.id})
  end

  test "creates resource and a bill member for the payer", %{conn: conn} do
    valid_attrs = Map.delete(valid_bill_attrs, :creator_id)

    post(conn, bill_path(conn, :create), bill: valid_attrs)
    attrs_to_query = Map.drop(valid_attrs, [:member_ids, :total_amount])
    bill = Repo.get_by(Bill, attrs_to_query)
    bill_item = Repo.get_by(BillItem, %{bill_id: bill.id})
    assert Repo.get_by(BillMember,
                       bill_item_id: bill_item.id,
                       user_id: bill.payer_id,
                       paid: true)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, bill_path(conn, :create), bill: @invalid_attrs)
    assert html_response(conn, 200) =~ "New bill"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bill = create_bill
    create_bill_item(%{valid_bill_item_attrs | bill_id: bill.id})
    conn = get(conn, bill_path(conn, :edit, bill))
    assert html_response(conn, 200) =~ "Edit bill"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    valid_attrs = Map.delete(valid_bill_attrs, :creator_id)

    bill = Repo.insert! %Bill{}
    conn = put(conn, bill_path(conn, :update, bill), bill: valid_attrs)
    assert redirected_to(conn) == bill_path(conn, :index)
    attrs_to_query = Map.drop(valid_attrs, [:member_ids, :total_amount])
    assert Repo.get_by(Bill, attrs_to_query)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bill = create_bill
    create_bill_item(%{valid_bill_item_attrs | bill_id: bill.id})
    conn = put(conn, bill_path(conn, :update, bill), bill: %{payer_id: nil})
    assert html_response(conn, 200) =~ "Edit bill"
  end

  test "deletes chosen resource", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    conn = delete(conn, bill_path(conn, :delete, bill))
    assert redirected_to(conn) == bill_path(conn, :index)
    refute Repo.get(Bill, bill.id)
  end
end
