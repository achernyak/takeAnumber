defmodule TakeAnumber.NumberControllerTest do
  use TakeAnumber.ConnCase

  alias TakeAnumber.Number
  @valid_attrs %{served: true}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, number_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing numbers"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, number_path(conn, :new)
    assert html_response(conn, 200) =~ "New number"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, number_path(conn, :create), number: @valid_attrs
    assert redirected_to(conn) == number_path(conn, :index)
    assert Repo.get_by(Number, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, number_path(conn, :create), number: @invalid_attrs
    assert html_response(conn, 200) =~ "New number"
  end

  test "shows chosen resource", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = get conn, number_path(conn, :show, number)
    assert html_response(conn, 200) =~ "Show number"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, number_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = get conn, number_path(conn, :edit, number)
    assert html_response(conn, 200) =~ "Edit number"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = put conn, number_path(conn, :update, number), number: @valid_attrs
    assert redirected_to(conn) == number_path(conn, :show, number)
    assert Repo.get_by(Number, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = put conn, number_path(conn, :update, number), number: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit number"
  end

  test "deletes chosen resource", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = delete conn, number_path(conn, :delete, number)
    assert redirected_to(conn) == number_path(conn, :index)
    refute Repo.get(Number, number.id)
  end
end
