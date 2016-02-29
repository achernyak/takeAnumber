defmodule TakeAnumber.NumberControllerTest do
  use TakeAnumber.ConnCase

  alias TakeAnumber.Number
  @valid_attrs %{served: true}
  @blank_attrs %{}

  def with_valid_authorization_header(conn) do
    conn
    |> put_req_header("authorization", "Basic ZGV2OmRldnRlYW0=")
  end

  def with_invalid_authorization_header(conn) do
    conn
    |> put_req_header("authorization", "Basic I like turtles")
  end

  test "GET /next without authorization header should throw 401", %{conn: conn} do
    conn = get conn, "/next"
    assert response(conn, 401) == "unauthorized"
    assert get_resp_header(conn, "www-authenticate") == ["Basic reaml=\"Thou Shalt not pass\""]
  end

  test "Get /next with incorrect authorization should throw 401", %{conn: conn} do
    conn = conn
    |> with_invalid_authorization_header()
    |> get("/next")

    assert response(conn, 401) == "unauthorized"
    assert get_resp_header(conn, "www-authenticate") == ["Basic reaml=\"Thou Shalt not pass\""]
  end

  test "GET /next with correct authorization should be OK", %{conn: conn} do
    conn = conn
    |> with_valid_authorization_header()
    |> get("/next")

    assert html_response(conn, 200) =~ "Everyone is happy"
  end

  test "PATCH /next/:id changes served to true in the current number and redirects to index", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = conn
    |> with_valid_authorization_header()
    |> patch(number_path(conn, :next, number))

    assert Repo.get!(Number, number.id).served != number.served
    assert redirected_to(conn) == page_path(conn, :index)
  end

  test "lists all entries on index", %{conn: conn} do
    conn = conn
    |> with_valid_authorization_header()
    |> get(number_path(conn, :index))

    assert html_response(conn, 200) =~ "Listing numbers"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = conn
    |> with_valid_authorization_header()
    |> get(number_path(conn, :new))

    assert html_response(conn, 200) =~ "New number"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = conn
    |> with_valid_authorization_header()
    |> post(number_path(conn, :create), number: @valid_attrs)

    assert redirected_to(conn) == number_path(conn, :index)
    assert Repo.get_by(Number, @valid_attrs)
  end

  test "creates resource and redirect when data is blank", %{conn: conn} do
    conn = conn
    |> with_valid_authorization_header()
    |> post(number_path(conn, :create), number: @blank_attrs)
    assert redirected_to(conn) == number_path(conn, :index)
    assert Repo.get_by(Number, @blank_attrs)
  end

  test "shows chosen resource", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = conn
    |> with_valid_authorization_header()
    |> get(number_path(conn, :show, number))
    assert html_response(conn, 200) =~ "Show number"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      conn
      |> with_valid_authorization_header()
      |> get(number_path(conn, :show, -1))
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = conn
    |> with_valid_authorization_header()
    |> get(number_path(conn, :edit, number))
    assert html_response(conn, 200) =~ "Edit number"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = conn
    |> with_valid_authorization_header()
    |> put(number_path(conn, :update, number), number: @valid_attrs)
    assert redirected_to(conn) == number_path(conn, :show, number)
    assert Repo.get_by(Number, @valid_attrs)
  end

  test "updates chosen resource and redirects to data when data is blank", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = conn
    |> with_valid_authorization_header()
    |> put(number_path(conn, :update, number), number: @blank_attrs)
    assert redirected_to(conn) == number_path(conn, :show, number)
    assert Repo.get_by(Number, @blank_attrs)
  end

  test "deletes chosen resource", %{conn: conn} do
    number = Repo.insert! %Number{}
    conn = conn
    |> with_valid_authorization_header()
    |> delete(number_path(conn, :delete, number))
    assert redirected_to(conn) == number_path(conn, :index)
    refute Repo.get(Number, number.id)
  end
end
