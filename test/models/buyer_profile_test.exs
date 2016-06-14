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

  test "username must be unique" do
		Factory.create_buyer_profile!("Max", "mad_max")
		{:error, invalid} = Factory.create_buyer_profile("Rockatansky", "mad_max")
    refute invalid.valid?
  end

	test "default bio is set" do
		user = Factory. create_user_with_valid_facebook_credentials
            |> Repo.preload(:buyer_profile)
		default_bio = "hello world"
		assert user.buyer_profile.bio == default_bio
	end

	test "default picture is set" do
		user = Factory. create_user_with_valid_facebook_credentials
            |> Repo.preload(:buyer_profile)
		default_picture_url = "https://s3.amazonaws.com/skiptip-development/public/no_profile_picture.png"
		assert user.buyer_profile.picture_url == default_picture_url
	end

	test "default name is set to facebook name" do
		user = Factory.create_user_with_valid_facebook_credentials
			|> Repo.preload(:buyer_profile)
		assert user.buyer_profile.name == "Brian Maxwell"
	end

	test "default display_name is set based on facbeook name" do
		user = Factory.create_user_with_valid_facebook_credentials
			|> Repo.preload(:buyer_profile)
		assert user.buyer_profile.display_name == "Brian Maxwell"
	end

	test "default username is set based on facebook name" do
		next_username = "brian-" <> Skiptip.Utils.condense(700)
		user = Factory.create_user_with_valid_facebook_credentials
			|> Repo.preload(:buyer_profile)
		assert user.buyer_profile.username == next_username
	end

	test "generate_username" do
		next_username = "dave-" <> Skiptip.Utils.condense(700)
		username = BuyerProfile.generate_username("Dave Bowman")
		assert username == next_username
	end

	test "generate_username adjusts username for duplicates" do
		next_username = "tom-" <> Skiptip.Utils.condense(750)
		Factory.create_buyer_profile("Tom h", next_username)
		resolution_username = "tom-" <> Skiptip.Utils.condense(751)
		username = BuyerProfile.generate_username("Tom Peabody")
		assert username == resolution_username
	end

end
