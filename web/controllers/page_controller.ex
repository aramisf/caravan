defmodule Caravan.PageController do
  use Caravan.Web, :controller

  def index(conn, _params) do
    redirect conn, to: bill_path(conn, :index)
  end
end
