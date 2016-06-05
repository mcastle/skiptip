defmodule Skiptip.BuyerProfileTest do
  use Skiptip.ModelCase

  alias Skiptip.BuyerProfile
	alias Skiptip.User
  alias Skiptip.Factory

  @valid_attrs %{}
  @invalid_attrs %{}

	@tag :skip
  test "changeset with valid attributes" do
		changeset = BuyerProfile.changeset(%BuyerProfile{}, @valid_attrs)
		assert changeset.valid?
  end

	@tag :skip
  test "changeset with invalid attributes" do
		changeset = BuyerProfile.changeset(%BuyerProfile{}, @invalid_attrs)
		refute changeset.valid?
  end

	test "default bio is set" do
		user = Factory.create_user |> Repo.preload(:buyer_profile)
		default_bio = "hello world"
		assert user.buyer_profile.bio == default_bio
	end

	test "default picture is set" do
		user = Factory.create_user |> Repo.preload(:buyer_profile)
		default_picture_url = "https://s3.amazonaws.com/skiptip-development/public/no_profile_picture.png"
		assert user.buyer_profile.picture_url == default_picture_url
	end

end
