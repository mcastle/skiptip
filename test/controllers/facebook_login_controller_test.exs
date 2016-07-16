defmodule Skiptip.FacebookLoginControllerTest do
  use Skiptip.ConnCase
  alias Skiptip.FacebookLoginController, as: FacebookLoginController
  alias Skiptip.FacebookLogin

  @valid_attrs %{}
  @invalid_attrs %{}
  @table "facebook_logins"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "login_or_create_user creates new facebook_login if first login" do
    {user_id, token} = Skiptip.Factory.retrieve_valid_facebook_api_credentials

    refute FacebookLogin.find_by(:facebook_user_id, user_id)
    {:create, user} = FacebookLoginController.login_or_create_user(token, user_id)
    assert user.facebook_login
    assert user.facebook_login.facebook_access_token == token
  end

  test "login_or_create_user updates facebook_login if facebook_user_id exists" do
    {user_id, token} = Skiptip.Factory.retrieve_valid_facebook_api_credentials
    invalid_token = Skiptip.Utils.random_string(200)
    Skiptip.Factory.create_user(invalid_token, user_id)

    login = FacebookLogin.find_by(:facebook_user_id, user_id)
    assert login.facebook_access_token == invalid_token

    {:update, user} = FacebookLoginController.login_or_create_user(token, user_id)
    assert user.facebook_login.facebook_access_token == token
  end

  test "login_or_create_user fails if access token is invalid" do
    {user_id, _} = Skiptip.Factory.retrieve_valid_facebook_api_credentials
    invalid_token = Skiptip.Utils.random_string(200)

    {result, _} = FacebookLoginController.login_or_create_user(invalid_token, user_id)
    assert result == :invalid_access_token
  end

  test "facebook_token_valid returns true if access token is valid" do
    {user_id, token} = Skiptip.Factory.retrieve_valid_facebook_api_credentials
    assert FacebookLoginController.facebook_token_valid(token)
  end

  test "facebook_token_valid returns false if access token is invalid" do
    token = Skiptip.Utils.random_string(200)
    refute FacebookLoginController.facebook_token_valid(token)
  end
end
