defmodule Skiptip.ContractTests do
  use ExUnit.Case, async: false
  use Plug.Test
  import Skiptip.Helpers.Requests

  setup do
    Skiptip.Utils.flush_tables
    on_exit fn ->
      Skiptip.Utils.flush_tables
    end
  end


  test "/api/login with new credentials gives proper response" do
    {fb_uid, fb_access_token} = Skiptip.Factory.retrieve_valid_facebook_api_credentials

    response = get_response("/api/login", %{access_token: fb_access_token, user_id: fb_uid})
    assert response.status == 200

    user = Skiptip.FacebookLogin.find_user_by(:facebook_user_id, fb_uid)
    expectation = %{action: :create, api_key: user.api_key, user_id: user.id} |> as_json
    assert response.resp_body == expectation
  end

  test "/api/login with existing credentials gives proper response" do
    user = Skiptip.Factory.create_user_with_valid_facebook_credentials
    uid = user.facebook_login.facebook_user_id
    access_token = Skiptip.Utils.random_string(200)
    response = get_response("/api/login", %{access_token: access_token, user_id: uid})

    expectation = %{action: :update, api_key: user.api_key, user_id: user.id} |> as_json
    assert response.resp_body == expectation
  end

  defp get_response(endpoint, params) do
    url = url(endpoint, params)
    conn(:get, url) |> send_request
  end

  defp as_json(map) do
    Poison.encode!(map)
  end

  defp send_request(conn) do
    conn
    |> put_private(:plug_skip_csrf_protection, true)
    |> Skiptip.Endpoint.call([])
  end
end
