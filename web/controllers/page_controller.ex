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

  def new(conn, _params) do
    changeset = Number.changeset(%Number{}, %{served: false})

    case Repo.insert(changeset) do
      {:ok, number} ->
        conn
        |> put_flash(:info, "You are ##{number.id}, you will be served in order.")
        |> redirect(to: page_path(conn, :index))
      {:error, _} ->
        conn
        |> put_flash(:error, "Something went wrong! Please try again.")
        |> redirect(to: page_path(conn, :index))
    end
  end
end
