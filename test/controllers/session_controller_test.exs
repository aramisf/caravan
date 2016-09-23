defmodule Caravan.SessionControllerTest do
  use Caravan.ConnCase

  alias Caravan.Repo
  alias Caravan.User

  @valid_attrs %{email: "joao@mail.com", password: "password"}
  @invalid_attrs %{}
  @user_attrs %{email: "joao@mail.com", password: "password", name: "João"}

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "New session"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    Repo.insert(User.creation_changeset(%User{}, @user_attrs))

    conn = post conn, session_path(conn, :create), session: @valid_attrs
    assert redirected_to(conn) == "/"
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    assert html_response(conn, 200) =~ "New session"
  end

  test "deletes chosen resource", %{conn: conn} do
    conn = delete conn, session_path(conn, :delete, 0)
    assert redirected_to(conn) == session_path(conn, :new)
  end
end
