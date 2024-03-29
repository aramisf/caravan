defmodule Caravan.BillController do
  use Caravan.Web, :controller

  alias Caravan.Bill
  alias Caravan.BillQuery
  alias Caravan.BillItemQuery
  alias Caravan.BillMemberQuery
  alias Caravan.User

  alias Caravan.BillService

  plug :verify_authorized

  def index(conn, _params) do
    bills = scope(conn, Bill) |> Repo.all |> Repo.preload([:creator, :payer])

    conn |> authorize!(Bill) |> render("index.html", bills: bills)
  end

  def new(conn, _params) do
    bill = %Bill{}
    conn = authorize!(conn, bill)

    changeset = Bill.changeset(bill)

    render(conn, "new.html",
           changeset: changeset,
           users: load_users,
           payer_id: current_user(conn).id)
  end

  def create(conn, %{"bill" => bill_params}) do
    bill = %Bill{creator_id: current_user(conn).id}
    bill_params = Map.put(bill_params, "creator_id", current_user(conn).id)
    bill_changeset = Bill.creation_changeset bill, bill_params

    conn = authorize!(conn, bill)

    case BillService.create(bill_changeset) do
      {:ok, _bill} ->
        conn
        |> put_flash(:info, "Bill created successfully.")
        |> redirect(to: bill_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html",
               changeset: changeset,
               users: load_users,
               payer_id: current_user(conn).id)
    end
  end

  def edit(conn, %{"id" => id}) do
    bill = scope(conn, Bill) |> Repo.get!(id)

    bill_items_query = BillItemQuery.by_bill(bill.id)
    show_advanced = Repo.one(select(bill_items_query, [bi], count(bi.id))) > 1
    bill_items = Repo.all bill_items_query

    bill_members = BillMemberQuery.by_bill(bill.id)
                   |> Repo.all
                   |> Repo.preload(:user)

    bill = %{bill | total_amount: BillQuery.total_amount(bill)}

    conn = authorize!(conn, bill)

    changeset = Bill.changeset(bill)

    render(conn, "edit.html",
           bill: bill,
           bill_items: bill_items,
           bill_members: bill_members,
           show_advanced: show_advanced,
           changeset: changeset,
           users: load_users)
  end

  def update(conn, %{"id" => id, "bill" => bill_params}) do
    bill = scope(conn, Bill) |> Repo.get!(id)
    bill_params = Map.put(bill_params, "creator_id", current_user(conn).id)
    changeset = Bill.changeset(bill, bill_params)

    conn = authorize!(conn, bill)

    case BillService.update(changeset) do
      {:ok, bill} ->
        conn
        |> put_flash(:info, "Bill updated successfully.")
        |> redirect(to: bill_path(conn, :index))
      {:error, changeset} ->
        bill_items_query = BillItemQuery.by_bill(bill.id)
        show_advanced = Repo.one(select(bill_items_query, [bi], count(bi.id))) > 1
        bill_items = Repo.all bill_items_query

        bill_members = BillMemberQuery.by_bill(bill.id)
                       |> Repo.all
                       |> Repo.preload(:user)

        render(conn, "edit.html",
               bill: bill,
               bill_items: bill_items,
               bill_members: bill_members,
               show_advanced: show_advanced,
               changeset: changeset,
               users: load_users)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill = scope(conn, Bill) |> Repo.get!(id)

    conn = authorize!(conn, bill)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bill)

    conn
    |> put_flash(:info, "Bill deleted successfully.")
    |> redirect(to: bill_path(conn, :index))
  end

  defp load_users do
    query = from(u in User, select: {u.name, u.id})
    Repo.all(query)
  end
end
