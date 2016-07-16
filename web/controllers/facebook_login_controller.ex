defmodule Skiptip.FacebookLoginController do
  use Skiptip.Web, :controller

  alias Skiptip.FacebookLogin
  alias Skiptip.User
  alias Skiptip.Repo

  @facebook_callback_url "http://54.172.15.89/facebook_logins/callback"
  @facebook_client_id "504019469804454"
  @facebook_app_secret "3c071367622fc724dd500705d659170c"

  def new(conn, _params) do
    endpoint = "https://www.facebook.com/dialog/oauth?"
    params = %{
      client_id: @facebook_client_id,
      redirect_uri: @facebook_callback_url,
      auth_type: "rerequest",
      scope: "email"
    }
    redirect(conn, external: endpoint <> URI.encode_query(params))
  end

  def create(conn, params) do
    {action, user} = login_or_create_user(params["access_token"], params["user_id"])
    payload = %{api_key: user.api_key, user_id: user.id, action: action}
    render(conn, "login_success.json", payload: payload)
  end

  def callback(conn, params) do
    HTTPoison.start
    code = params["code"]
    access_token_url = "https://graph.facebook.com/v2.3/oauth/access_token"
    parameters = %{client_id: @facebook_client_id, client_secret: @facebook_app_secret, code: code, redirect_uri: @facebook_callback_url}
    get_request = HTTPoison.get!(access_token_url, [], params: parameters)
    %HTTPoison.Response{body: body, status_code: status_code} = get_request
    render_callback(conn, status_code, body)
  end

  def render_callback(conn, 200, body) do
    token = Poison.decode!(body)["access_token"]
    user_id = get_facebook_user_id(token)
    login_or_create_user(token, user_id)
    response = %{token: token, user_id: user_id}
    render(conn, "callback.json", response: response)
  end

  def render_callback(conn, 400, body) do
    body = Poison.decode! body
    render(conn, "callback.json", response: body)
  end

  def get_facebook_user_id(access_token) do
    user_id_url = "https://graph.facebook.com/me?fields=id&access_token=" <> access_token
    HTTPoison.start
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(user_id_url)
    Poison.decode!(body)["id"]
  end

  def login_or_create_user(facebook_access_token, facebook_user_id) do
    if facebook_token_valid(facebook_access_token) do
      case FacebookLogin.find_by(:facebook_user_id, facebook_user_id) do
        nil ->
          {:create,
            User.create(facebook_access_token, facebook_user_id)
              |> Repo.preload(:facebook_login)
          }
        login ->
          FacebookLogin.update_access_token(login, facebook_access_token)
          {:update,
            Repo.get(User, login.user_id) |> Repo.preload(:facebook_login)
          }
      end
    else
      {:invalid_access_token, "The access token provided was refused by facebook"}
    end
  end

  def facebook_token_valid(token) do
    url = "https://graph.facebook.com/me"
    params = %{access_token: token}
    request = Skiptip.Requests.get(url, params)
    request.status_code == 200
  end

end
