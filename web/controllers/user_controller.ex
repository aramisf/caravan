defmodule Caravan.UserController do
  use Caravan.Web, :controller

  alias Caravan.User

  plug :verify_authorized

  def index(conn, _params) do
    users = scope(conn, User) |> Repo.all
    conn |> authorize!(User) |> render("index.html", users: users)
  end

  def new(conn, _params) do
    user = %User{}
    conn = authorize!(conn, user)
    changeset = User.creation_changeset(user)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.creation_changeset(%User{}, user_params)

    conn = authorize!(conn, changeset.data)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn = if current_user(conn) do
          conn
        else
          Guardian.Plug.sign_in(conn, user)
        end

        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = scope(conn, User) |> Repo.get!(id)
    conn |> authorize!(user) |> render("show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = scope(conn, User) |> Repo.get!(id)
    changeset = User.changeset(user)

    conn |> authorize!(user)
    |> render("edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = scope(conn, User) |> Repo.get!(id)
    conn = authorize!(conn, user)

    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = scope(conn, User) |> Repo.get!(id)
    conn = authorize!(conn, user)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
