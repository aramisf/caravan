defmodule Caravan.PageControllerTest do
  use Caravan.ConnCase

  test "GET /", %{conn: conn} do
    conn = conn |> sign_in |> get("/")

    assert redirected_to(conn) == bill_path(conn, :index)
  end
end
