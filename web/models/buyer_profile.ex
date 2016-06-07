defmodule Skiptip.BuyerProfile do
  use Skiptip.Web, :model
  import Ecto.Query
  alias Skiptip.Repo
	alias Skiptip.BuyerProfile

  schema "buyer_profiles" do
    field :display_name, :string
    field :name, :string
    field :username, :string
    field :bio, :string
    field :picture_url, :string

    belongs_to :user, Skiptip.User
    timestamps
  end

	def before_create(buyer_profile) do
		initial_values = %{
			bio: "hello world",
			picture_url: "https://s3.amazonaws.com/skiptip-development/public/no_profile_picture.png"}
		Map.merge(buyer_profile, initial_values)
	end 

  #@required_fields ~w(user_id, name, username, display_name)
	@required_fields ~w()
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
	
	def find_by(:user_id, user_id) do
    BuyerProfile
      |> where(user_id: ^user_id)
      |> Repo.one
	end

end