defmodule Skiptip.FactoryTest do
  use ExUnit.Case
  alias Skiptip.Factory

  test "create_user_with_valid_facebook_credentials" do
    user = Factory.create_user_with_valid_facebook_credentials
      |> Skiptip.Repo.preload(:facebook_login)

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

end
