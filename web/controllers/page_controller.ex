defmodule TakeAnumber.PageController do
  use TakeAnumber.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
