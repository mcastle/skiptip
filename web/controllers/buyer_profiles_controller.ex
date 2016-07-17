defmodule Skiptip.BuyerProfilesController do
  use Skiptip.Web, :controller

  alias Skiptip.BuyerProfile

  def all(conn, params) do
    buyer_profile = buyer_profile(params)
    %{
      action: :get,
      display_name: buyer_profile.display_name,
      username: buyer_profile.username,
      bio: buyer_profile.bio,
      picture_url: buyer_profile.picture_url,
      email: buyer_profile.email
    } |> render_payload(conn)
  end

  def display_name(conn, params) do
    %{action: :get, display_name: buyer_profile(params).display_name}
      |> render_payload(conn)
  end

  def username(conn, params) do
    %{action: :get, username: buyer_profile(params).username}
      |> render_payload(conn)
  end

  def email(conn, params) do
    %{action: :get, username: buyer_profile(params).email}
      |> render_payload(conn)
  end

  def bio(conn, params) do
    %{action: :get, username: buyer_profile(params).bio}
      |> render_payload(conn)
  end

  def picture_url(conn, params) do
    %{action: :get, username: buyer_profile(params).picture_url}
      |> render_payload(conn)
  end

  defp buyer_profile(params) do
    BuyerProfile.find_by(:user_id, params["user_id"])
  end

  defp render_payload(payload, conn) do
    render(conn, "buyer_profile.json", payload: payload)
  end

end
