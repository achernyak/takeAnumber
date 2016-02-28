defmodule TakeAnumber.NumberTest do
  use TakeAnumber.ModelCase

  alias TakeAnumber.Number

  @valid_attrs %{served: true}
  @blank_attrs %{}

  test "changeset with valid attributes" do
    changeset = Number.changeset(%Number{}, @valid_attrs)
    assert changeset.valid?
  end

  test "change set is valid with blank attributes" do
    changeset = Number.changeset(%Number{}, @blank_attrs)
    assert changeset.valid?
  end
end
