defmodule Skiptip.PlacesView do
  use Skiptip.Web, :view

  def render("places.json", %{payload: payload}) do
    payload
  end

end
