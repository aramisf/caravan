defmodule Caravan.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Caravan.Repo
      alias Caravan.User
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Caravan.Router.Helpers

      # The default endpoint for testing
      @endpoint Caravan.Endpoint

      # We need a way to get into the connection to login a user
      # We need to use the bypass_through to fire the plugs in the router
      # and get the session fetched.
      def create_user do
        attrs = %{email: "io@mail.com", name: "io", password: "io"}
        Repo.insert!(User.creation_changeset(%User{}, attrs))
      end

      def sign_in(conn, user \\ create_user, token \\ :token, opts \\ []) do
        conn
          |> bypass_through(Caravan.Router, [:browser])
          |> get("/")
          |> Guardian.Plug.sign_in(user, token, opts)
          |> send_resp(200, "Flush the session yo")
          |> recycle()
      end
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Caravan.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Caravan.Repo, {:shared, self()})
    end

    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
