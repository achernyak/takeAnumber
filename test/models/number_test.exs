defmodule TakeAnumber.NumberTest do
  use TakeAnumber.ModelCase

  alias TakeAnumber.Number

  @valid_attrs %{served: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Number.changeset(%Number{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Number.changeset(%Number{}, @invalid_attrs)
    refute changeset.valid?
  end
end
