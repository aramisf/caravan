defmodule Caravan.BillItemController do
  use Caravan.Web, :controller

  alias Caravan.BillItem
  alias Caravan.BillItemService
  alias Caravan.BillMemberQuery
  alias Caravan.User

  plug :verify_authorized

  def new(conn, params) do
    %{"bill_id" => bill_id} = params
    return_to = params["return_to"] || bill_path(conn, :edit, bill_id)

    bill_item = %BillItem{bill_id: bill_id}
    conn = authorize!(conn, bill_item)

    changeset = BillItem.changeset(bill_item)

    render(conn, "new.html",
           bill_id: bill_id,
           users: load_users,
           return_to: return_to,
           changeset: changeset)
  end

  def create(conn, %{"bill_item" => bill_item_params}) do
    %{"bill_id" => bill_id} = bill_item_params
    return_to = bill_item_params["return_to"]
                || bill_path(conn, :edit, bill_id)

    bill_item = %BillItem{bill_id: bill_id}
    changeset = BillItem.changeset(bill_item, bill_item_params)

    conn = authorize!(conn, bill_item)

    case BillItemService.create(changeset) do
      {:ok, bill_item} ->
        conn
        |> put_flash(:info, "Bill item created successfully.")
        |> redirect(to: return_to)
      {:error, changeset} ->
        render(conn, "new.html",
               bill_id: bill_id,
               users: load_users,
               return_to: return_to,
               changeset: changeset)
    end
  end

  def edit(conn, params) do
    %{"id" => id} = params
    bill_item = scope(conn, BillItem) |> Repo.get!(id)
    return_to = params["return_to"]
                || bill_path(conn, :edit, bill_item.bill_id)

    bill_members = BillMemberQuery.by_bill_item(id)
                   |> Repo.all
                   |> Repo.preload(:user)

    conn = authorize!(conn, bill_item)

    changeset = BillItem.changeset(bill_item)

    render(conn, "edit.html",
           bill_members: bill_members,
           bill_item: bill_item,
           return_to: return_to,
           changeset: changeset)
  end

  def update(conn, %{"id" => id, "bill_item" => bill_item_params}) do
    bill_item = scope(conn, BillItem) |> Repo.get!(id)
    return_to = bill_item_params["return_to"]
                || bill_item_path(conn, :edit, bill_item)

    bill_members = BillMemberQuery.by_bill_item(id)
                   |> Repo.all
                   |> Repo.preload(:user)

    changeset = BillItem.changeset(bill_item, bill_item_params)

    conn = authorize!(conn, bill_item)

    case Repo.update(changeset) do
      {:ok, bill_item} ->
        conn
        |> put_flash(:info, "Bill item updated successfully.")
        |> redirect(to: return_to)
      {:error, changeset} ->
        render(conn, "edit.html",
               bill_members: bill_members,
               bill_item: bill_item,
               return_to: return_to,
               changeset: changeset)
    end
  end

  def delete(conn, params) do
    %{"id" => id} = params
    bill_item = scope(conn, BillItem) |> Repo.get!(id)
    bill_id = bill_item.bill_id
    return_to = params["return_to"] || bill_path(conn, :edit, bill_id)


    conn = authorize!(conn, bill_item)

    case BillItemService.delete(bill_item) do
      :ok ->
        conn
        |> put_flash(:info, "Bill item deleted successfully.")
        |> redirect(to: return_to)
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: return_to)
    end
  end

  defp load_users do
    query = from(u in User, select: {u.name, u.id})
    Repo.all(query)
  end
end
