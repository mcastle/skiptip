defmodule Skiptip.ContractTests do
  use ExUnit.Case, async: false
  use Plug.Test
  import Skiptip.Requests
  import Skiptip.Utils
  alias Skiptip.Factory

  setup do
    Skiptip.Utils.flush_tables
    on_exit fn ->
      Skiptip.Utils.flush_tables
    end
  end

  test "/api/places/search returns JSON of results" do
    user = Factory.create_user
    params = %{
      location: "33.819251,-84.365075",
      query: "test",
      key: user.api_key,
      user_id: user.id
    }
    response = get_response("/api/places/search", params)
    assert response.status == 200
    parsed_response = response.resp_body |> to_map
    prediction_count = parsed_response["predictions"] |> Enum.count
    assert prediction_count == 5
    keys = parsed_response["predictions"] |> List.first |> Map.keys
    assert keys == ["description", "place_id", "types"]
  end

  test "/api/login with new credentials gives proper response" do
    {fb_uid, fb_access_token} = Factory.retrieve_valid_facebook_api_credentials

    response = get_response("/api/login", %{access_token: fb_access_token, user_id: fb_uid})
    assert response.status == 200

    user = Skiptip.FacebookLogin.find_user_by(:facebook_user_id, fb_uid)
    expectation = %{action: :create, api_key: user.api_key, user_id: user.id} |> to_json
    assert response.resp_body == expectation
  end

  test "/api/login with existing credentials gives proper response" do
    {fb_uid, fb_access_token} = Factory.retrieve_valid_facebook_api_credentials
    invalid_token = Skiptip.Utils.random_string(200)
    user = Factory.create_user(invalid_token, fb_uid)
    response = get_response("/api/login", %{access_token: fb_access_token, user_id: fb_uid})
    expectation = %{action: :update, api_key: user.api_key, user_id: user.id} |> to_json
    assert response.resp_body == expectation
  end

  test "/api/:user_id" do
    user = Factory.create_user_with_name("jeff smith")
    response = make_authenticated_api_call(user, "")
    expectation = %{
      action: :get,
      display_name: user.buyer_profile.display_name,
      username: user.buyer_profile.username,
      bio: user.buyer_profile.bio,
      picture_url: user.buyer_profile.picture_url,
      email: user.buyer_profile.email
    } |> to_json
    assert response.resp_body == expectation
  end

  test "/api/:user_id/display_name" do
    user = Factory.create_user_with_name("jeff smith")
    response = make_authenticated_api_call(user, "display_name")
    expectation = %{action: :get, display_name: user.buyer_profile.display_name} |> to_json
    assert response.resp_body == expectation
  end

  test "/api/:user_id/username" do
    user = Factory.create_user_with_name("jeff smith")
    response = make_authenticated_api_call(user, "username")
    expectation = %{action: :get, username: user.buyer_profile.username} |> to_json
    assert response.resp_body == expectation
  end

  test "api/:user_id/email" do
    user = Factory.create_user_with_name("jeff smith")
    response = make_authenticated_api_call(user, "email")
    expectation = %{action: :get, username: user.buyer_profile.email} |> to_json
    assert response.resp_body == expectation
  end

  test "api/:user_id/bio" do
    user = Factory.create_user_with_name("jeff smith")
    response = make_authenticated_api_call(user, "bio")
    expectation = %{action: :get, username: user.buyer_profile.bio} |> to_json
    assert response.resp_body == expectation
  end

  test "api/:user_id/picture_url" do
    user = Factory.create_user_with_name("jeff smith")
    response = make_authenticated_api_call(user, "picture_url")
    expectation = %{action: :get, username: user.buyer_profile.picture_url} |> to_json
    assert response.resp_body == expectation
  end

  defp make_authenticated_api_call(user, resource) do
    url = "/api/#{user.id}/#{resource}"
    get_response(url, %{api_key: user.api_key})
  end

  defp get_response(endpoint, params) do
    url = url(endpoint, params)
    conn(:get, url) |> send_request
  end

  defp send_request(conn) do
    conn
    |> put_private(:plug_skip_csrf_protection, true)
    |> Skiptip.Endpoint.call([])
  end
end
