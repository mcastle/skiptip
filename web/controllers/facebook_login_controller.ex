defmodule Skiptip.FacebookLoginController do
  use Skiptip.Web, :controller

  alias Skiptip.FacebookLogin
  alias Skiptip.User
  import Skiptip.Router.Helpers

  plug :scrub_params, "facebook_login" when action in [:create, :update]

  def new(conn, _params) do
    app_id = "504019469804454"
    callback_url = facebook_login_url(conn, :callback)
    code_url = "https://www.facebook.com/dialog/oauth?"
    code_url = code_url <> "client_id=" <> app_id <>"&"
    code_url = code_url <> "redirect_uri=" <> callback_url <> "&"
    code_url = code_url <> "auth_type=rerequest&"
    code_url = code_url <> "scope=email"
    redirect(conn, external: code_url)
  end

  def callback(conn, params) do
    app_id = "504019469804454"
    app_secret = "3c071367622fc724dd500705d659170c"
    code = params["code"]
    callback_url = facebook_login_url(conn, :callback)
    access_token_url = "https://graph.facebook.com/v2.3/oauth/access_token?"
    access_token_url = access_token_url <> "client_id=" <> app_id <> "&"
    access_token_url = access_token_url <> "client_secret=" <> app_secret <> "&"
    access_token_url = access_token_url <> "code=" <> code <> "&"
    access_token_url = access_token_url <> "redirect_uri=" <> callback_url
    HTTPoison.start
    case HTTPoison.get(access_token_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        token = Poison.decode!(body)["access_token"]
        user_id = get_facebook_user_id_from_access_token(token)
        login_or_create_user(token, user_id)
        render(conn, "callback.json", response: [token, user_id])
      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        #error = Poison.encode!(Poison.decode!(body)["error"])
        render(conn, "callback.json", response: body)
    end
  end

  def get_facebook_user_id_from_access_token(token) do
    user_id_url = "https://graph.facebook.com/me?fields=id&access_token=" <> token
    HTTPoison.start
    case HTTPoison.get(user_id_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Poison.decode!(body)["id"]
    end
  end

  def login_or_create_user(facebook_access_token, facebook_user_id) do
    unless FacebookLogin.find_by(:facebook_user_id, facebook_user_id) do
      User.create(facebook_access_token, facebook_user_id)
    end
    #login(token, user_id
  end

end
