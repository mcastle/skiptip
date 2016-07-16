defmodule Skiptip.Requests do

  def url(endpoint, params) do
    endpoint <> "?" <> URI.encode_query(params)
  end

  def get(endpoint, params) do
    HTTPoison.start
    url(endpoint, params) |> HTTPoison.get!
  end

end
