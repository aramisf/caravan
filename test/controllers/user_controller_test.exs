defmodule Caravan.UserControllerTest do
  use Caravan.ConnCase

  import Caravan.UserTestHelpers

  alias Caravan.Repo
  alias Caravan.User

  @valid_attrs %{email: "joao@mail.com", name: "João", password: "password"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = sign_in(conn, create_user(valid_admin_user_attrs))
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get(conn, user_path(conn, :index))
    assert html_response(conn, 200) =~ "Listing users"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn |> get(user_path(conn, :new))
    assert html_response(conn, 200) =~ "New user"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn |> post(user_path(conn, :create), user: @valid_attrs)
    assert redirected_to(conn) == "/"
    assert Repo.get_by(User, Map.delete(@valid_attrs, :password))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "New user"
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get(conn, user_path(conn, :show, user))
    assert html_response(conn, 200) =~ "Show user"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get(conn, user_path(conn, :show, -1))
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get(conn, user_path(conn, :edit, user))
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put(conn, user_path(conn, :update, user), user: @valid_attrs)
    assert redirected_to(conn) == user_path(conn, :show, user)
    assert Repo.get_by(User, Map.delete(@valid_attrs, :password))
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put(conn, user_path(conn, :update, user), user: @invalid_attrs)
    assert html_response(conn, 200) =~ "Edit user"
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete(conn, user_path(conn, :delete, user))
    assert redirected_to(conn) == user_path(conn, :index)
    refute Repo.get(User, user.id)
  end
end
