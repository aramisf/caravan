defmodule Caravan.UserView do
  use Caravan.Web, :view

  def main_content_classes(conn) do
    unless current_user(conn) do
      Enum.join [
        "col-xs-offset-1 col-xs-10",
        "col-sm-offset-2 col-sm-8",
        "col-md-offset-3 col-md-6",
        "col-lg-offset-4 col-lg-4",
      ], " "
    end
  end
end
