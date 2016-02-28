defmodule TakeAnumber.NumberController do
  use TakeAnumber.Web, :controller

  alias TakeAnumber.Number

  plug :scrub_params, "number" when action in [:create, :update]

  plug BasicAuth, username: "dev", password: "devteam"

  def index(conn, _params) do
    numbers = Repo.all(Number)
    render(conn, "index.html", numbers: numbers)
  end

  def next_page(conn, _params) do
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
    changeset = Number.changeset(%Number{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"number" => number_params}) do
    changeset = Number.changeset(%Number{}, number_params)

    case Repo.insert(changeset) do
      {:ok, _number} ->
        conn
        |> put_flash(:info, "Number created successfully.")
        |> redirect(to: number_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    number = Repo.get!(Number, id)
    render(conn, "show.html", number: number)
  end

  def edit(conn, %{"id" => id}) do
    number = Repo.get!(Number, id)
    changeset = Number.changeset(number)
    render(conn, "edit.html", number: number, changeset: changeset)
  end

  def update(conn, %{"id" => id, "number" => number_params}) do
    number = Repo.get!(Number, id)
    changeset = Number.changeset(number, number_params)

    case Repo.update(changeset) do
      {:ok, number} ->
        conn
        |> put_flash(:info, "Number updated successfully.")
        |> redirect(to: number_path(conn, :show, number))
      {:error, changeset} ->
        render(conn, "edit.html", number: number, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    number = Repo.get!(Number, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(number)

    conn
    |> put_flash(:info, "Number deleted successfully.")
    |> redirect(to: number_path(conn, :index))
  end
end
