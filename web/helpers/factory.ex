defmodule Skiptip.Factory do
  alias Skiptip.Utils
  alias Skiptip.Repo
  alias Skiptip.DevelopmentRepo
  alias Skiptip.User
  alias Skiptip.FacebookLogin
  alias Skiptip.BuyerProfile
  alias Skiptip.Location
  import Ecto.Query

  def create_user do
    name = random_full_name
    create_user(%{name: name, email: dummy_email_from_name(name)})
  end

  def create_user(associations) when is_list(associations) do
    user = User.changeset(%User{}) |> Repo.insert!
    Enum.each(associations, fn({table, changeset}) ->
      module_name = Atom.to_string(table) |> String.split("_") |> Enum.map_join( & String.capitalize &1 )
      module = String.to_existing_atom("Elixir.Skiptip.#{module_name}")

      model = Ecto.build_assoc(user, table)
      adapted_changeset = changeset_with_defaults(table, changeset)

      apply(module, :changeset, [model, adapted_changeset])
        |> Repo.insert!
    end)

    tables = Enum.map(associations, fn({table, _}) -> table end)
    Repo.get(User, user.id) |> Repo.preload(tables)
  end

  def create_user(buyer_profile_params) do
    User.create(facebook_access_token, facebook_user_id, buyer_profile_params)
  end

  def create_user(fb_access_token, fb_user_id) do
    name = random_full_name
    create_user(fb_access_token, fb_user_id, %{name: name, email: dummy_email_from_name(name)})
  end

  def create_user(fb_access_token, fb_user_id, buyer_profile_params) do
    User.create(fb_access_token, fb_user_id, buyer_profile_params)
  end

  def create_user_with_name(name) do
    dummy_buyer_profile_params(name) |> create_user |> Repo.preload(:buyer_profile)
  end

  # fb_uid for Brian Maxwell (that's me!)
  @facebook_user_id "10154127153411215"
  def create_user_with_valid_facebook_credentials(fb_uid \\ nil) do
    facebook_user_id = fb_uid || @facebook_user_id
    retrieve_access_token_from_development_db(facebook_user_id)
      |> User.create(facebook_user_id)
      |> Repo.preload(:facebook_login)
  end

  def dummy_buyer_profile_params, do: dummy_buyer_profile_params(random_full_name)
  def dummy_buyer_profile_params(name) do
    %{
      name: name,
      display_name: name,
      username: name,
      email: dummy_email_from_name(name),
      bio: Utils.lorem_ipsum
    }
  end

  def new_buyer_profile(params) do
    dummy_params = Map.get(params, :name, random_full_name) |> dummy_buyer_profile_params
    params = Map.merge(dummy_params, params)
    user = User.changeset(%User{}) |> Repo.insert!
    Ecto.build_assoc(user, :buyer_profile)
      |> BuyerProfile.changeset(:create, params)
  end

  def create_buyer_profile!(params), do: new_buyer_profile(params) |> Repo.insert!
  def create_buyer_profile!, do: create_buyer_profile!(dummy_buyer_profile_params)
  def create_buyer_profile(params), do: new_buyer_profile(params) |> Repo.insert
  def create_buyer_profile, do: create_buyer_profile(dummy_buyer_profile_params)

  def send_message(user1, user2, body) do
    Skiptip.Message.send(%{
      api_key: user1.api_key,
      user_id: user1.id,
      recipient_id: user2.id,
      body: body
    })
  end

  def retrieve_valid_facebook_api_credentials(facebook_user_id \\ nil) do
    facebook_user_id = facebook_user_id || @facebook_user_id
    {facebook_user_id, retrieve_access_token_from_development_db(facebook_user_id)}
  end

  def default_changeset(:buyer_profile) do
    dummy_buyer_profile_params
  end

  def default_changeset(:facebook_login) do
    %{
      facebook_user_id: facebook_user_id,
      facebook_access_token: facebook_access_token
    }
  end

  def default_changeset(:location) do
    %{ point: Location.point(45, 45) }
  end

  def default_changeset(:rides_provider_profile) do
    %{
      payment_types: "0",
      max_drive_distance: 10,
      rate: 300,
      max_seats: 2,
      available: false
    }
  end

  def changeset_with_defaults(table, changeset) do
    default_changeset(table) |> Map.merge(changeset)
  end

  defp random_full_name, do: "#{random_name} #{random_name}"
  defp random_name, do: Utils.random_string(10)
  def facebook_user_id, do: Utils.random_string_of_digits(17)
  def facebook_access_token, do: Utils.random_string(217)
  defp dummy_email_from_name(name), do: "#{name}@domain.com" |> String.replace(" ", "") |> String.downcase

  def retrieve_access_token_from_development_db(facebook_user_id) do
    %FacebookLogin{facebook_access_token: fb_access_token} = FacebookLogin
      |> where(facebook_user_id: ^facebook_user_id)
      |> DevelopmentRepo.one
    fb_access_token
  end

end
