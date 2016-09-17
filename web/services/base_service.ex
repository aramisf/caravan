defmodule Caravan.BaseService do
  defmacro __using__(_opts) do
    quote do
      import Ecto
      import Ecto.Query
    end
  end
end
