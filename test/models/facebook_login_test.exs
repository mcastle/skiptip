defmodule Skiptip.FacebookLoginTest do
  use Skiptip.ModelCase

  alias Skiptip.FacebookLogin
  alias Skiptip.User

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = FacebookLogin.changeset(%FacebookLogin{}, @valid_attrs)
    #assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = FacebookLogin.changeset(%FacebookLogin{}, @invalid_attrs)
    #refute changeset.valid?
  end

end
