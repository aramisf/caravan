defmodule Caravan.BasePolicy do
  defmacro __using__(_opts) do
    quote do
      import Ecto
      import Ecto.Query
    end
  end
end

