defmodule TakeAnumber.PageControllerTest do
  use TakeAnumber.ConnCase

  alias TakeAnumber.Number
  @served_attrs %{served: true}
  @blank_attrs %{}

  test "shows a message when no entries are present", %{conn: conn} do
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "Everyone is happy"
  end

  test "displays the next entry if an entry is present", %{conn: conn} do
    Repo.insert! %Number{}
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "Now Serving"
  end

  test "POST /new inserts an entry and redirects to indes", %{conn: conn} do
    old_length = Repo.all(Number) |> length
    conn = post conn, page_path(conn, :new)
    new_length = Repo.all(Number) |> length

    assert old_length < new_length
    assert get_flash(conn, :info) =~ "You are # "
    assert redirected_to(conn) == page_path(conn, :index)
  end
 end
