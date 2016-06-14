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
    %{facebook_access_token: token, facebook_user_id: user_id} = Skiptip.Factory.retreive_valid_facebook_api_credentials

    refute FacebookLogin.find_by(:facebook_user_id, user_id)
    FacebookLoginController.login_or_create_user(token, user_id)
    login = FacebookLogin.find_by(:facebook_user_id, user_id)
    assert login
    assert login.facebook_access_token == token
  end
end
