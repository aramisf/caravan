defmodule Caravan.BillControllerTest do
  use Caravan.ConnCase

  import Caravan.BillTestHelpers

  alias Caravan.Repo
  alias Caravan.Bill
  alias Caravan.BillItem
  alias Caravan.BillMember

  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = conn |> sign_in |> get(bill_path(conn, :index))
    assert html_response(conn, 200) =~ "Listing bills"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn |> sign_in |> get(bill_path(conn, :new))
    assert html_response(conn, 200) =~ "New bill"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    valid_attrs = Map.delete(valid_bill_attrs, :creator_id)

    conn = conn |> sign_in |> post(bill_path(conn, :create), bill: valid_attrs)
    assert redirected_to(conn) == bill_path(conn, :index)
    assert Repo.get_by(Bill, valid_attrs)
  end

  test "creates resource and set the creator to the current user", %{conn: conn} do
    my_user = create_user
    valid_attrs = Map.delete(valid_bill_attrs, :creator_id)

    conn = conn |> sign_in(my_user)
           |> post(bill_path(conn, :create), bill: valid_attrs)
    assert redirected_to(conn) == bill_path(conn, :index)
    user = Repo.get_by(Bill, valid_attrs)
    assert user
    assert user.creator_id == my_user.id
  end

  test "creates resource and a bill item with it", %{conn: conn} do
    valid_attrs = Map.delete(valid_bill_attrs, :creator_id)

    conn |> sign_in |> post(bill_path(conn, :create), bill: valid_attrs)
    bill = Repo.get_by(Bill, valid_attrs)
    assert Repo.get_by(BillItem, %{bill_id: bill.id})
  end

  test "creates resource and a bill member for the payer", %{conn: conn} do
    valid_attrs = Map.delete(valid_bill_attrs, :creator_id)

    conn |> sign_in |> post(bill_path(conn, :create), bill: valid_attrs)
    bill = Repo.get_by(Bill, valid_attrs)
    bill_item = Repo.get_by(BillItem, %{bill_id: bill.id})
    assert Repo.get_by(BillMember,
                       bill_item_id: bill_item.id,
                       user_id: bill.payer_id,
                       paid: true)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn |> sign_in
           |> post(bill_path(conn, :create), bill: @invalid_attrs)
    assert html_response(conn, 200) =~ "New bill"
  end

  test "shows chosen resource", %{conn: conn} do
    my_user = create_user

    bill = create_bill
    conn = conn |> sign_in(my_user) |> get(bill_path(conn, :show, bill))
    assert html_response(conn, 200) =~ "Show bill"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = sign_in(conn)
    assert_error_sent 404, fn ->
      get(conn, bill_path(conn, :show, -1))
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    conn = conn |> sign_in |> get(bill_path(conn, :edit, bill))
    assert html_response(conn, 200) =~ "Edit bill"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    valid_attrs = Map.delete(valid_bill_attrs, :creator_id)

    bill = Repo.insert! %Bill{}
    conn = conn |> sign_in
           |> put(bill_path(conn, :update, bill), bill: valid_attrs)
    assert redirected_to(conn) == bill_path(conn, :show, bill)
    assert Repo.get_by(Bill, valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    conn = conn |> sign_in
           |> put(bill_path(conn, :update, bill), bill: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit bill"
  end

  test "deletes chosen resource", %{conn: conn} do
    bill = Repo.insert! %Bill{}
    conn = conn |> sign_in |> delete(bill_path(conn, :delete, bill))
    assert redirected_to(conn) == bill_path(conn, :index)
    refute Repo.get(Bill, bill.id)
  end
end
