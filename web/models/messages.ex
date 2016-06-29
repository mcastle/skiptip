defmodule Skiptip.Message do
  use Skiptip.Web, :model
  import Ecto.Query
  alias Skiptip.Repo

  schema "messages" do
    field :recipient_id, :integer
    field :body, :string
    belongs_to :user, Skiptip.User
    timestamps
  end

	@required_fields ~w(user_id recipient_id body)
  @optional_fields ~w()


  def changeset(model, params) do
    model
      |> cast(params, @required_fields, @optional_fields)
  end

  def send(send_params) do
    case Skiptip.User.authenticate(send_params.user_id, send_params.api_key) do
      false -> :invalid_api_key
      user ->
        Ecto.build_assoc(user, :messages)
          |> changeset(send_params)
          |> Repo.insert!
    end
  end

end
