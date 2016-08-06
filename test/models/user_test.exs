defmodule Skiptip.UserTest do
  use Skiptip.ModelCase

  alias Skiptip.FacebookLogin
  alias Skiptip.BuyerProfile
  alias Skiptip.User
  alias Skiptip.Location
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
    token = Skiptip.Utils.random_string(26)
    facebook_user_id = Skiptip.Utils.random_string(14)
    refute FacebookLogin.find_user_by(:facebook_user_id, facebook_user_id)
    User.create(token, facebook_user_id, %{name: "anon", email: "anon@anon.com"})
    assert FacebookLogin.find_user_by(:facebook_user_id, facebook_user_id)
  end

  test "associated buyer_profile gets created on create" do
		user = Factory.create_user_with_valid_facebook_credentials
    assert BuyerProfile.find_by(:user_id, user.id)
  end

  test "associated location gets created on create" do
    user = Factory.create_user |> Repo.preload(:location)
    assert user.location
  end

  test "api_key generated on create" do
    user = Factory.create_user
    assert user.api_key
  end

  test "authenticate" do
    user = Factory.create_user
    assert User.authenticate(user.id, user.api_key) == user
    refute User.authenticate(user.id, "invalid key")
  end

end
