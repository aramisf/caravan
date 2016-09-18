defmodule Caravan.BillMemberControllerTest do
  use Caravan.ConnCase

  import Caravan.BillMemberTestHelpers

  alias Caravan.Repo
  alias Caravan.BillMember

  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = conn |> sign_in |> get(bill_member_path(conn, :index))
    assert html_response(conn, 200) =~ "Listing bill members"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn |> sign_in |> get(bill_member_path(conn, :new))
    assert html_response(conn, 200) =~ "New bill member"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    valid_attrs = valid_bill_member_attrs

    conn = conn |> sign_in
           |> post(bill_member_path(conn, :create), bill_member: valid_attrs)
    assert redirected_to(conn) == bill_member_path(conn, :index)
    assert Repo.get_by(BillMember, valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = conn |> sign_in
           |> post(bill_member_path(conn, :create), bill_member: @invalid_attrs)
    assert html_response(conn, 200) =~ "New bill member"
  end

  test "shows chosen resource", %{conn: conn} do
    bill_member = Repo.insert! %BillMember{}
    conn = conn |> sign_in |> get(bill_member_path(conn, :show, bill_member))
    assert html_response(conn, 200) =~ "Show bill member"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    conn = conn |> sign_in
    assert_error_sent 404, fn ->
      get conn, bill_member_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bill_member = Repo.insert! %BillMember{}
    conn = conn |> sign_in |> get(bill_member_path(conn, :edit, bill_member))
    assert html_response(conn, 200) =~ "Edit bill member"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    valid_attrs = valid_bill_member_attrs

    bill_member = Repo.insert! %BillMember{}
    conn = conn |> sign_in
           |> put(bill_member_path(conn, :update, bill_member),
                  bill_member: valid_attrs)
    assert redirected_to(conn) == bill_member_path(conn, :show, bill_member)
    assert Repo.get_by(BillMember, valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bill_member = Repo.insert! %BillMember{}
    conn = conn |> sign_in
           |> put(bill_member_path(conn, :update, bill_member),
                  bill_member: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit bill member"
  end

  test "deletes chosen resource", %{conn: conn} do
    bill_member = Repo.insert! %BillMember{}
    conn = conn |> sign_in
           |> delete(bill_member_path(conn, :delete, bill_member))
    assert redirected_to(conn) == bill_member_path(conn, :index)
    refute Repo.get(BillMember, bill_member.id)
  end
end
