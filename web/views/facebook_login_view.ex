defmodule Skiptip.FacebookLoginView do
  use Skiptip.Web, :view
  
  def render("callback.json", %{response: response}) do
    response
  end

  def render("callback.json", %{error: error}) do
    error
  end

end
