defmodule Skiptip.Factory do
  alias Skiptip.Utils
  alias Skiptip.Repo
  alias Skiptip.DevelopmentRepo
  alias Skiptip.User
  alias Skiptip.FacebookLogin
  alias Skiptip.BuyerProfile
  import Ecto.Query

  def create_user(name \\ nil) do
    name = name || "anonymous"
    User.create(facebook_access_token, facebook_user_id, name)
  end

  # fb_uid for Brian Maxwell (that's me!)
  @facebook_user_id "10154127153411215"
  def create_user_with_valid_facebook_credentials(fb_uid \\ nil) do
    facebook_user_id = fb_uid || @facebook_user_id
    retrieve_access_token_from_development_db(facebook_user_id)
      |> User.create(facebook_user_id)
  end

  def create_buyer_profile do
    create_arbitrary_buyer_profile(random_full_name)
  end

  def create_arbitrary_buyer_profile(name) do
    username = Utils.random_string(20)
    create_buyer_profile(name, username)
  end

  def new_buyer_profile(name, username) do
    user = User.changeset(%User{}) |> Repo.insert!

    Ecto.build_assoc(user, :buyer_profile)
      |> BuyerProfile.changeset(:create, %{name: name, username: username})
  end

  def create_buyer_profile!(name, username) do
    new_buyer_profile(name, username) |> Repo.insert!
  end

  def create_buyer_profile(name, username) do
    new_buyer_profile(name, username) |> Repo.insert
  end

  def retreive_valid_facebook_api_credentials(facebook_user_id \\ nil) do
    facebook_user_id = facebook_user_id || @facebook_user_id
    %{
      facebook_access_token: retrieve_access_token_from_development_db(facebook_user_id),
      facebook_user_id: facebook_user_id
    }
  end

  defp random_full_name, do: "#{random_name} #{random_name}"
  defp random_name, do: Utils.random_string(10)
  defp facebook_user_id, do: Utils.random_string_of_digits(17)
  defp facebook_access_token, do: Utils.random_string(217)
  defp retrieve_access_token_from_development_db(facebook_user_id) do
    %FacebookLogin{facebook_access_token: fb_access_token} = FacebookLogin
      |> where(facebook_user_id: ^facebook_user_id)
      |> DevelopmentRepo.one
    fb_access_token
  end


end
