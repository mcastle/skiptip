defmodule Skiptip.FacebookLoginTest do
  use Skiptip.ModelCase

  alias Skiptip.FacebookLogin

  @valid_attrs %{}
  @invalid_attrs %{}

	@tag :skip
  test "changeset with valid attributes" do
    changeset = FacebookLogin.changeset(%FacebookLogin{}, @valid_attrs)
    assert changeset.valid?
  end

	@tag :skip
  test "changeset with invalid attributes" do
    changeset = FacebookLogin.changeset(%FacebookLogin{}, @invalid_attrs)
    refute changeset.valid?
  end

end
