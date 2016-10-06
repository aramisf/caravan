defmodule Caravan.LayoutView do
  use Caravan.Web, :view

  alias Caravan.User

  def can?(user, action, resource) do
    Bodyguard.authorized?(user, action, resource)
  end
end
