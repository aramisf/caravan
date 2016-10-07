defmodule Caravan.LayoutView do
  use Caravan.Web, :view

  alias Caravan.User

  def can?(user, action, resource) do
    Bodyguard.authorized?(user, action, resource)
  end

  def main_content_classes(view_module, conn) do
    if function_exported? view_module, :main_content_classes, 1 do
      view_module.main_content_classes(conn) || Enum.join [
        "col-xs-12",
        "col-sm-offset-1 col-sm-10",
        "col-md-offset-2 col-md-8",
        "col-lg-offset-3 col-lg-6",
      ], " "
    else
      Enum.join [
        "col-xs-12",
        "col-sm-offset-1 col-sm-10",
        "col-md-offset-2 col-md-8",
        "col-lg-offset-3 col-lg-6",
      ], " "
    end
  end
end
