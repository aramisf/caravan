defmodule Caravan.SessionController do
  use Caravan.Web, :controller

  alias Caravan.Session

  def new(conn, _params) do
    changeset = Session.changeset(%Session{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"session" => session_params}) do
    case Session.find_user_and_validate_password(session_params) do
      {:ok, user} ->
        conn
        |> Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Logged in successfully.")
        |> redirect(to: "/")
      {:error, changeset} ->
        render(conn, "new.html", changeset: %{changeset | action: :insert})
    end
  end

  def delete(conn, %{"id" => _id}) do
    conn
    |> Guardian.Plug.sign_out
    |> put_flash(:info, "Logged out successfully.")
    |> redirect(to: session_path(conn, :new))
  end
end
