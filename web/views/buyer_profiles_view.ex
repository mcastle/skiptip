defmodule Skiptip.BuyerProfilesView do
  use Skiptip.Web, :view

  def render("buyer_profile.json", %{payload: payload}), do: payload

end
