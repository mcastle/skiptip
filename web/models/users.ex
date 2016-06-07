defmodule Skiptip.User do
  use Skiptip.Web, :model
  import Ecto.Query
  alias Skiptip.Repo
  alias Skiptip.FacebookLogin
  alias Skiptip.BuyerProfile
  alias Skiptip.User

  schema "users" do

    has_one :facebook_login, FacebookLogin
    has_one :buyer_profile, BuyerProfile
    timestamps
  end

  @required_fields ~w()
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def create(token, facebook_user_id) do
    user = changeset(%User{}, %{}) |> Repo.insert!
    Ecto.build_assoc(user, :facebook_login, facebook_user_id: facebook_user_id, facebook_access_token: token)
      |> Repo.insert!
    Ecto.build_assoc(user, :buyer_profile) |> BuyerProfile.before_create(token, facebook_user_id) |> Repo.insert!
    user
  end

  def find_by(:id, id) do
    User
      |> where(id: ^id)
      |> Repo.one
  end
end
