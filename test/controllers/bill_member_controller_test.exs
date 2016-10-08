defmodule Caravan.BillMemberControllerTest do
  use Caravan.ConnCase

  import Caravan.BillMemberTestHelpers

  alias Caravan.Repo
  alias Caravan.BillMember

  @invalid_attrs %{user_id: nil}

  setup %{conn: conn} do
    current_user = create_user(valid_admin_user_attrs)
    conn = sign_in(conn, current_user)
    {:ok, conn: conn, current_user: current_user}
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get(conn, bill_member_path(conn, :new, bill_item_id: 1))
    assert html_response(conn, 200) =~ "New bill member"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    valid_attrs = valid_bill_member_attrs
    bill_item_id = valid_attrs.bill_item_id

    conn = post(conn, bill_member_path(conn, :create), bill_member: valid_attrs)
    assert redirected_to(conn) == bill_item_path(conn, :edit, bill_item_id)
    assert Repo.get_by(BillMember, valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, bill_member_path(conn, :create),
                bill_member: Map.merge(@invalid_attrs, %{bill_item_id: 1}))
    assert html_response(conn, 200) =~ "New bill member"
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    bill_member = create_bill_member
    conn = get(conn, bill_member_path(conn, :edit, bill_member))
    assert html_response(conn, 200) =~ "Edit bill member"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    valid_attrs = Map.delete(valid_bill_member_attrs, :bill_item_id)

    bill_member = create_bill_member
    conn = put(conn, bill_member_path(conn, :update, bill_member),
               bill_member: valid_attrs)
    assert redirected_to(conn) == bill_item_path(conn, :edit, bill_member.bill_item_id)
    assert Repo.get_by(BillMember, valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    bill_member = create_bill_member
    conn = put(conn, bill_member_path(conn, :update, bill_member),
               bill_member: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit bill member"
  end

  test "deletes chosen resource", %{conn: conn} do
    bill_member_one = create_bill_member

    bill_member_two = create_bill_member(%{
      bill_item_id: bill_member_one.bill_item_id,
      user_id: create_user.id,
      paid: false
    })
    old_id = bill_member_two.id
    bill_item_id = bill_member_two.bill_item_id

    conn = delete(conn, bill_member_path(conn, :delete, bill_member_two))
    assert redirected_to(conn) == bill_item_path(conn, :edit, bill_item_id)
    refute Repo.get(BillMember, old_id)
  end

  test "does not delete the only resource", %{conn: conn} do
    bill_member = create_bill_member
    bill_item_id = bill_member.bill_item_id
    conn = delete(conn, bill_member_path(conn, :delete, bill_member))
    assert redirected_to(conn) == bill_item_path(conn, :edit, bill_item_id)
    assert Repo.get(BillMember, bill_member.id)
  end
end
