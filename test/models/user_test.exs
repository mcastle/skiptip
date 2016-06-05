defmodule Skiptip.UserTest do
  use Skiptip.ModelCase

  alias Skiptip.FacebookLogin
  alias Skiptip.BuyerProfile
  alias Skiptip.User
  alias Skiptip.Factory

  @valid_attrs %{}
  @invalid_attrs %{}

  @tag :skip
  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  @tag :skip
  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "associated facebook_login gets created on create" do
    token = "access_token"
    facebook_user_id = "12345678900987654321"
    refute FacebookLogin.find_user_by(:facebook_user_id, facebook_user_id)
    User.create(token, facebook_user_id)
    assert FacebookLogin.find_user_by(:facebook_user_id, facebook_user_id)
  end

  test "associated buyer_profile gets created on create" do
    user = Factory.create_user
    assert BuyerProfile.find_by(:user_id, user.id)
  end

end
