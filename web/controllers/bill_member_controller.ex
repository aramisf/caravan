defmodule Caravan.BillMemberController do
  use Caravan.Web, :controller

  alias Caravan.BillItem
  alias Caravan.BillMember
  alias Caravan.BillMemberService
  alias Caravan.User

  plug :verify_authorized

  def index(conn, _params) do
    bill_members = scope(conn, BillMember) |> Repo.all |> Repo.preload(:user)
    conn |> authorize!(BillMember)
    |> render("index.html", bill_members: bill_members)
  end

  def new(conn, _params) do
    bill_member = %BillMember{}
    conn = authorize!(conn, bill_member)

    changeset = BillMember.changeset(bill_member)
    render(conn, "new.html",
           changeset: changeset,
           bill_items: load_bill_items(conn),
           users: load_users)
  end

  def create(conn, %{"bill_member" => bill_member_params}) do
    changeset = BillMember.changeset(%BillMember{}, bill_member_params)

    conn = authorize!(conn, changeset.data)

    case Repo.insert(changeset) do
      {:ok, _bill_member} ->
        conn
        |> put_flash(:info, "Bill member created successfully.")
        |> redirect(to: bill_member_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html",
               changeset: changeset,
               bill_items: load_bill_items(conn),
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
           bill_items: load_bill_items(conn),
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
               bill_items: load_bill_items(conn),
               users: load_users)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill_member = scope(conn, BillMember) |> Repo.get!(id)

    conn = authorize!(conn, bill_member)

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

  defp current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  defp load_bill_items(conn) do
    query = from(bi in BillItem,
                 join: b in assoc(bi, :bill),
                 where: ^current_user(conn).id in [b.creator_id, b.payer_id],
                 select: {bi.id, bi.id})
    Repo.all(query)
  end

  defp load_users do
    query = from(u in User, select: {u.name, u.id})
    Repo.all(query)
  end
end
