defmodule Caravan.ServiceCase do
  @moduledoc """
  This module defines the test case to be used by
  tests for services.

  As normally the services access database to test,
  the SQL.Sandbox is activated on the tests setup.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with database
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Caravan.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Caravan.Repo, {:shared, self()})
    end

    {:ok, :ok}
  end
end
