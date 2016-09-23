defmodule Caravan.BillItemController do
  use Caravan.Web, :controller

  alias Caravan.Bill
  alias Caravan.BillItem
  alias Caravan.BillItemService

  plug :verify_authorized

  def index(conn, _params) do
    bill_items = scope(conn, BillItem) |> Repo.all

    conn |> authorize!(BillItem) |> render("index.html", bill_items: bill_items)
  end

  def new(conn, _params) do
    bill_item = %BillItem{}
    conn = authorize!(conn, bill_item)

    changeset = BillItem.changeset(bill_item)

    render(conn, "new.html", changeset: changeset, bills: load_bills(conn))
  end

  def create(conn, %{"bill_item" => bill_item_params}) do
    changeset = BillItem.changeset(%BillItem{}, bill_item_params)

    conn = authorize!(conn, changeset.data)

    case Repo.insert(changeset) do
      {:ok, _bill_item} ->
        conn
        |> put_flash(:info, "Bill item created successfully.")
        |> redirect(to: bill_item_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, bills: load_bills(conn))
    end
  end

  def show(conn, %{"id" => id}) do
    bill_item = scope(conn, BillItem) |> Repo.get!(id)
    conn |> authorize!(bill_item) |> render("show.html", bill_item: bill_item)
  end

  def edit(conn, %{"id" => id}) do
    bill_item = scope(conn, BillItem) |> Repo.get!(id)
    conn = authorize!(conn, bill_item)

    changeset = BillItem.changeset(bill_item)

    render(conn, "edit.html",
           bill_item: bill_item,
           changeset: changeset,
           bills: load_bills(conn))
  end

  def update(conn, %{"id" => id, "bill_item" => bill_item_params}) do
    bill_item = scope(conn, BillItem) |> Repo.get!(id)
    changeset = BillItem.changeset(bill_item, bill_item_params)

    conn = authorize!(conn, bill_item)

    case Repo.update(changeset) do
      {:ok, bill_item} ->
        conn
        |> put_flash(:info, "Bill item updated successfully.")
        |> redirect(to: bill_item_path(conn, :show, bill_item))
      {:error, changeset} ->
        render(conn, "edit.html",
               bill_item: bill_item,
               changeset: changeset,
               bills: load_bills(conn))
    end
  end

  def delete(conn, %{"id" => id}) do
    bill_item = scope(conn, BillItem) |> Repo.get!(id)

    conn = authorize!(conn, bill_item)

    case BillItemService.delete(bill_item) do
      :ok ->
        conn
        |> put_flash(:info, "Bill item deleted successfully.")
        |> redirect(to: bill_item_path(conn, :index))
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: bill_item_path(conn, :index))
    end
  end

  defp current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  defp load_bills(conn) do
    query = from(b in Bill,
                 where: ^current_user(conn).id in [b.creator_id, b.payer_id],
                 select: {b.id, b.id})
    Repo.all(query)
  end
end
