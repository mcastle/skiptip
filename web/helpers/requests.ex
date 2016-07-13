defmodule Skiptip.Helpers.Requests do

  def url(endpoint, params) do
    endpoint <> "?" <> URI.encode_query(params)
  end

end
