defmodule Skiptip.Utils do

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end

  def random_string_of_digits(0), do: ""
  def random_string_of_digits(length) do
    inspect(:rand.uniform(10) - 1) <> random_string_of_digits(length - 1)
  end

  def condense(0), do: ""
  def condense(n) when is_integer(n) and n > 0 do
    n = n - 1
    alphabet = "bcdfghjklmnpqrstvwxz"
    s = String.length(alphabet)
    condense(div(n, s)) <> String.at(alphabet, rem(n, s))
  end

  def lorem_ipsum(length \\ "short") do
    #"Lorem ipsum dolor sit amet"
    endpoint = "http://loripsum.net/api/1/#{length}/plaintext"
    HTTPoison.start
    %HTTPoison.Response{status_code: 200, body: body} = HTTPoison.get!(endpoint)
    body
  end

  def flush_tables(tables \\ nil) do
    tables = tables || [Skiptip.User, Skiptip.BuyerProfile, Skiptip.FacebookLogin, Skiptip.Message]
    Enum.each tables, &Skiptip.Repo.delete_all(&1)
  end

end
