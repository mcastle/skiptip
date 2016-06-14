defmodule Skiptip.User do
  use Skiptip.Web, :model
  import Ecto.Query
  alias Skiptip.Utils
  alias Skiptip.Repo
  alias Skiptip.FacebookLogin
  alias Skiptip.BuyerProfile
  alias Skiptip.User

  schema "users" do
    field :api_key, :string, unique: true
    has_one :facebook_login, FacebookLogin
    has_one :buyer_profile, BuyerProfile
    timestamps
  end

  @required_fields ~w(api_key)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    if params == :empty, do: params = default_params
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:api_key) 
  end

  def default_params do
    %{
      api_key: generate_api_key
    }
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

  def create(token, facebook_user_id, name \\ nil) do
    user = changeset(%User{}, User.default_params) |> Repo.insert!

    facebook_login = Ecto.build_assoc(user, :facebook_login)
    FacebookLogin.changeset(facebook_login, %{facebook_access_token: token, facebook_user_id: facebook_user_id})
      |> Repo.insert!
 
    name = name || BuyerProfile.get_facebook_name(token, facebook_user_id)
    Ecto.build_assoc(user, :buyer_profile)
      |> BuyerProfile.changeset(:create, %{name: name})
      |> Repo.insert!
    user
  end

  def find_by(:id, id) do
    User
      |> where(id: ^id)
      |> Repo.one
  end
end
