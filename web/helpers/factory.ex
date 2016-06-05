defmodule Skiptip.Factory do
  import Ecto.Query

  def create_user do
    Skiptip.User.create(facebook_access_token, facebook_user_id)
  end

  @facebook_user_id "10154127153411215"
  def create_user_with_valid_facebook_credentials(fb_uid \\ nil) do
    facebook_user_id = fb_uid || @facebook_user_id
    retrieve_access_token_from_development_db(facebook_user_id)
      |> Skiptip.User.create(facebook_user_id)
  end

  def retrieve_access_token_from_development_db(facebook_user_id) do
    %Skiptip.FacebookLogin{facebook_access_token: fb_access_token} = Skiptip.FacebookLogin
      |> where(facebook_user_id: ^facebook_user_id)
      |> Skiptip.DevelopmentRepo.one
    fb_access_token
  end

  defp facebook_user_id, do: Skiptip.Utils.random_string_of_digits(17)
  defp facebook_access_token, do: Skiptip.Utils.random_string(217)

end
