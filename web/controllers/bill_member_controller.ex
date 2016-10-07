defmodule Caravan.BillMemberController do
  use Caravan.Web, :controller

  alias Caravan.BillMember
  alias Caravan.BillMemberService
  alias Caravan.User

  plug :verify_authorized

  def new(conn, %{"bill_item_id" => bill_item_id}) do
    bill_member = %BillMember{bill_item_id: bill_item_id}
    conn = authorize!(conn, bill_member)

    changeset = BillMember.changeset(bill_member)
    render(conn, "new.html",
           changeset: changeset,
           bill_item_id: bill_item_id,
           users: load_users)
  end

  def create(conn, %{"bill_member" => bill_member_params}) do
    changeset = BillMember.changeset(%BillMember{}, bill_member_params)

    conn = authorize!(conn, changeset.data)

    case Repo.insert(changeset) do
      {:ok, bill_member} ->
        conn
        |> put_flash(:info, "Bill member created successfully.")
        |> redirect(to: bill_item_path(conn, :edit, bill_member.bill_item_id))
      {:error, changeset} ->
        %{"bill_item_id" => bill_item_id} = bill_member_params
        render(conn, "new.html",
               changeset: changeset,
               bill_item_id: bill_item_id,
               users: load_users)
    end
  end

  def show(conn, %{"id" => id}) do
    bill_member = scope(conn, BillMember) |> Repo.get!(id)
                  |> Repo.preload(:user)
    conn |> authorize!(bill_member)
    |> render("show.html", bill_member: bill_member)
  end

  def edit(conn, %{"id" => id}) do
    bill_member = scope(conn, BillMember) |> Repo.get!(id)
    conn = authorize!(conn, bill_member)

    changeset = BillMember.changeset(bill_member)

    render(conn, "edit.html",
           bill_member: bill_member,
           changeset: changeset,
           users: load_users)
  end

  def update(conn, %{"id" => id, "bill_member" => bill_member_params}) do
    bill_member = scope(conn, BillMember) |> Repo.get!(id)
    changeset = BillMember.changeset(bill_member, bill_member_params)

    conn = authorize!(conn, bill_member)

    case Repo.update(changeset) do
      {:ok, bill_member} ->
        conn
        |> put_flash(:info, "Bill member updated successfully.")
        |> redirect(to: bill_member_path(conn, :show, bill_member))
      {:error, changeset} ->
        render(conn, "edit.html",
               bill_member: bill_member,
               changeset: changeset,
               users: load_users)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill_member = scope(conn, BillMember) |> Repo.get!(id)
    bill_item_id = bill_member.bill_item_id

    conn = authorize!(conn, bill_member)

    case BillMemberService.delete(bill_member) do
      :ok ->
        conn
        |> put_flash(:info, "Bill member deleted successfully.")
        |> redirect(to: bill_item_path(conn, :edit, bill_item_id))
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: bill_item_path(conn, :edit, bill_item_id))
    end
  end

  defp load_users do
    query = from(u in User, select: {u.name, u.id})
    Repo.all(query)
  end
end
