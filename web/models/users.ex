defmodule Skiptip.User do
  use Skiptip.Web, :model
  import Ecto.Query
  alias Skiptip.Utils
  alias Skiptip.Repo
  alias Skiptip.FacebookLogin
  alias Skiptip.BuyerProfile
  alias Skiptip.User
  alias Skiptip.Message
  alias Skiptip.Location

  schema "users" do
    field :api_key, :string, unique: true
    has_one :facebook_login, FacebookLogin
    has_one :buyer_profile, BuyerProfile
    has_one :location, Location
    has_many :messages, Message
    timestamps
  end

  @required_fields ~w(api_key)
  @optional_fields ~w()

  def changeset(model) do
    changeset(model, default_params)
  end

  def changeset(model, params) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:api_key)
  end

  def default_params do
    %{ api_key: generate_api_key }
  end

  def generate_api_key do
    next_id = Repo.one(from u in User,
      select: u.id,
      order_by: [desc: u.inserted_at],
      limit: 1
    ) || 0
    Utils.random_string(10) <>
    "#{Utils.condense(next_id + 1)}" <>
    Utils.random_string(10)
  end

  def create(token, facebook_user_id, buyer_profile_params) do
    user = changeset(%User{}) |> Repo.insert!

    Ecto.build_assoc(user, :facebook_login)
      |> FacebookLogin.changeset(%{facebook_access_token: token, facebook_user_id: facebook_user_id})
      |> Repo.insert!

    Ecto.build_assoc(user, :buyer_profile)
      |> BuyerProfile.changeset(:create, buyer_profile_params)
      |> Repo.insert!

    Ecto.build_assoc(user, :location)
      |> Location.changeset(%{})
      |> Repo.insert!
    user
  end

  def create(fb_token, fb_uid) do
    create(fb_token, fb_uid, BuyerProfile.params_from_facebook(fb_token, fb_uid))
  end

  def authenticate(id, api_key) do
    user = Repo.get(User, id)
    user && user.api_key == api_key && user
  end
end
