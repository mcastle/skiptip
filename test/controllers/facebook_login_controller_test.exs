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

  test "creates new facebook_login if first login" do
    {user_id, token} = Skiptip.Factory.retrieve_valid_facebook_api_credentials

    refute FacebookLogin.find_by(:facebook_user_id, user_id)
    FacebookLoginController.login_or_create_user(token, user_id)
    login = FacebookLogin.find_by(:facebook_user_id, user_id)
    assert login
    assert login.facebook_access_token == token
  end

  test "updates facebook_login if facebook_user_id exists" do
    {user_id, token} = Skiptip.Factory.retrieve_valid_facebook_api_credentials

    FacebookLoginController.login_or_create_user(token, user_id)
    login = FacebookLogin.find_by(:facebook_user_id, user_id)
    assert login.facebook_access_token == token

    new_token = Skiptip.Utils.random_string(200)
    FacebookLoginController.login_or_create_user(new_token, user_id)
    login = FacebookLogin.find_by(:facebook_user_id, user_id)
    assert login.facebook_access_token == new_token
  end
end
