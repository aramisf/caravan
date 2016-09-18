defmodule Caravan.BillMemberController do
  use Caravan.Web, :controller

  alias Caravan.BillItem
  alias Caravan.BillMember
  alias Caravan.BillMemberService
  alias Caravan.User

  def index(conn, _params) do
    bill_members = Repo.all(BillMember) |> Repo.preload(:user)
    render(conn, "index.html", bill_members: bill_members)
  end

  def new(conn, _params) do
    changeset = BillMember.changeset(%BillMember{})
    render(conn, "new.html",
           changeset: changeset,
           bill_items: load_bill_items,
           users: load_users)
  end

  def create(conn, %{"bill_member" => bill_member_params}) do
    changeset = BillMember.changeset(%BillMember{}, bill_member_params)

    case Repo.insert(changeset) do
      {:ok, _bill_member} ->
        conn
        |> put_flash(:info, "Bill member created successfully.")
        |> redirect(to: bill_member_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html",
               changeset: changeset,
               bill_items: load_bill_items,
               users: load_users)
    end
  end

  def show(conn, %{"id" => id}) do
    bill_member = Repo.get!(BillMember, id) |> Repo.preload(:user)
    render(conn, "show.html", bill_member: bill_member)
  end

  def edit(conn, %{"id" => id}) do
    bill_member = Repo.get!(BillMember, id)
    changeset = BillMember.changeset(bill_member)
    render(conn, "edit.html",
           bill_member: bill_member,
           changeset: changeset,
           bill_items: load_bill_items,
           users: load_users)
  end

  def update(conn, %{"id" => id, "bill_member" => bill_member_params}) do
    bill_member = Repo.get!(BillMember, id)
    changeset = BillMember.changeset(bill_member, bill_member_params)

    case Repo.update(changeset) do
      {:ok, bill_member} ->
        conn
        |> put_flash(:info, "Bill member updated successfully.")
        |> redirect(to: bill_member_path(conn, :show, bill_member))
      {:error, changeset} ->
        render(conn, "edit.html",
               bill_member: bill_member,
               changeset: changeset,
               bill_items: load_bill_items,
               users: load_users)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill_member = Repo.get!(BillMember, id)

    case BillMemberService.delete(bill_member) do
      :ok ->
        conn
        |> put_flash(:info, "Bill member deleted successfully.")
        |> redirect(to: bill_member_path(conn, :index))
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: bill_member_path(conn, :index))
    end
  end

  defp load_bill_items do
    query = from(b in BillItem, select: {b.id, b.id})
    Repo.all(query)
  end

  defp load_users do
    query = from(u in User, select: {u.name, u.id})
    Repo.all(query)
  end
end
