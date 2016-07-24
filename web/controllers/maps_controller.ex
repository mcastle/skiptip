defmodule Skiptip.MapsController do
  use Skiptip.Web, :controller

  plug :put_layout, "map.html"

  def location_selector(conn, _params) do
    render(conn, "location_selector.html")
  end

end
