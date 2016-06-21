defmodule Skiptip.BuyerProfile do
  use Skiptip.Web, :model
  import Ecto.Query
  alias Skiptip.Repo
	alias Skiptip.BuyerProfile

  schema "buyer_profiles" do
    field :display_name, :string
    field :name, :string
    field :username, :string, unique: true
    field :bio, :string
    field :picture_url, :string
    field :email, :string, unique: true

    belongs_to :user, Skiptip.User
    timestamps
  end

	def default_params(params) do
    %{name: name} = params
		%{
			bio: "hello world",
			picture_url: "https://s3.amazonaws.com/skiptip-development/public/no_profile_picture.png",
      display_name: name,
      username: generate_username(name)
		} |> Map.merge(params)
	end

  def default_params(nil), do: %{}

	@required_fields ~w(user_id name username display_name bio email)
  @optional_fields ~w(picture_url)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, :create, :empty), do: changeset(model, default_params(nil))
  def changeset(model, :create, params), do: changeset(model, default_params(params))
  def changeset(model), do: changeset(model, :empty)
  def changeset(model, params) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:username) 
    |> unique_constraint(:email)
  end

  def params_from_facebook(fb_token, fb_uid) do
		url = "https://graph.facebook.com/v2.6/#{fb_uid}?access_token=#{fb_token}&fields=name,email"
    HTTPoison.start
    %HTTPoison.Response{status_code: status_code, body: body} = HTTPoison.get!(url)
    %{
      name: Poison.decode!(body)["name"],
      email: Poison.decode!(body)["email"]
    }
  end

	def generate_username(name) do
		name = name || ""
		first_name = name |> String.downcase |> String.split |> List.first
		ilike = "#{first_name}-%"
		count = Repo.one from bp in BuyerProfile,
						where: ilike(bp.username, ^ilike),
						select: count("*")
		inflated_count = 700 + (count * 50)
		find_first_distinct_username(first_name, inflated_count)
	end

	def find_first_distinct_username(first_name, count) do
		condensed = Skiptip.Utils.condense(count)
		candidate_username = "#{first_name}-#{condensed}"
		conflicting_buyer_profile = BuyerProfile
																|> where(username: ^candidate_username)
																|> Repo.one
		case conflicting_buyer_profile do
			nil -> candidate_username
			_ -> find_first_distinct_username(first_name, count + 1)
		end
	end
	
	def find_by(:user_id, user_id) do
    BuyerProfile
      |> where(user_id: ^user_id)
      |> Repo.one
	end

end
