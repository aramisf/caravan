defmodule Caravan.BillItemController do
  use Caravan.Web, :controller

  alias Caravan.BillItem
  alias Caravan.BillItemService

  plug :verify_authorized

  def new(conn, %{"bill_id" => bill_id}) do
    bill_item = %BillItem{bill_id: bill_id}
    conn = authorize!(conn, bill_item)

    changeset = BillItem.changeset(bill_item)

    render(conn, "new.html", bill_id: bill_id, changeset: changeset)
  end

  def create(conn, %{"bill_item" => bill_item_params}) do
    changeset = BillItem.changeset(%BillItem{}, bill_item_params)

    conn = authorize!(conn, changeset.data)

    case Repo.insert(changeset) do
      {:ok, bill_item} ->
        conn
        |> put_flash(:info, "Bill item created successfully.")
        |> redirect(to: bill_path(conn, :show, bill_item.bill_id))
      {:error, changeset} ->
        %{"bill_id" => bill_id} = bill_item_params
        render(conn, "new.html",
               bill_id: bill_id,
               changeset: changeset)
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

    render(conn, "edit.html", bill_item: bill_item, changeset: changeset)
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
        render(conn, "edit.html", bill_item: bill_item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bill_item = scope(conn, BillItem) |> Repo.get!(id)
    bill_id = bill_item.bill_id

    conn = authorize!(conn, bill_item)

    case BillItemService.delete(bill_item) do
      :ok ->
        conn
        |> put_flash(:info, "Bill item deleted successfully.")
        |> redirect(to: bill_path(conn, :show, bill_id))
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: bill_path(conn, :show, bill_id))
    end
  end
end
