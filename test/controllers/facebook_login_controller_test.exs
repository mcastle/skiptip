defmodule Skiptip.FacebookLoginControllerTest do
  use Skiptip.ConnCase
  alias Skiptip.FacebookLoginController, as: FacebookLoginController
  alias Skiptip.FacebookLogin

  alias Skiptip.FacebookLogin
  @valid_attrs %{}
  @invalid_attrs %{}
  @table "facebook_logins"

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates new facebook_login if first login" do
    token = "access_token"
    user_id = "12345678900987654321"
    refute FacebookLogin.find_by(:facebook_user_id, user_id)
    FacebookLoginController.login_or_create_user(token, user_id)
    assert FacebookLogin.find_by(:facebook_user_id, user_id)
  end

end
