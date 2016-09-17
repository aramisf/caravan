defmodule Caravan.BillItemController do
  use Caravan.Web, :controller

  alias Caravan.Bill
  alias Caravan.BillItem
  alias Caravan.BillItemService

  def index(conn, _params) do
    bill_items = Repo.all(BillItem)
    render(conn, "index.html", bill_items: bill_items)
  end

  def new(conn, _params) do
    changeset = BillItem.changeset(%BillItem{})
    render(conn, "new.html", changeset: changeset, bills: load_bills)
  end

  def create(conn, %{"bill_item" => bill_item_params}) do
    changeset = BillItem.changeset(%BillItem{}, bill_item_params)

    case Repo.insert(changeset) do
      {:ok, _bill_item} ->
        conn
        |> put_flash(:info, "Bill item created successfully.")
        |> redirect(to: bill_item_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, bills: load_bills)
    end
  end

  def show(conn, %{"id" => id}) do
    bill_item = Repo.get!(BillItem, id)
    render(conn, "show.html", bill_item: bill_item)
  end

  def edit(conn, %{"id" => id}) do
    bill_item = Repo.get!(BillItem, id)
    changeset = BillItem.changeset(bill_item)
    render(conn, "edit.html",
           bill_item: bill_item,
           changeset: changeset,
           bills: load_bills)
  end

  def update(conn, %{"id" => id, "bill_item" => bill_item_params}) do
    bill_item = Repo.get!(BillItem, id)
    changeset = BillItem.changeset(bill_item, bill_item_params)

    case Repo.update(changeset) do
      {:ok, bill_item} ->
        conn
        |> put_flash(:info, "Bill item updated successfully.")
        |> redirect(to: bill_item_path(conn, :show, bill_item))
      {:error, changeset} ->
        render(conn, "edit.html",
               bill_item: bill_item,
               changeset: changeset,
               bills: load_bills)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill_item = Repo.get!(BillItem, id)

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

  defp load_bills do
    query = from(b in Bill, select: {b.id, b.id})
    Repo.all(query)
  end
end
