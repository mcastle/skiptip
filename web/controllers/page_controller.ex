defmodule Skiptip.PageController do
  use Skiptip.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
