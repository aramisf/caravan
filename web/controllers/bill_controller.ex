defmodule Caravan.BillController do
  use Caravan.Web, :controller

  alias Caravan.Bill
  alias Caravan.User

  def index(conn, _params) do
    bills = Bill |> Repo.all |> Repo.preload([:creator, :payer])
    render(conn, "index.html", bills: bills)
  end

  def new(conn, _params) do
    changeset = Bill.changeset(%Bill{})
    render(conn, "new.html", changeset: changeset, users: load_users)
  end

  def create(conn, %{"bill" => bill_params}) do
    bill_params = Map.put(bill_params, "creator_id", current_user(conn).id)
    changeset = Bill.changeset(%Bill{}, bill_params)

    case Repo.insert(changeset) do
      {:ok, _bill} ->
        conn
        |> put_flash(:info, "Bill created successfully.")
        |> redirect(to: bill_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, users: load_users)
    end
  end

  def show(conn, %{"id" => id}) do
    bill = Bill |> Repo.get!(id) |> Repo.preload([:creator, :payer])
    render(conn, "show.html", bill: bill)
  end

  def edit(conn, %{"id" => id}) do
    bill = Repo.get!(Bill, id)
    changeset = Bill.changeset(bill)
    render(conn, "edit.html",
           bill: bill,
           changeset: changeset,
           users: load_users)
  end

  def update(conn, %{"id" => id, "bill" => bill_params}) do
    bill = Repo.get!(Bill, id)
    bill_params = Map.put(bill_params, "creator_id", current_user(conn).id)
    changeset = Bill.changeset(bill, bill_params)

    case Repo.update(changeset) do
      {:ok, bill} ->
        conn
        |> put_flash(:info, "Bill updated successfully.")
        |> redirect(to: bill_path(conn, :show, bill))
      {:error, changeset} ->
        render(conn, "edit.html",
               bill: bill,
               changeset: changeset,
               users: load_users)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill = Repo.get!(Bill, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(bill)

    conn
    |> put_flash(:info, "Bill deleted successfully.")
    |> redirect(to: bill_path(conn, :index))
  end

  defp current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  defp load_users do
    query = from(u in User, select: {u.name, u.id})
    Repo.all(query)
  end
end
