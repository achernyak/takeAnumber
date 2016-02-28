defmodule TakeAnumber.BasicAuthPlugTest do
  use ExUnit.Case

  test "not passing :username raises an error" do
    assert_raise KeyError, fn ->
      BasicAuth.init(password: "secret")
    end
  end

  test "not passing :password raises an error" do
    assert_raise KeyError, fn ->
      BasicAuth.init(username: "user")
    end
  end
end
