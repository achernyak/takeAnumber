defmodule TakeAnumber.PageController do
  use TakeAnumber.Web, :controller

  alias TakeAnumber.Number

  def index(conn, _params) do
    query = from n in Number,
      where: n.served == false
    case Repo.all(query) do
      [] ->
        render(conn, "finished.html")
      [number | _] ->
        render(conn, "index.html", number: number)
    end
  end

  def new(conn, _params) do
    number = Repo.insert!(%Number{})
    conn
    |> put_flash(:info, "You are # #{number.id}, you will be served in order.")
    |> redirect(to: page_path(conn, :index))
  end
end
