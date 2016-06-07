defmodule Skiptip.Utils do

  def random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
  
  def random_string_of_digits(0), do: ""

  def random_string_of_digits(length) do
    inspect(:random.uniform(10) - 1) <> random_string_of_digits(length - 1)
  end

end