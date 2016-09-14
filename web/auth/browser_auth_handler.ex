defmodule Caravan.BrowserAuthHandler do
  use Phoenix.Controller

  def unauthenticated(conn, _params) do
    conn
    |> put_flash(:error, "Authentication required")
    |> redirect(to: "/sessions/new")
  end
end
