defmodule Skiptip.FactoryTest do
  use ExUnit.Case
  alias Skiptip.Repo
  alias Skiptip.Factory
  alias Skiptip.Location
  alias Skiptip.User

  test "create_user_with_valid_facebook_credentials" do

    # sometimes this test runs before db is actually reloaded
    # causing a unique validation error where this method has
    # already been called before, so ensure relevant tables
    # are empty before running test
    Repo.delete_all(Skiptip.User)
    Repo.delete_all(Skiptip.BuyerProfile)
    Repo.delete_all(Skiptip.FacebookLogin)
    user = Factory.create_user_with_valid_facebook_credentials
      |> Repo.preload(:facebook_login)

    assert String.length(user.facebook_login.facebook_user_id) > 15
    assert String.length(user.facebook_login.facebook_access_token) > 200
  end

  # note, this test might be flaky depending on the state
  # of the development db. The dev db must have a facebook_login
  # with the facebook_user_id set below
  @facebook_user_id "10154127153411215"
  test "retrieve_access_token_from_development_db" do
    access_token = @facebook_user_id
      |> Factory.retrieve_access_token_from_development_db
    assert String.length(access_token) > 200
  end

  test "create_user also creates specified associations" do

    facebook_login_cs = %{ facebook_user_id: Factory.facebook_user_id }
    buyer_profile_cs = %{ username: "username" }
    location_cs = %{ point: Location.point({ 40, 60 }) }
    rides_provider_profile_cs = %{ available: true }

    user = Factory.create_user([
      { :facebook_login, facebook_login_cs },
      { :buyer_profile, buyer_profile_cs },
      { :location, location_cs },
      { :rides_provider_profile, rides_provider_profile_cs }
    ])

    assert Repo.get(User, user.id)
    assert user.facebook_login.facebook_user_id == facebook_login_cs.facebook_user_id
    assert user.buyer_profile.username == buyer_profile_cs.username
    assert Location.latlng(user.location) == Location.latlng(location_cs.point)
    assert user.rides_provider_profile.available == rides_provider_profile_cs.available
  end

end
