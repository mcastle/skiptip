defmodule Skiptip.ContractTests do
  use ExUnit.Case, async: false
  use Plug.Test

  @tag :skip
  test "/login with valid credentials gives proper response" do
    {fb_uid, fb_access_token} = Skiptip.Factory.retrieve_valid_facebook_api_credentials

    url = "/api/login" + URI.encode_query(%{fb_access_token: fb_access_token, fb_uid: fb_uid})
    response = conn(:get, url) |> send_request

    facebook_login = Skiptip.FacebookLogin.find_by(:facebook_user_id, fb_uid)
    #user = User.f
    assert facebook_login


    assert response.status == 200


  end

  defp send_request(conn) do
    conn
    |> put_private(:plug_skip_csrf_protection, true)
    |> HelloPhoenix.Endpoint.call([])
  end
end
