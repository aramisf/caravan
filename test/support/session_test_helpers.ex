defmodule Caravan.SessionTestHelpers do
  use Phoenix.ConnTest

  import Caravan.UserTestHelpers

  @endpoint Caravan.Endpoint

  # We need a way to get into the connection to login a user
  # We need to use the bypass_through to fire the plugs in the router
  # and get the session fetched.
  def sign_in(conn, user \\ create_user, token \\ :token, opts \\ []) do
    conn
      |> bypass_through(Caravan.Router, [:browser])
      |> get("/")
      |> Guardian.Plug.sign_in(user, token, opts)
      |> send_resp(200, "Flush the session yo")
      |> recycle()
  end
end

