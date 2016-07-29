defmodule Skiptip.LayoutView do
  use Skiptip.Web, :view

  def render_scripts(module, template) do
    scripts_template = (String.split(template, ".") |> List.first) <> "_scripts.html"
    render_existing(module, scripts_template)
  end

end
