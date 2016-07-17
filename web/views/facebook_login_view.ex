defmodule Skiptip.FacebookLoginView do
  use Skiptip.Web, :view

  def render("callback.json", %{response: response}), do: response

  def render("callback.json", %{error: error}), do: error

  def render("login_success.json", %{payload: payload}), do: payload

end
