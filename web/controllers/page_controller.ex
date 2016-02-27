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

  def next(conn, %{"id" => id}) do
    number = Repo.get!(Number, id)
    changeset = Number.changeset(number, %{served: true})

    case Repo.update(changeset) do
      {:ok, number} ->
        conn
        |> redirect(to: page_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "Something went wrong")
    end
  end
end
