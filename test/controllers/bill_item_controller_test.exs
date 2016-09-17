defmodule Caravan.BillItemControllerTest do
  use Caravan.ConnCase

  alias Caravan.Repo
  alias Caravan.Bill
  alias Caravan.BillItem
  alias Caravan.User

  @valid_attrs %{bill_id: 1, amount: 42}
  @invalid_attrs %{}

  def real_valid_attrs do
    user = Repo.insert!(User.creation_changeset(%User{}, %{
                          email: "admin@dummy.com",
                          name: "Admin",
                          password: "password",
                          role: "admin"
                        }))

    bill = Repo.insert!(Bill.changeset(%Bill{}, %{
                          creator_id: user.id,
                          payer_id: user.id
                        }))

    %{bill_id: bill.id, amount: 62, description: "Real valid item"}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = conn |> sign_in |> get(bill_item_path(conn, :index))
    assert html_response(conn, 200) =~ "Listing bill items"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn |> sign_in |> get(bill_item_path(conn, :new))
    assert html_response(conn, 200) =~ "New bill item"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    create_valid_attrs = real_valid_attrs
    conn = conn |> sign_in
           |> post(bill_item_path(conn, :create), bill_item: create_valid_attrs)
    assert redirected_to(conn) == bill_item_path(conn, :index)
    assert Repo.get_by(BillItem, create_valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn |> sign_in
           |> post(bill_item_path(conn, :create), bill_item: @invalid_attrs)
    assert html_response(conn, 200) =~ "New bill item"
  end

  test "shows chosen resource", %{conn: conn} do
    bill_item = Repo.insert! %BillItem{}
    conn = conn |> sign_in |> get(bill_item_path(conn, :show, bill_item))
    assert html_response(conn, 200) =~ "Show bill item"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = sign_in(conn)
    assert_error_sent 404, fn ->
      get conn, bill_item_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bill_item = Repo.insert! %BillItem{}
    conn = conn |> sign_in |> get(bill_item_path(conn, :edit, bill_item))
    assert html_response(conn, 200) =~ "Edit bill item"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    update_valid_attrs = real_valid_attrs
    bill_item = Repo.insert! %BillItem{}
    conn = conn |> sign_in
           |> put(bill_item_path(conn, :update, bill_item), bill_item: update_valid_attrs)
    assert redirected_to(conn) == bill_item_path(conn, :show, bill_item)
    assert Repo.get_by(BillItem, update_valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bill_item = Repo.insert! %BillItem{}
    conn = conn |> sign_in
           |> put(bill_item_path(conn, :update, bill_item), bill_item: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit bill item"
  end

  test "deletes chosen resource", %{conn: conn} do
    bill_item = Repo.insert! %BillItem{}
    conn = conn |> sign_in |> delete(bill_item_path(conn, :delete, bill_item))
    assert redirected_to(conn) == bill_item_path(conn, :index)
    refute Repo.get(BillItem, bill_item.id)
  end
end