defmodule Skiptip.FacebookLogin do
  use Skiptip.Web, :model
  import Ecto.Query
  alias Skiptip.Repo
  alias Skiptip.FacebookLogin
  alias Skiptip.User

  schema "facebook_logins" do
    field :facebook_user_id, :string
    field :facebook_access_token, :string

    belongs_to :user, Skiptip.User
    timestamps
  end

  @required_fields ~w(facebook_user_id facebook_access_token)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:facebook_user_id)
  end

  def create(token, facebook_user_id) do
    changeset(%FacebookLogin{}, %{facebook_access_token: token, facebook_user_id: facebook_user_id})
    |> Repo.insert!
  end

  def update_access_token(model, new_token) do
    changeset(model, %{facebook_access_token: new_token}) |> Repo.update!
  end

  def find_by(:facebook_user_id, fb_user_id) do
    FacebookLogin
      |> where(facebook_user_id: ^fb_user_id)
      |> Repo.one
  end

  def find_user_by(:facebook_user_id, fb_user_id) do
    user = nil
    facebook_login = find_by(:facebook_user_id, fb_user_id) 
    if facebook_login do
      user = User.find_by(:id, facebook_login.user_id)
    end
    user
  end
end
