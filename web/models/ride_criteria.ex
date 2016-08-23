defmodule Skiptip.RideCriteria do
  alias Skiptip.Repo
  alias Skiptip.RideCriteria
  use Skiptip.Web, :model

  schema "ride_criteria" do
    field :service_id, :integer
    field :origin, Geo.Point
    field :destination, Geo.Point
    field :pickup_time, Ecto.DateTime
    field :dropoff_time, Ecto.DateTime
    field :seat_count, :integer
    field :rate, :integer

    timestamps
  end

  @required_fields ~w(service_id origin destination rate)
  @optional_fields ~w(seat_count pickup_time dropoff_time)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def create(service_id, criteria) do
    cs = Map.merge(criteria, %{service_id: service_id})
    changeset(%RideCriteria{}, cs) |> Repo.insert
  end
end
