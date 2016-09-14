defmodule Caravan.PageControllerTest do
  use Caravan.ConnCase

  test "GET /", %{conn: conn} do
    conn = conn |> sign_in |> get("/")

    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end
end
